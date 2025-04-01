# Sinatra 框架及其主要组件

## 1. Sinatra 框架简介
- 一个轻量级的 Ruby Web 应用框架
- 设计理念是"小而美"，代码简洁优雅
- 适合构建小型 Web 应用和 API
- 由 Blake Mizerany 在 2007 年创建

## 2. 核心组件

### a. 路由系统
```ruby
# 基本路由
get '/hello' do
  'Hello World!'
end

# 带参数的路由
get '/users/:id' do
  "用户 ID: #{params[:id]}"
end

# 多种 HTTP 方法支持
post '/upload' do
  # 处理文件上传
end

put '/update' do
  # 处理更新
end

delete '/remove' do
  # 处理删除
end
```

### b. 视图系统
```ruby
# 支持多种模板引擎
# ERB (默认)
erb :index

# Haml
haml :index

# Slim
slim :index
```

### c. 配置系统
```ruby
configure do
  # 开发环境配置
  set :environment, :development
  # 会话配置
  enable :sessions
  # 静态文件配置
  set :public_folder, 'public'
end

configure :development do
  # 开发环境特定配置
end

configure :production do
  # 生产环境特定配置
end
```

## 3. 常用扩展

### a. Sinatra::Reloader
```ruby
require 'sinatra/reloader'
# 开发环境下自动重载代码
```

### b. Sinatra::Contrib
```ruby
require 'sinatra/contrib'
# 提供额外的功能，如：
# - 响应缓存
# - 多语言支持
# - 命名路由
```

### c. Sinatra::ActiveRecord
```ruby
require 'sinatra/activerecord'
# 集成 ActiveRecord ORM
```

## 4. 中间件支持
```ruby
# 使用 Rack 中间件
use Rack::Session::Cookie
use Rack::Protection
```

## 5. 请求处理
```ruby
# 请求参数
params[:name]

# 请求头
request.headers['User-Agent']

# 请求体
request.body.read

# 文件上传
params[:file][:tempfile]
```

## 6. 响应处理
```ruby
# 设置状态码
status 404

# 设置响应头
headers 'Content-Type' => 'application/json'

# 重定向
redirect '/new-path'

# 发送文件
send_file 'path/to/file'
```

## 7. 错误处理
```ruby
# 自定义错误页面
error 404 do
  '页面未找到'
end

# 异常处理
error do
  '发生错误'
end
```

## 8. 过滤器
```ruby
# 前置过滤器
before do
  # 在请求处理前执行
end

# 后置过滤器
after do
  # 在请求处理后执行
end
```

## 9. 辅助方法
```ruby
# 定义辅助方法
helpers do
  def current_user
    # 获取当前用户
  end
end
```

## 10. 安全特性
```ruby
# CSRF 保护
enable :protection

# 会话安全
set :session_secret, 'your-secret-key'
```

## 11. 部署选项
- 支持多种 Web 服务器：
  - Thin
  - Puma
  - Unicorn
  - Passenger
- 支持多种部署平台：
  - Heroku
  - AWS
  - DigitalOcean
  - 自托管服务器

## 应用场景
Sinatra 的设计理念是"约定优于配置"，它提供了必要的功能，同时保持简单和灵活。这使得它特别适合：
- 小型 Web 应用
- API 服务
- 原型开发
- 微服务架构

## 在我们的项目中的应用
在我们的文件上传下载应用中，我们主要使用了：
- 路由系统（处理上传和下载请求）
- 视图系统（显示文件列表）
- 配置系统（设置上传目录）
- 会话管理（显示操作消息）
- 文件处理（处理文件上传和下载） 