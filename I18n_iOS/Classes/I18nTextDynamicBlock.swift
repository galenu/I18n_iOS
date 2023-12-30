//
//  I18nTextDynamicBlock.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 设置text类型的国际化动态回调
public class I18nTextDynamicBlock: I18nDynamicBlock {
    
    /// 以国际化key初始化
    /// - Parameter
    ///   - key: 国际化key
    ///   - tableName: 国际化文件名，默认Localizable.strings
    ///   - bundle: .lproj资源的Bundle
    ///   - comment: comment
    ///   - args: 参数
    convenience init(_ key: String?,
                     tableName: String? = nil,
                     bundle: @escaping () -> Bundle,
                     comment: String = "",
                     args: [CVarArg]? = nil) {
        self.init {
            guard let key = key else { return ""}
            let bundle = bundle()
            return I18n.localized(key, tableName: tableName, bundle: bundle, comment: comment, args: args)
        }
    }
    
    convenience init(_ key: String?,
                     tableName: String? = nil,
                     i18nBundleId: String? = nil,
                     comment: String = "",
                     args: [CVarArg]? = nil) {
        self.init {
            guard let key = key else { return ""}
            let bundle = I18n.bundleFor(i18nBundleId: i18nBundleId)
            return I18n.localized(key, tableName: tableName, bundle: bundle, comment: comment, args: args)
        }
    }
}
