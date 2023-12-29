//
//  I18n.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 国际化协议
public protocol I18nLocalizedable {
    
    /// 国际化key
    var localizedKey: String { get }
    
    /// 国际化文本
    /// - Parameters:
    ///   - tableName: 默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(tableName: String?,
                   bundleId: String?,
                   comment: String,
                   args: [CVarArg]?) -> String
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - tableName: 默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(tableName: String?,
                   bundleId: String?,
                   comment: String,
                   args: [CVarArg]?) -> I18nTextDynamicBlock
}

/// 文本国际化，语言切换时，已初始化控件及时刷新
public class I18n {
    
    public static let shared = I18n()
    
    /// 默认的BundleId
    public var defaultBundleId = "main"
    
    /// 各个模块的多语言.lproj文件的bundle集合 [bundleIdentifier:  Bundle]
    private var lprojBundleMap = [String: Bundle]()
    
    /// 根据当前选中语言国际化字符串, 参数格式化
    /// - Parameters:
    ///   - key: 国际化key
    ///   - tableName: 国际化文件名，默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    public class func localized(_ key: String,
                                tableName: String? = nil,
                                bundleId: String? = nil,
                                comment: String = "",
                                args: [CVarArg]? = nil) -> String {
        guard let bundle = I18n.bundle(for: bundleId) else { return key }
        let localizedString = NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: comment)
        if let args = args, !args.isEmpty {
            return String(format: localizedString, arguments: args)
        } else {
            return localizedString
        }
    }
    
    /// 国际化文本实施刷新
    /// - Parameters:
    ///   - key: 国际化key
    ///   - tableName: 国际化文件名，默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    public class func localized(_ key: String?,
                                tableName: String? = nil,
                                bundleId: String? = nil,
                                comment: String = "",
                                args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18nTextDynamicBlock(key, tableName: tableName, bundleId: bundleId, comment: comment, args: args)
    }
    
    /// 以语言切换后的回调block初始化, callback返回nil表示只调用callback，不为nil还会调用key对应的方法
    /// - Parameter callback: 语言切换后的回调
    /// - Returns: I18nTextDynamicBlock
    public class func dynamicBlock(_ callback: @escaping () -> Any?) -> I18nTextDynamicBlock {
        return I18nTextDynamicBlock(callback)
    }
    
    /// 主工程语言改变调用此方法更新每个模块的显示文本
    /// - Parameters:
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - bundle: 该bundleIdentifier对应的语言.lproj文件的bundle
    public static func updateLanguage(bundleId: String? = nil, bundle: Bundle) {
        let bundleId = bundleId ?? I18n.shared.defaultBundleId
        if bundleId.isEmpty {
            fatalError("bundleId cant not empty!")
        }
        I18n.shared.lprojBundleMap[bundleId] = bundle
        NotificationCenter.default.post(name: .i18n.languageDidChanged, object: nil, userInfo: nil)
    }
    
    /// 获取bundleIdentifier对应的某种语言的lprojBundle
    /// - Parameter bundleId: 模块化资源bundle的唯一标识符
    /// - Returns: 某种语言的lprojBundle
    public static func bundle(for bundleId: String? = nil) -> Bundle? {
        let bundleId = bundleId ?? I18n.shared.defaultBundleId
        let lprojBundle = I18n.shared.lprojBundleMap.first { $0.key == bundleId }?.value
        return lprojBundle
    }
}
