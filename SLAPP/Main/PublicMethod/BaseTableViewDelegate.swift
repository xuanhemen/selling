//
//  BaseTableViewDelegate.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class BaseTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tvNumberOfRowsInSection:(_ tableView: UITableView, _ section: Int) -> Int = {table, section in
        return 1
    }
    var tvCellForRowAt : (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell = {table, indexPath in
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "nor")
        return cell
    }
    
    var tvDidSelectRowAt:(_ tableView: UITableView, _ indexPath: IndexPath) -> () = {table, section in
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.tvNumberOfRowsInSection(tableView,section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tvCellForRowAt(tableView,indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tvDidSelectRowAt(tableView,indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
