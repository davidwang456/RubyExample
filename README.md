# 文件导出自动化测试工具

## 功能概述

这个项目实现了一个文件导出和保存的自动化测试工具，主要解决了浏览器文件下载对话框无法直接通过 Selenium WebDriver 控制的问题。通过模拟键盘输入，实现了完整的文件导出测试流程。

## 主要组件

该项目包含两个主要功能：

1. **文件导出操作**：
   - 查找并点击导出按钮
   - 准备下载目录
   - 处理文件保存对话框

2. **键盘输入模拟**：
   - 支持文本输入（type）
   - 支持按键操作（key）
   - 支持组合键（如 ctrl+c）

## 技术特点

- 使用 **Selenium WebDriver** 实现浏览器操作
- 使用 **xdotool** 实现键盘输入模拟
- 集成 **Cucumber** BDD 测试框架
- 结合了 Web 测试和系统操作

## 工作流程

1. 检查并创建下载目录
2. 使用 XPath 定位导出按钮
3. 点击导出按钮
4. 处理文件保存对话框：
   - 使用 Ctrl+C 复制当前内容
   - 输入下载目录路径
   - 使用 Ctrl+V 粘贴路径
   - 确认保存操作

## xdotool 工具说明

**xdotool** 是一个 Linux 系统下的命令行工具，用于模拟键盘输入和鼠标操作。在这个项目中，它主要用于模拟键盘输入操作：

- `type` 模式：模拟键盘输入文本
- `key` 模式：模拟按下特定按键

主要优势：
- 可以模拟真实的用户输入
- 支持复杂的按键组合
- 可以操作任何窗口
- 支持自动化脚本编写

## 使用限制

- 仅支持 Linux 系统（xdotool 是 Linux 工具）
- 需要 X Window System
- 需要适当的系统权限
- 硬编码的路径和按钮文本限制了灵活性
- 固定的等待时间可能导致稳定性问题

## 环境准备

### Windows 环境
1. 安装 Ruby 环境
   - 访问 [RubyInstaller for Windows](https://rubyinstaller.org/) 下载并安装 Ruby
   - 建议安装 Ruby+Devkit 版本，如 Ruby+Devkit 3.2.X (x64)
   - 安装时请勾选"Add Ruby executables to your PATH"选项

2. 安装必要的依赖
   ```bash
   gem install selenium-webdriver
   gem install cucumber
   gem install rspec
   ```

3. 安装 Chrome 浏览器和 ChromeDriver
   - 下载并安装 [Chrome 浏览器](https://www.google.com/chrome/)
   - 下载与 Chrome 浏览器版本匹配的 [ChromeDriver](https://sites.google.com/chromium.org/driver/)
   - 将 ChromeDriver 添加到系统环境变量 PATH 中

### Linux 环境
1. 安装 Ruby 环境
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install ruby ruby-dev build-essential

   # CentOS/RHEL
   sudo yum install ruby ruby-devel gcc gcc-c++ make
   ```

2. 安装必要的依赖
   ```bash
   gem install selenium-webdriver
   gem install cucumber
   gem install rspec
   
   # Ubuntu/Debian
   sudo apt-get install xdotool
   
   # CentOS/RHEL
   sudo yum install epel-release
   sudo yum install xdotool
   ```

3. 安装 Chrome 浏览器和 ChromeDriver
   ```bash
   # Ubuntu/Debian
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
   sudo dpkg -i google-chrome-stable_current_amd64.deb
   sudo apt --fix-broken install

   # CentOS/RHEL
   sudo dnf install wget
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
   sudo dnf install ./google-chrome-stable_current_x86_64.rpm

   # 安装 ChromeDriver（适用于所有 Linux 发行版）
   CHROME_VERSION=$(google-chrome --version | cut -d ' ' -f 3)
   CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION%.*}")
   wget "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
   unzip chromedriver_linux64.zip
   sudo mv chromedriver /usr/local/bin/
   sudo chmod +x /usr/local/bin/chromedriver
   ```

4. 确保 X Window System 已安装
   ```bash
   # Ubuntu/Debian
   sudo apt install xorg
   
   # CentOS/RHEL
   sudo yum groupinstall "X Window System"
   ```

### Docker 环境
1. 构建 Docker 镜像
   ```bash
   docker build -t ruby-test-env .
   ```

2. 运行测试容器
   ```bash
   # 基本运行命令
   docker run -it --rm \
     -v $(pwd):/app \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     ruby-test-env

   # 如果需要指定下载目录
   docker run -it --rm \
     -v $(pwd):/app \
     -v /path/to/downloads:/downloads \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     ruby-test-env
   ```

3. 参数说明：
   - `-it`: 交互式终端
   - `--rm`: 容器停止后自动删除
   - `-v $(pwd):/app`: 挂载当前目录到容器的 /app 目录
   - `-e DISPLAY=$DISPLAY`: 设置显示环境变量
   - `-v /tmp/.X11-unix:/tmp/.X11-unix`: 共享 X11 socket
   - `-v /path/to/downloads:/downloads`: 挂载下载目录（可选）

4. 注意事项：
   - 确保主机系统已安装 Docker
   - 确保主机系统已安装 X Window System
   - 在 Linux 主机上可能需要运行 `xhost +local:` 允许 Docker 访问 X server
   - Windows 用户需要使用 X Server（如 VcXsrv）并相应调整 DISPLAY 环境变量

## 使用方法

1. 确保已安装必要的依赖：
   ```
   gem install selenium-webdriver
   sudo apt-get install xdotool  # 对于 Ubuntu/Debian 系统
   ```

2. 在 Cucumber 测试中使用：
   ```gherkin
   Scenario: 导出文件
     Given Export file to C:\Download by click the Export
   ```

## 改进建议

1. **参数化配置**：
   - 使用配置文件替代硬编码的路径和按钮文本
   - 增加可配置的等待时间

2. **增强错误处理**：
   - 修复异常处理中的语法错误
   - 添加重试机制

3. **增加跨平台支持**：
   - 对于 Windows：使用 SendKeys 或 AutoHotkey
   - 对于 macOS：使用 osascript 或 AppleScript
   - 提供统一的接口

4. **改进测试稳定性**：
   - 使用智能等待机制
   - 添加超时和错误恢复
   - 增加详细的测试日志

## 示例代码改进

```ruby
def simulate_input(mode, word)
  case RbConfig::CONFIG['host_os']
  when /linux/
    system("xdotool #{mode} #{word}")
  when /mswin|mingw/
    # Windows 实现
    system("powershell -command \"[System.Windows.Forms.SendKeys]::SendWait('#{word}')\"")
  when /darwin/
    # macOS 实现
    system("osascript -e 'tell application \"System Events\" to keystroke \"#{word}\"'")
  else
    raise "Unsupported operating system"
  end
end
```

## 贡献

欢迎提交 Pull Request 或提出 Issue 来改进这个项目。特别是关于跨平台支持和稳定性改进的贡献。 