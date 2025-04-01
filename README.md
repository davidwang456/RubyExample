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