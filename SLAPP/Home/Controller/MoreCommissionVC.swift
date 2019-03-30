//
//  MoreCommissionVC.swift
//  SLAPP
//
//  Created by rms on 2018/2/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MoreCommissionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    var modelArr : Array<Dictionary<String,Any>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "待办事项"
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT - NAV_HEIGHT))
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 0.1))
        self.view.addSubview(tableView)
        
        tableView.register(CommissionTableViewCell.self, forCellReuseIdentifier: "CommissionTableViewCell")
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.modelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.fd_heightForCell(withIdentifier: "CommissionTableViewCell", configuration: { [weak self](cell) in
            let tempCell:CommissionTableViewCell = cell as! CommissionTableViewCell
            tempCell.model = self?.modelArr[indexPath.row]
        })
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommissionTableViewCell.init(style: .default, reuseIdentifier: "CommissionTableViewCell")
        cell.model = self.modelArr[indexPath.row]
        cell.dotLb.backgroundColor = kGreenColor
        cell.topLineV.isHidden = true
        cell.bottomLineV.isHidden = true

        return cell
    }

}
