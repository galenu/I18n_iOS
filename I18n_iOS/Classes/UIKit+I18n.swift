//
//  UIKit+I18n.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

extension I18nWrapper where Base: UIView {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var languageDidChanged: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "languageDidChanged:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "languageDidChanged:", newValue) }
    }
}

extension I18nWrapper where Base: UIViewController {
    
    /// 语言改变的block, , 赋值时会立即调用一次 ，语言改变时标记为dirty，viewWillAppear时再调用
    public var languageDidChanged: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "languageDidChanged:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "languageDidChanged:", newValue) }
    }
}

extension I18nWrapper where Base: UILabel {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var text: I18nTextDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setText:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setText:", newValue) }
    }
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var attributedText: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setAttributedText:") }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setAttributedText:", newValue) }
    }
}

extension I18nWrapper where Base: UIButton {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public func setTitle(_ block: I18nTextDynamicBlock?, forState state: UIControl.State) {
        let stateBlock = I18nDynamicBlock.getStateDynamicBlock(base, "setTitle:forState:", block, state)
        I18nDynamicBlock.setI18nDynamicBlock(base, "setTitle:forState:", stateBlock)
    }
}

extension I18nWrapper where Base: UITextField {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var text: I18nTextDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setText:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setText:", newValue) }
    }
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var attributedText: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setAttributedText:") }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setAttributedText:", newValue) }
    }
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var placeholder: I18nTextDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setPlaceholder") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setPlaceholder:", newValue) }
    }
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var attributedPlaceholder: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setAttributedPlaceholder:") }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setAttributedPlaceholder:", newValue) }
    }
}

extension I18nWrapper where Base: UITextView {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var text: I18nTextDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setText:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setText:", newValue) }
    }
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var attributedText: I18nDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setAttributedText:") }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setAttributedText:", newValue) }
    }
}

extension I18nWrapper where Base: UIBarItem {
    
    /// 语言改变的block, 赋值时会立即调用一次  语言改变时再次调用
    public var title: I18nTextDynamicBlock? {
        get { return I18nDynamicBlock.getI18nDynamicBlock(base, "setTitle:") as? I18nTextDynamicBlock }
        set { I18nDynamicBlock.setI18nDynamicBlock(base, "setTitle:", newValue) }
    }
}
