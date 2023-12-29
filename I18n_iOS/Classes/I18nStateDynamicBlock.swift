//
//  I18nStateDynamicBlock.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 设置UIControl.State类型的国际化动态回调
class I18nStateDynamicBlock: I18nDynamicBlock {

    typealias CallbackArray = [UInt: I18nDynamicBlock]
    
    var callbackArray = CallbackArray()
    
    /// 设置某种状态下的文本
    /// - Parameters:
    ///   - picker: I18nPicker
    ///   - state: UIControl.State
    convenience init?(_ dynamicBlock: I18nDynamicBlock?, withState state: UIControl.State) {
        guard let dynamicBlock = dynamicBlock else { return nil }
        
        self.init({ 0 })
        callbackArray[state.rawValue] = dynamicBlock
    }
    
    /// 设置某种状态下的文本
    /// - Parameters:
    ///   - picker: I18nPicker
    ///   - state: UIControl.State
    /// - Returns: I18nStatePicker
    func setDynamicBlock(_ dynamicBlock: I18nDynamicBlock?, forState state: UIControl.State) -> Self? {
        guard let dynamicBlock = dynamicBlock else { return nil }
        callbackArray[state.rawValue] = dynamicBlock
        return self
    }
}
