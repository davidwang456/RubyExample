# 引入 Selenium WebDriver 库，用于浏览器自动化测试
require 'selenium-webdriver'
# 引入 FileUtils 库，用于文件和目录操作
require 'fileutils'
# 引入 Windows API 支持
require 'win32/api'

# 定义 Cucumber 测试步骤，匹配"Export file to [目录] by click the [按钮]"格式的步骤
# (.*?) 和 (.) 是正则表达式捕获组，用于获取参数值
Given(/^Export file to (.*?)$ by click the (.*?)$/) do |download_dir, export_button|
    # 转换路径格式为 Windows 格式
    download_dir = download_dir.gsub('/', '\\')
    
    # 检查下载目录是否存在，如果不存在则创建目录
    unless File.exist?(download_dir)
        FileUtils.mkdir_p(download_dir)
    end
    
    # 使用 Browser 类(自定义类)创建实例，并通过 XPath 查找页面上的导出按钮
    export_ele = Browser.new.find_element(:xpath, "//button[text()='#{export_button}']")
    
    # 点击导出按钮，触发文件导出操作
    export_ele.click
    
    # 等待文件保存对话框出现
    sleep(2)
    
    begin
        # 使用 Windows API 模拟键盘输入
        # 输入完整路径
        type_text(download_dir)
        sleep(1)
        
        # 按回车键确认
        press_key(0x0D) # VK_RETURN
    rescue Exception => e
        $world.log "Error during file save: #{e.message}"
        $world.log e.backtrace.join("\n")
        raise
    end
end

# 辅助方法：模拟键盘输入文本
def type_text(text)
    text.each_char do |char|
        # 获取字符的虚拟键码
        vk = char.ord
        # 按下键
        press_key(vk)
        # 释放键
        release_key(vk)
        sleep(0.1) # 短暂延迟确保输入稳定
    end
end

# 辅助方法：按下键盘按键
def press_key(vk)
    # 使用 Windows API 发送按键
    user32 = Win32::API.new('user32', 'keybd_event', 'IIII', 'I')
    user32.call(vk, 0, 0, 0)
end

# 辅助方法：释放键盘按键
def release_key(vk)
    # 使用 Windows API 释放按键
    user32 = Win32::API.new('user32', 'keybd_event', 'IIII', 'I')
    user32.call(vk, 0, 2, 0)
end

# 定义 Cucumber 测试步骤，匹配"Walker Simulate input (type|key) (.*?)"格式的步骤
# (type|key) 表示可以匹配"type"或"key"两种模式
# (.*?) 表示捕获任意文本作为参数
Given(/^Walker Simulate input (type|key) (.*?)$/) do |mode, word|
    begin
        if mode == 'type'
            type_text(word)
        else
            # 处理特殊按键
            case word.upcase
            when 'CTRL+C'
                press_key(0x11) # VK_CONTROL
                press_key(0x43) # VK_C
                release_key(0x43)
                release_key(0x11)
            when 'CTRL+V'
                press_key(0x11) # VK_CONTROL
                press_key(0x56) # VK_V
                release_key(0x56)
                release_key(0x11)
            when 'CTRL+L'
                press_key(0x11) # VK_CONTROL
                press_key(0x4C) # VK_L
                release_key(0x4C)
                release_key(0x11)
            when 'RETURN', 'ENTRE'
                press_key(0x0D) # VK_RETURN
            else
                # 其他按键处理
                vk = get_virtual_key_code(word)
                press_key(vk)
                release_key(vk)
            end
        end
        
        # 添加短暂延迟确保命令执行完成
        sleep(0.5)
        
    rescue Exception => e
        $world.log "Error during input simulation: #{e.message}"
        $world.log e.backtrace.join("\n")
        raise
    end
end

# 辅助方法：获取虚拟键码
def get_virtual_key_code(key)
    # 常用按键的虚拟键码映射
    vk_codes = {
        'ctrl' => 0x11,
        'c' => 0x43,
        'v' => 0x56,
        'l' => 0x4C,
        'return' => 0x0D,
        'enter' => 0x0D
    }
    
    vk_codes[key.downcase] || key.ord
end

