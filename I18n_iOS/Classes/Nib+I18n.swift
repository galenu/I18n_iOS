//
//  Nib+I18n.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 根据选中语言适配nib文件
extension UILabel {
    
    private static var i18nBundleIdKey: Void?
    /// xib国际化查找bundle的id，与updateLanguage方法设置的i18nBundleId一致
    @IBInspectable public var i18nBundleId: String {
        get {
            return objc_getAssociatedObject(self, &UILabel.i18nBundleIdKey) as? String ?? I18n.defaultI18nBundleId
        }
        set {
            objc_setAssociatedObject(self, &UILabel.i18nBundleIdKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nText: String? {
        get {
            return self.text
        }
        set {
            self.i18n.text = .init(newValue, i18nBundleId: i18nBundleId)
        }
    }
}

extension UIButton {
    
    private static var i18nBundleIdKey: Void?
    /// 模块化资源bundle的唯一标识符
    @IBInspectable public var i18nBundleId: String {
        get {
            return objc_getAssociatedObject(self, &UIButton.i18nBundleIdKey) as? String ?? I18n.defaultI18nBundleId
        }
        set {
            objc_setAssociatedObject(self, &UIButton.i18nBundleIdKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nTitleNormal: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            self.i18n.setTitle(.init(newValue, i18nBundleId: i18nBundleId), forState: .normal)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nTitleHighlighted: String? {
        get {
            return self.title(for: .highlighted)
        }
        set {
            self.i18n.setTitle(.init(newValue, i18nBundleId: i18nBundleId), forState: .highlighted)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nTitleSelected: String? {
        get {
            return self.title(for: .selected)
        }
        set {
            self.i18n.setTitle(.init(newValue, i18nBundleId: i18nBundleId), forState: .selected)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nTitleDisabled: String? {
        get {
            return self.title(for: .disabled)
        }
        set {
            self.i18n.setTitle(.init(newValue, i18nBundleId: i18nBundleId), forState: .disabled)
        }
    }
}

extension UITextField {
    
    private static var i18nBundleIdentifierKey: Void?
    /// 模块化资源bundle的唯一标识符
    @IBInspectable public var i18nBundleId: String {
        get {
            return objc_getAssociatedObject(self, &UITextField.i18nBundleIdentifierKey) as? String ?? I18n.defaultI18nBundleId
        }
        set {
            objc_setAssociatedObject(self, &UITextField.i18nBundleIdentifierKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nText: String? {
        get {
            return self.text
        }
        set {
            self.i18n.text = .init(newValue, i18nBundleId: i18nBundleId)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nPlaceholder: String? {
        get {
            return self.placeholder
        }
        set {
            self.i18n.placeholder = .init(newValue, i18nBundleId: i18nBundleId)
        }
    }
}

extension UITextView {
    
    private static var i18nBundleIdentifierKey: Void?
    /// 模块化资源bundle的唯一标识符
    @IBInspectable public var i18nBundleId: String {
        get {
            return objc_getAssociatedObject(self, &UITextView.i18nBundleIdentifierKey) as? String ?? I18n.defaultI18nBundleId
        }
        set {
            objc_setAssociatedObject(self, &UITextView.i18nBundleIdentifierKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nText: String? {
        get {
            return self.text
        }
        set {
            self.i18n.text = .init(newValue, i18nBundleId: i18nBundleId)
        }
    }
}

extension UIBarItem {
    
    private static var i18nBundleIdentifierKey: Void?
    /// 模块化资源bundle的唯一标识符
    @IBInspectable public var i18nBundleId: String {
        get {
            return objc_getAssociatedObject(self, &UIBarItem.i18nBundleIdentifierKey) as? String ?? I18n.defaultI18nBundleId
        }
        set {
            objc_setAssociatedObject(self, &UIBarItem.i18nBundleIdentifierKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 国际化，值为国际化Key,  语言改变时立即调用Key关联的block
    @IBInspectable public var i18nTitle: String? {
        get {
            return self.title
        }
        set {
            self.i18n.title = .init(newValue, i18nBundleId: i18nBundleId)
        }
    }
}
