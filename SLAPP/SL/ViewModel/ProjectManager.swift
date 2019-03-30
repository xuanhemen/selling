//
//  ProjectManager.swift
//  SLAPP
//
//  Created by qwp on 2018/5/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectManager: NSObject {
    static let shared = ProjectManager()
    
    private override init() {
        
    }
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
    // Optional
    func reset() {
        // Reset all properties to default value
    }
}
