//
//  NSObject+I18n.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

fileprivate var i18nDynamicBlocksKey: Void?
fileprivate var i18nHasAddDynamicBlocksNotificationKey: Void?
fileprivate var i18nHasLanguageChangedKey: Void?
/// 保证UIViewController.viewWillAppear的方法只被交换一次
fileprivate var hasSwizzledUIViewControllerViewWillAppearMethod = false


/// 语言改变的通知
extension Notification.Name {
    
    /// 语言改变的通知
    struct i18n {
        /// 语言改变的通知
        static let languageDidChanged =  Notification.Name("I18n.languageDidChanged")
    }
}

extension NSObject {
    
    typealias I18nDynamicBlocks = [String: I18nDynamicBlock]
    
    ///  保存语言改变时需要刷新的内容 如[setTitle: value], value为一段block，返回的值为国际化后的内容
    var i18nBlocks: I18nDynamicBlocks {
        get {
            if let blocks = objc_getAssociatedObject(self, &i18nDynamicBlocksKey) as? I18nDynamicBlocks {
                return blocks
            } else {
                let blocks = I18nDynamicBlocks()
                objc_setAssociatedObject(self, &i18nDynamicBlocksKey, blocks, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return blocks
            }
        }
        set {
            objc_setAssociatedObject(self, &i18nDynamicBlocksKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if !newValue.isEmpty {
                addLanguageNotification()
            }
            self.swizzlingViewWillAppearMethod()
        }
    }
    
    /// 是否添加过通知
    private var i18nHasAddDynamicBlocksNotification: Bool {
        get {
            return objc_getAssociatedObject(self, &i18nHasAddDynamicBlocksNotificationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &i18nHasAddDynamicBlocksNotificationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 语言是否改变过
    var i18nHasLanguageChanged: Bool {
        get {
            return objc_getAssociatedObject(self, &i18nHasLanguageChangedKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &i18nHasLanguageChangedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private func addLanguageNotification() {
        if !i18nHasAddDynamicBlocksNotification {
            i18nHasAddDynamicBlocksNotification = true
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(languageDidChanged),
                                                   name: .i18n.languageDidChanged,
                                                   object: nil)
        }
    }
    
    private func swizzlingViewWillAppearMethod() {
        if let _ = self as? UIViewController, !hasSwizzledUIViewControllerViewWillAppearMethod {
            hasSwizzledUIViewControllerViewWillAppearMethod = true
            // 替换UIViewController.viewWillAppear方法 用于语言改变时，在界面将要出现时进行刷新, 确保方法只被交换一次
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.i18n_viewWillAppear(_:))
            NSObject.swizzlingMethod(UIViewController.self,
                                     originalSelector: originalSelector,
                                     swizzledSelector: swizzledSelector)
        }
    }
    
    @objc private func languageDidChanged() {
        
        i18nHasLanguageChanged = true
        
        // 判断刷新时机，ViewController在页面viewWillAppear时再刷新，主要负责刷新业务逻辑, 其他静态界面语言改变就刷新 通过运行时将UIViewController的viewWillAppear替换成i18n_viewWillAppear，再i18n_viewWillAppear方法里做刷新
        if !(self is UIViewController) {
            self.updateWhenLanguageDidChanged()
        }
    }
    
    @objc func updateWhenLanguageDidChanged() {
        if i18nHasLanguageChanged {
            i18nHasLanguageChanged = false
            i18nBlocks.forEach { selector, block in
                I18nDynamicBlock.performDynamicBlock(self, selector, block)
            }
        }
    }
}

extension UIViewController {
    
    /// 替换UIViewController的viewWillAppear方法，若语言改变时过，标记为i18nHasLanguageChanged == true的vc在viewWillAppear时刷新,而不是语言改变立即刷新
    /// - Parameter animated: animated
    @objc fileprivate func i18n_viewWillAppear(_ animated: Bool) {
        if self.i18nHasLanguageChanged {
            self.updateWhenLanguageDidChanged()
        }
        
        self.i18n_viewWillAppear(animated)
   }
}
