//
//  NearlySearch.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class NearlySearch: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    
    var isScroll:()->() = {
        
    }
    
    var type = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch type {
        case 3:
            return 70.0
        case 2,0:
            return 60.0
        default:
            return 44
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch type {
        case 0:
            return "最近查看的项目"
        case 1:
            return "最近查看的辅导"
        case 2:
            return "最近查看的客户"
        case 3:
            return "最近查看的联系人"
        default:
            return "最近搜索"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch type {
        case 0:do {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HYSearchProjectCell")
            if cell == nil {
                cell = Bundle.main.loadNibNamed("HYSearchProjectCell", owner: self, options: [:])?.last as! HYSearchProjectCell
            }
            (cell as! HYSearchProjectCell).setViewModelWithDictWithDict(model[indexPath.row])
            return cell!
            }
        case 2:do {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HYSearchClientCell")
            if cell == nil {
                cell = Bundle.main.loadNibNamed("HYSearchClientCell", owner: self, options: [:])?.last as! HYSearchClientCell
            }
            (cell as! HYSearchClientCell).cellNameLabel.text = String.noNilStr(str: model[indexPath.row]["name"])
            var place = String.noNilStr(str: model[indexPath.row]["place"])
            if place == "" {
                place = "暂无地址信息"
            }
            (cell as! HYSearchClientCell).cellAdressLabel.text = place
            return cell!
        }
        case 3:
            var cell = tableView.dequeueReusableCell(withIdentifier: "HYContactNewCell")
            if cell == nil {
                cell = Bundle.main.loadNibNamed("HYContactNewCell", owner: self, options: [:])?.last as! HYContactNewCell
            }
            (cell as! HYContactNewCell).cellNameLabel.text = String.noNilStr(str: model[indexPath.row]["name"])
            (cell as! HYContactNewCell).cellPositionLabel.text = String.noNilStr(str: model[indexPath.row]["position_name"])
            (cell as! HYContactNewCell).cellCompanylabel.text = String.noNilStr(str: model[indexPath.row]["client_name"])
            
            (cell as! HYContactNewCell).dict = model[indexPath.row]
            return cell!
        default:do {
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "nearlySearch")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "nearlySearch")
        }
        cell?.textLabel?.text = String.noNilStr(str: model[indexPath.row]["name"])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectNearly(String.noNilStr(str: model[indexPath.row]["type_id"]!))
    }
    
    var model = Array<Dictionary<String,Any>>()
    var selectNearly:(String)->() = {_ in
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScroll()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "nearlySearch")
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getData(searchType:Int) {
//        PublicMethod.showProgressWithStr(statusStr: "获取历史信息")
        self.type = searchType
        LoginRequest.getPost(methodName: LAST_VIEWED, params: ["type":searchType,kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            
        }) { (dic) in
            DLog(dic)
            self.model = dic["data"] as! [Dictionary<String, Any>]
            self.reloadData()
        }
    }
    
}
