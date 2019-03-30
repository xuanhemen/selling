//
//  QFMoveProjectVC.swift
//  SLAPP
//
//  Created by qwp on 2018/6/13.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class QFMoveProjectVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userArray:Array = Array<Dictionary<String,Any>>()
    var chooseArray:Array = Array<Dictionary<String,Any>>()
    var dataArray:Array = Array<Dictionary<String,Any>>()
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
        tb.backgroundColor = UIColor.groupTableViewBackground
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "移交项目"
        
        for baseDic in self.userArray {
            var isHave = false
            for dict in self.chooseArray{
                if JSON(baseDic["phone"] as Any).stringValue == JSON(dict["phone"] as Any).stringValue {
                    isHave = true
                }
            }
            if isHave == false {
                DLog(baseDic)
                self.dataArray.append(baseDic)
            }
        }
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(table)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIde = "cell"
        var cell:DepartmentCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? DepartmentCell
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("DepartmentCell", owner: nil, options: nil)?.last as! DepartmentCell)
        }
        
        let dic = dataArray[indexPath.row]
        cell?.top.text = (dic["realname"] as! String)
        cell?.bottom.text = (dic["position_name"] as! String ) + "   " + (dic["phone"] as! String)
        cell?.headImage.sd_setImage(with: URL.init(string: dic["head"] as! String + imageSuffix), placeholderImage: UIImage.init(named: "mine_avatar"))
        cell?.deleteBtn.isHidden = true
        cell?.reSendBtn.isHidden = true
        let str = "\(dic["userid"]!)"
        if str == UserModel.getUserModel().id {
            cell?.deleteBtn.isHidden = true
        }else{
            cell?.deleteBtn.isHidden = false
        }
        let status:String = dic["status"] as! String
        
        //新邀请的  1系统中没有
        if String.noNilStr(str: dic["not_come"])  == "1" {
            //cell.reSendBtn.isHidden = false
            cell?.grayType(isGray: true)
        }
        else{
            //没有登录   1是没有登录过
            if String.noNilStr(str: dic["is_login"])  == "1" {
                //cell.reSendBtn.isHidden = false
                cell?.grayType(isGray: true)
            }
            else{
               // cell.reSendBtn.isHidden = true
                //登录过才有必要判断  是否离职
                if status == "jobon" {
                   // cell.deleteBtn.setImage(UIImage.init(named: "ch_contact_dimission"), for: .normal)
                    cell?.grayType(isGray: false)
                }else{
                    //cell.deleteBtn.setImage(UIImage.init(named: "ch_contact_return"), for: .normal)
                    cell?.grayType(isGray: true)
                }
            }
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = self.dataArray[indexPath.row]
        let alertStrign = String.init(format: "确定把项目已交给 %@ 吗?", JSON(dict["realname"] as Any).stringValue)
        let alert = UIAlertController.init(title: "提醒", message: alertStrign, preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                let qfChooseVC = QFChooseDepartmentVC()
                qfChooseVC.isHaveProject = false
                qfChooseVC.userArray = (self?.chooseArray)!
                qfChooseVC.otherUserId = JSON(dict["userid"] as Any).stringValue
                self?.navigationController?.pushViewController(qfChooseVC, animated: true)
            }
        })
        self.present(alert, animated: true, completion: nil)
        
    }
}
