require 'sinatra'
require 'sinatra/reloader' if development?

configure do
  enable :sessions
  set :public_folder, 'public'
  set :uploads_dir, File.join(File.dirname(__FILE__), 'uploads')
  FileUtils.mkdir_p(settings.uploads_dir) unless File.directory?(settings.uploads_dir)
end

# 文件上传表单
get '/upload' do
  erb :index
end

# 处理文件上传
post '/upload' do
  if params[:file] && (tempfile = params[:file][:tempfile])
    filename = params[:file][:filename]
    target = File.join(settings.uploads_dir, filename)
    
    File.open(target, 'wb') { |f| f.write(tempfile.read) }
    session[:message] = "文件 #{filename} 上传成功"
    redirect '/files'
  else
    session[:error] = "请选择要上传的文件"
    redirect back
  end
end

# 文件列表展示
get '/files' do
  @files = Dir.glob(File.join(settings.uploads_dir, '*')).map do |f| 
    {
      name: File.basename(f),
      size: format_file_size(File.size(f)),
      modified: File.mtime(f).strftime('%Y-%m-%d %H:%M:%S')
    }
  end
  erb :files
end

# 文件下载
get '/download/:filename' do
  filename = params[:filename]
  filepath = File.join(settings.uploads_dir, filename)
  
  if File.exist?(filepath)
    # 设置响应头，强制浏览器下载文件
    headers(
      'Content-Type' => 'application/octet-stream',
      'Content-Disposition' => "attachment; filename=\"#{filename}\"",
      'Content-Length' => File.size(filepath).to_s
    )
    send_file filepath
  else
    status 404
    "文件不存在"
  end
end

# 辅助方法：格式化文件大小
def format_file_size(size)
  units = ['B', 'KB', 'MB', 'GB', 'TB']
  index = 0
  while size >= 1024 && index < units.length - 1
    size /= 1024.0
    index += 1
  end
  "#{size.round(2)} #{units[index]}"
end