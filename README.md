# I18n_iOS

[![CI Status](https://img.shields.io/travis/galen/I18n_iOS.svg?style=flat)](https://travis-ci.org/galen/I18n_iOS)
[![Version](https://img.shields.io/cocoapods/v/I18n_iOS.svg?style=flat)](https://cocoapods.org/pods/I18n_iOS)
[![License](https://img.shields.io/cocoapods/l/I18n_iOS.svg?style=flat)](https://cocoapods.org/pods/I18n_iOS)
[![Platform](https://img.shields.io/cocoapods/p/I18n_iOS.svg?style=flat)](https://cocoapods.org/pods/I18n_iOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### 实现效果

https://github.com/galenu/i18n/assets/147314823/4a1db2c7-1541-4175-878d-318c68036bc8

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

#### 安装方式：
```
pod I18n_iOS
```
     
#### 用法：

1. 在语言切换处用一下代码设置选中语言
```
import I18n_iOS

/// 语言类型
public enum LanguageType: String, CaseIterable {

    /// 英语
    case en = "en"

    /// 简体中文
    case zhHans = "zh-Hans"

    /// 繁体中文
    case zhHant = "zh-Hant"
    
    case fr = "fr"
    
    case ja = "ja"
}

/// 显示语言, 根据语言读取本地化资源
public class LanguageManager {
    
    public static let shared = LanguageManager()
    
    var type: LanguageType = .en
    
    /// 模块化资源bundle的唯一标识符  不设置默认main,表示只有1个模块
    public var lprojBundle: Bundle = .main

    /// 设置选择的语言，type = nil表示跟随系统
    /// - Parameter type: LanguageType
    public static func setLanguage(type: LanguageType) {
        if let path = Bundle.main.path(forResource: type.rawValue, ofType: ".lproj"), let lprojBundle = Bundle(path: path) {
            LanguageManager.shared.type = type
            LanguageManager.shared.lprojBundle = lprojBundle
            I18n.updateLanguage(i18nBundleId: I18n.defaultI18nBundleId, bundle: lprojBundle)
        }
    }
}

```

2. 给String添加国际化扩展方法

```swift
// MARK: - 默认给String添加国际化方法
extension String {
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> String {
        return I18n.localized(self, bundle: LanguageManager.shared.lprojBundle, args: args)
    }
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18n.localized(self, bundle: { LanguageManager.shared.lprojBundle }, args: args)
    }
}

```
3. String调用方式
- UILabel: 
```swift
label.i18n.text = "test_text".localized()
```
- UIButton: 
```swift
button.i18n.setTitle("test_text".localized(), forState: .normal)
```
- UITextField: 
```swift
textField.i18n.text = "test_text".localized()
```
- UITextView: 
```swift
textView.i18n.text = "test_text".localized()
```
- UIBarItem: 
```swift
  barItem.i18n.title = "test_text".localized()
```

4. 若使用了R.swift库, 针对StringResource做协议扩展
```
// MARK: - 默认给R.swift添加国际化方法
extension StringResource {
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> String {
        return I18n.localized(self.key.description, bundle: LanguageManager.shared.lprojBundle, args: args)
    }
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18n.localized(self.key.description, bundle: { LanguageManager.shared.lprojBundle }, args: args)
    }
}
```
5. R.swift调用方式
```
let label = UILLabel()
label.i18n.text = RString.no_arguments.localized() // 或 label.text = RString.no_arguments.localized() 
label.i18n.text = RString.estimate_time.localized(args: ["5"]) // 或 label.text = RString.estimate_time.localized(args: ["5"])
```


## Requirements

## Installation

I18n_iOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

- 目标项目加入源
```
pod 'I18n_iOS', :git => "https://github.com/galenu/I18n_iOS.git"
```
- 执行 
```
pod repo update
```

## Author

galen, 250167616@qq.com

## License

I18n_iOS is available under the MIT license. See the LICENSE file for more info.
