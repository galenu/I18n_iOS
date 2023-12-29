//
//  I18nIntlable.swift
//  I18n_Example
//
//  Created by gavin on 2023/7/20.
//

import UIKit

/// 显示国际化控件需要遵循的协议，这里不继承UIView是因为部分控件不继承UIView，如UIBarItem继承自NSObject
public protocol I18nIntlable: NSObject { }

public struct I18nWrapper<Base: NSObject> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// 给Base类型添加i18n属性
extension I18nIntlable {
    public var i18n: I18nWrapper<Self> {
        get { return I18nWrapper(self) }
        set { }
    }
}

/// 默认添加i18n属性的类
extension UIBarItem: I18nIntlable { }
extension UIViewController: I18nIntlable { }
extension UIView: I18nIntlable { }
