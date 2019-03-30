//
//  ReminderView.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
class ReminderView: UIView,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    var modelArr : Array<(String,Array<(String,String)>,String,String)>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.modelArr = Array()
        let barView = UIView.init(frame: CGRect.init(x: barView_LeftMargin, y: (CommissionView_HeaderHeight - 20) * 0.5, width: 3, height: 20))
        barView.backgroundColor = kGreenColor
        self.addSubview(barView)
        let titleLb = UILabel.init(frame: CGRect.init(x: barView_LeftMargin + 20, y: 10, width: 100, height: 30))
        titleLb.textColor = UIColor.black
        titleLb.font = kFont_Big
        titleLb.text = "智能提示"
        self.addSubview(titleLb)
        
        let seperateLine = UIView.init(frame: CGRect.init(x: LEFT_PADDING, y: CommissionView_HeaderHeight - 0.5, width: frame.size.width - 2 * LEFT_PADDING, height: 0.5))
        seperateLine.backgroundColor = UIColor.lightGray
        self.addSubview(seperateLine)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: CommissionView_HeaderHeight, width: frame.size.width, height: frame.size.height - CommissionView_HeaderHeight))
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0.1))
        self.addSubview(tableView)
        
        tableView.register(RemindTableViewCell.self, forCellReuseIdentifier: "RemindTableViewCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.modelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return tableView.fd_heightForCell(withIdentifier: "RemindTableViewCell", configuration: { [weak self](cell) in
            let tempCell:RemindTableViewCell = cell as! RemindTableViewCell
           tempCell.model = self?.modelArr[indexPath.row]
            
        })
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RemindTableViewCell.init(style: .default, reuseIdentifier: "RemindTableViewCell")
        cell.model = self.modelArr[indexPath.row]
        if indexPath.row == 0 {
            cell.dotLb.layer.borderColor = kGreenColor.cgColor
        }else{
            cell.dotLb.layer.borderColor = UIColor.gray.cgColor
        }
        cell.detailLb.click = { [weak self] in
            self?.toPush(indexPath: indexPath)
        }
        
        return cell
    }
    
    
    func toPush(indexPath:IndexPath){
        let type = self.modelArr[indexPath.row].2
        //
        let vc = ProjectDetailVC()
        vc.type = type
        PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     self.toPush(indexPath: indexPath)
    }
    
}
