//
//  LanguageManager.swift
//  JCXX
//
//  Created by gavin on 2023/8/12.
//

import UIKit
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
