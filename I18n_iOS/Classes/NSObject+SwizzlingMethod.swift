//
//  NSObject+SwizzlingMethod.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

extension NSObject {
    
    /// 替换某个类的方法实现
    /// - Parameters:
    ///   - cls: 交换方法的类
    ///   - originalSelector: 原方法
    ///   - swizzledSelector: 替换的方法
    static func swizzlingMethod(_ cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else { return }
        
        // 在进行Swizzling的时候,需要用class_addMethod先进行判断一下原有类中是否有要替换方法的实现
        let swizzledImp = method_getImplementation(swizzledMethod)
        let swizzledEncoding = method_getTypeEncoding(swizzledMethod)
        
        let didAddMethod = class_addMethod(cls, originalSelector, swizzledImp, swizzledEncoding)
        
        // 如果didAddMethod返回true,说明当前类中没有要替换方法的实现,需要在父类中查找,用method_getImplemetation去获取class_getInstanceMethod的方法实现,再进行class_replaceMethod来实现 Swizzing
        if didAddMethod {
            let originalImp = method_getImplementation(originalMethod)
            let originalEncoding = method_getTypeEncoding(originalMethod)
            
            class_replaceMethod(cls, swizzledSelector, originalImp, originalEncoding)
        } else { // 当前类中有要替换方法的实现, 直接替换
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
