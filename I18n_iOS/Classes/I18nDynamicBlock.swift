//
//  I18nDynamicBlock.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

fileprivate typealias setValueForStateIMP = @convention(c) (NSObject, Selector, Any, UIControl.State) -> Void

/// 设置国际化动态回调block
public class I18nDynamicBlock {
    
    /// 语言改变时的回调，返回值为nil只用调用block, 不会设置值，返回值不为nil还会调用key对应的方法
    var callback: () -> Any?
    
    /// 以语言切换后的回调block初始化, callback返回nil表示只调用callback，不为nil还会调用key对应的方法
    /// - Parameter callback: 语言切换后的回调
    required public init(_ callback: @escaping () -> Any?) {
        self.callback = callback
    }
}

extension I18nDynamicBlock {
    
    class func getI18nDynamicBlock(_ object : NSObject, _ selector : String) -> I18nDynamicBlock? {
        return object.i18nBlocks[selector]
    }

    /// object 执行 selector，设置的值为I18nDynamicBlock
    class func setI18nDynamicBlock(_ object : NSObject, _ selector : String, _ block : I18nDynamicBlock?) {
        object.i18nBlocks[selector] = block
        self.performDynamicBlock(object, selector, block)
    }

    /// object 执行 setState(object, sel, value, UIControl.State(rawValue: $0))，设置的值为I18nDynamicBlock
    class func getStateDynamicBlock(_ object : NSObject, _ selector : String, _ block : I18nDynamicBlock?, _ state : UIControl.State) -> I18nDynamicBlock? {
        var dynamicBlock = block
        if let stateControl = object.i18nBlocks[selector] as? I18nStateDynamicBlock {
            dynamicBlock = stateControl.setDynamicBlock(block, forState: state)
        } else {
            dynamicBlock = I18nStateDynamicBlock(block, withState: state)
        }
        return dynamicBlock
    }
    
    /// object 执行 selector，设置的值为I18nDynamicBlock
    class func performDynamicBlock(_ object : NSObject, _ selector: String, _ dynamicBlock: I18nDynamicBlock?) {
        guard let dynamicBlock = dynamicBlock else { return }
        
        if let stateBlock = dynamicBlock as? I18nStateDynamicBlock {
            let sel = Selector(selector)
            let setState = unsafeBitCast(object.method(for: sel), to: setValueForStateIMP.self)
            
            stateBlock.callbackArray.forEach {
                let eachStateBlock = $1
                // 调用block, 返回值不为nil还会调用key对应的方法
                guard let value = eachStateBlock.callback() else { return }
                
                guard object.responds(to: sel) else { return }
                setState(object, sel, value, UIControl.State(rawValue: $0))
            }
        } else {
            // 调用block, 返回值不为nil还会调用key对应的方法
            guard let value = dynamicBlock.callback() else { return }
            
            let sel = Selector(selector)
            guard object.responds(to: sel) else { return }
            object.perform(sel, with: value)
        }
    }
}
