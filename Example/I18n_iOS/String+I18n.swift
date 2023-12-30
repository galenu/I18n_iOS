//
//  String+I18n.swift
//  I18n_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import I18n_iOS

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
