//
//  UIView+Extension.swift
//  SLAPP
//
//  Created by fank on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

public extension UIView {
    
    public var viewController: UIViewController? {
        var responder: UIResponder? = self
        var viewController: UIViewController? = nil
        while responder != nil {
            responder = responder?.next
            if let responder = responder as? UIViewController {
                viewController = responder
                break
            }
        }
        return viewController
    }
}
