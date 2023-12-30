//
//  String+I18n.swift
//  I18n_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import I18n_iOS

/// 国际化协议默认实现
extension I18nLocalizedable {
    
    /// 国际化文本
    /// - Parameters:
    ///   - tableName: 默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    public func localized(tableName: String? = nil,
                          bundleId: String? = I18n.shared.defaultBundleId,
                          comment: String = "",
                          args: [CVarArg]? = nil) -> String {
        return I18n.localized(localizedKey, bundleId: bundleId, comment: comment, args: args)
    }
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - tableName: 默认Localizable.strings
    ///   - bundleId: 模块化资源bundle的唯一标识符
    ///   - comment: comment
    ///   - args: 参数
    /// - Returns: 国际化后的String
    public func localized(tableName: String? = nil,
                          bundleId: String? = I18n.shared.defaultBundleId,
                          comment: String = "",
                          args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18n.localized(localizedKey, bundleId: bundleId, comment: comment, args: args)
    }
}

// MARK: - 默认给String添加国际化方法
extension String: I18nLocalizedable {
    public var localizedKey: String {
        return self
    }
}
