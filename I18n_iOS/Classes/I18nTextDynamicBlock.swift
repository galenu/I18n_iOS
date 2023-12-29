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
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    public convenience init(_ key: String?,
                            tableName: String? = nil,
                            bundleId: String? = nil,
                            comment: String = "",
                            args: [CVarArg]? = nil) {
        self.init {
            guard let key = key else { return ""}
            return I18n.localized(key, tableName: tableName, bundleId: bundleId, comment: comment, args: args)
        }
    }
}
