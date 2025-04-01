require 'selenium-webdriver'
require 'fileutils'

Given('打开浏览器') do
  # 检查 xdotool 是否已安装
  unless system('which xdotool > /dev/null 2>&1')
    raise "xdotool 未安装。请先安装：\n" \
          "Ubuntu/Debian: sudo apt-get install xdotool\n" \
          "CentOS/RHEL: sudo yum install xdotool"
  end
  
  # 启动浏览器
  @driver = Selenium::WebDriver.for :chrome
end

Given('访问测试页面') do
  # 使用本地测试页面的完整路径
  test_page_path = File.expand_path('test_page.html', Dir.pwd)
  @driver.get "file://#{test_page_path}"
end

When('Export file to {word} by click the {word}') do |download_dir, export_button|
  # 转换路径格式为 Linux 格式
  download_dir = download_dir.gsub('\\', '/')
  # 确保路径以 / 开头
  download_dir = "/#{download_dir}" unless download_dir.start_with?('/')
  
  # 检查下载目录是否存在，如果不存在则创建目录
  unless File.exist?(download_dir)
    FileUtils.mkdir_p(download_dir)
  end
  
  # 点击导出按钮
  export_ele = @driver.find_element(:id, 'exportBtn')
  export_ele.click
  
  # 等待文件保存对话框出现
  sleep(2)
  
  begin
    # 查找并激活保存对话框窗口
    system('xdotool search --name "Save As" windowactivate')
    sleep(1)
    
    # 使用 xdotool 模拟键盘输入
    # 输入完整路径
    system("xdotool type '#{download_dir}'")
    sleep(1)
    
    # 按回车键确认
    system('xdotool key Return')
    sleep(1)
    
  rescue Exception => e
    puts "文件保存过程中出错: #{e.message}"
    puts e.backtrace.join("\n")
    raise
  end
end

Then('文件应该被下载到指定目录') do
  download_dir = '/home/david/Downloads/test'
  # 等待文件下载完成
  sleep(5)
  
  # 检查目录中是否有文件
  files = Dir.entries(download_dir).reject { |f| f == '.' || f == '..' }
  if files.empty?
    raise "没有找到下载的文件在目录: #{download_dir}"
  end
  
  puts "成功下载文件到: #{download_dir}"
  puts "下载的文件: #{files.join(', ')}"
  
  # 清理下载的文件
  # FileUtils.rm_rf(download_dir)
end

# 辅助方法：使用 xdotool 模拟键盘输入
def simulate_keyboard_input(text)
  system("xdotool type '#{text}'")
  sleep(0.5)
end

# 辅助方法：使用 xdotool 模拟按键
def simulate_key(key)
  system("xdotool key #{key}")
  sleep(0.5)
end 