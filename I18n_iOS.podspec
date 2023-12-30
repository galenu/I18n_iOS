#
# Be sure to run `pod lib lint I18n_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'I18n_iOS'
  s.version          = '0.0.5'
  s.summary          = 'iOS多语言国际化页面实时刷新方案.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
# i18n: iOS多语言国际化页面实时刷新方案

### 需求: app内提供更换语言功能, 在app内更改语言后，已经创建的页面及时刷新，不能销毁根控制器重新创建。

  #### 有以下难点问题:
    1. 跟app关联的语言国际化，只能通过代码控制，xib怎么国际化？
    2. 不销毁根控制器重新创建，已经创建的页面怎么刷新？如果是每个页面加通知，那每个页面需要刷新的部分怎么抽取？对业务代码逻辑影响多大？是否有明确规范，新人接替是否好维护？
    3. 跟语言关联的有静态页面控件刷新，业务逻辑刷新(如banner图上有文字，语言改变后banner图也需要刷新)
    4. 怎么控制刷新粒度，如果栈里的静态控件太多，业务逻辑刷新太多，一次性全部刷新是否会影响性能？还是分批刷新？

#### 常见的方案：

1. 切换根控制器方案: 切换语言直接重新创建根控制器
    - 优点:
      - 逻辑简单，代码0浸入
    - 缺点:
      - 必须退回根控制器重新加载，不能停留在当前页面实时刷新

2. 通知方案: 每个页面监听语言改变来刷新需要刷新的控件和逻辑
   - 优点:
     - 已经创建的页面能实时刷新
   - 缺点:
     - 每个页面都需要监听通知
     - 语言改变时所有创建的页面控件和逻辑都同时刷新，会影响一定性能
     - 写业务代码需要关心哪些控件需要刷新，剥离出来刷新，不太友好

3. 触发生命周期函数: 语言改变时将当前栈里的控制器销毁并替换新的,让控制器重新走生命周期函数
     - 优点:
       - 已经创建的页面能实时刷新
       - 逻辑简单，代码0浸入
     - 缺点:
       - 需要明确当前栈结构，遍历移除旧的，创建新的替换，需要明确创建新控制器依赖的参数，绝对不能更改栈层级结构和控制器类型，
       - 如果每个控制器的子控制器太多，怎么处理？如果子控制器也重新创建，那么子控制器布局呢？
       - 没有好的思路明确上述依赖
 #### 鉴于以上方案的各个缺点，实现一套自定义页面及时刷新的方案:
 - i18n自定义方案: 向每个控件注入一段block,语言改变时调用，也可以在改变时做标记，在页面将要出现的时刷新
   - 优点:
     - 已经创建的页面能实时刷新
     - 写业务代码不需要关心哪些控件需要刷新
     - 静态控件统一规范，统一写法，业务逻辑刷新单独控制
   - 缺点:
     - 代码中设置text，title，attributedText等文本的地方都需要加前缀.i18n.text来设置，浸入性较大
     
#### 用法：
    -
                       DESC

  s.homepage         = 'https://github.com/galenu/I18n_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'galenu' => '250167616@qq.com' }
  s.source           = { :git => 'https://github.com/galenu/I18n_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.swift_versions = ['5.0']

  s.source_files = 'I18n_iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'I18n_iOS' => ['I18n_iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
