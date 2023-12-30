//
//  I18n.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 文本国际化，语言切换时，已初始化控件及时刷新
public class I18n {
    
    public static let shared = I18n()
    
    /// 默认的BundleId, xib国际化通过设置xib的i18nBundleId和语言改变时指定的i18nBundleId来匹配.lproj文件的Bundle
    public static let defaultI18nBundleId = "main"
    
    /// 各个模块的多语言.lproj文件的bundle集合 [i18nBundleId:  Bundle]
    public private(set) var lprojBundleMap = [String: Bundle]()
    
    /// 根据当前选中语言国际化字符串, 参数格式化
    /// - Parameters:
    ///   - key: 国际化key
    ///   - tableName: 国际化文件名，默认Localizable.strings
    ///   - bundle: .lproj资源的Bundle
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    public class func localized(_ key: String,
                                tableName: String? = nil,
                                bundle: Bundle,
                                comment: String = "",
                                args: [CVarArg]? = nil) -> String {
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
    ///   - bundle: .lproj资源的Bundle
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: I18nTextDynamicBlock
    public class func localized(_ key: String?,
                                tableName: String? = nil,
                                bundle: @escaping () -> Bundle,
                                comment: String = "",
                                args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18nTextDynamicBlock(key, tableName: tableName, bundle: bundle, comment: comment, args: args)
    }
    
    /// 国际化文本实施刷新
    /// - Parameters:
    ///   - key: 国际化key
    ///   - tableName: 国际化文件名，默认Localizable.strings
    ///   - i18nBundleId: 某个模块调用updateLanguage方法设置的i18nBundleId
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: I18nTextDynamicBlock
    public class func localized(_ key: String?,
                                tableName: String? = nil,
                                i18nBundleId: String? = nil,
                                comment: String = "",
                                args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18nTextDynamicBlock(key, tableName: tableName, i18nBundleId: i18nBundleId, comment: comment, args: args)
    }
    
    /// 以语言切换后的回调block初始化, callback返回nil表示只调用callback，不为nil还会调用key对应的方法
    /// - Parameter callback: 语言切换后的回调
    /// - Returns: I18nTextDynamicBlock
    public class func dynamicBlock(_ callback: @escaping () -> Any?) -> I18nTextDynamicBlock {
        return I18nTextDynamicBlock(callback)
    }
    
    /// 语言改变调用此方法更新显示文本, xib国际化必须指定这里的i18nBundleId，xib控件中再设置相同的i18nBundleId
    /// - Parameters:
    ///   - i18nBundleId: xib国际化必须指定这里的i18nBundleId, xib控件中再设置相同的i18nBundleId
    ///   - bundle: 该i18nBundleId对应的语言.lproj文件的bundle
    public static func updateLanguage(i18nBundleId: String? = nil, bundle: Bundle) {
        let bundleId = i18nBundleId ?? I18n.defaultI18nBundleId
        if bundleId.isEmpty {
           return
        }
        I18n.shared.lprojBundleMap[bundleId] = bundle
        NotificationCenter.default.post(name: .i18n.languageDidChanged, object: nil)
    }
    
    /// 获取i18nBundleId对应的某种语言的lprojBundle
    /// - Parameter i18nBundleId: updateLanguage时设置的i18nBundleId
    /// - Returns: 某种语言的lprojBundle
    internal static func bundleFor(i18nBundleId: String? = nil) -> Bundle {
        let bundleId = i18nBundleId ?? I18n.defaultI18nBundleId
        if bundleId.isEmpty {
            return .main
        }
        guard let lprojBundle = I18n.shared.lprojBundleMap.first { $0.key == bundleId }?.value else {
            return .main
        }
        return lprojBundle
    }
}
