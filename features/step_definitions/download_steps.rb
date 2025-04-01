require 'selenium-webdriver'
require 'fileutils'

Given('打开浏览器') do
  # 设置 Chrome 的下载目录
  download_dir = 'C:\Users\david\Downloads\test\david'
  
  # 创建下载目录（如果不存在）
  FileUtils.mkdir_p(download_dir)
  
  # 配置 Chrome 选项
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_preference('download.default_directory', download_dir)
  options.add_preference('download.prompt_for_download', false)
  options.add_preference('download.directory_upgrade', true)
  options.add_preference('safebrowsing.enabled', true)
  
  # 启动浏览器
  @driver = Selenium::WebDriver.for :chrome, options: options
end

Given('访问测试页面') do
  # 使用本地测试页面的完整路径
  test_page_path = File.expand_path('test_page.html', Dir.pwd)
  @driver.get "file://#{test_page_path}"
end

When('Export file to {word} by click the {word}') do |download_dir, export_button|
  # 点击导出按钮
  export_ele = @driver.find_element(:id, 'exportBtn')
  export_ele.click
  
  # 等待一段时间让文件下载完成
  sleep(5)
end

Then('文件应该被下载到指定目录') do
  download_dir = 'C:\Users\david\Downloads\test\david'
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