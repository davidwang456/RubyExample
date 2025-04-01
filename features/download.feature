Feature: 文件下载测试
  作为用户
  我想要能够下载文件
  以便验证下载功能是否正常工作

  Scenario: 下载文件到指定目录
    Given 打开浏览器
    And 访问测试页面
    When Export file to C:\Users\david\Downloads\test by click the Export
    Then 文件应该被下载到指定目录 