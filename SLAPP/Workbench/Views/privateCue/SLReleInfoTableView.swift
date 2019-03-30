//
//  SLReleInfoTableView.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/2.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLReleInfoTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    
    /**数据源*/
    var dataArr = [SLReleInfoModel]()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.dataSource = self
        self.tableFooterView = UIView()
        self.rowHeight = 80
        self.register(SLReleInfoCell.self, forCellReuseIdentifier: "info")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "info") as! SLReleInfoCell
        cell.title.text = model.create_time_str
        cell.content.text = model.desc
        return cell
       
        
    }

}
