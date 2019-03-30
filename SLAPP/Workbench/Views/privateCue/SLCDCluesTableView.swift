//
//  SLCDCluesTableView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCDCluesTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    
    typealias PassContentOfSet = (CGFloat) -> Void
    var ofSet:PassContentOfSet?
    
    var basicDic = [String:Any]()
    var sysDic = [String:Any]()
    
    /**收集传到编辑界面的参数*/
    var infoDic = [String:String]()
    
    var indentifier:String?
    
     var pool: WhichPool?
    
    var content: UILabel = {
        let content = UILabel()
        content.textColor = kTitleColor
        content.font = FONT_16
        return content
    }()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
        self.sectionFooterHeight = 0
        self.cluesArr = [infoArr,systemArr]
        
        //                let content = cellNew.content.text
        //                 print("测试\(content)")
        //                if  content != "" && content != "--" && content != nil {
        //                    infoDic[cellNew.name.text!] = cellNew.content.text
        //                }
       
    }
    func getEditPara() -> [String:String] {
        for title in infoArr {
            let key = info[title]
            let content = basicDic[key ?? ""] as! String
            if content != "" && content != "--" && content != nil {
                infoDic[title] = content
            }
        }
        return infoDic
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**基本信息*/
    let infoArr = ["姓名","公司","行业","部门","职位","手机","性别","微信","电话","QQ","邮箱","城市","地址","邮编","来源","所属","备注","状态"]
    let info = ["姓名":"name","公司":"corp_name","行业":"trade","部门":"dep","职位":"position","手机":"phone","性别":"sex","微信":"wechat","电话":"tel","QQ":"qq","邮箱":"email","城市":"pro_city_area","地址":"address","邮编":"postcode","来源":"source_name","所属":"gonghai_category","备注":"note","状态":"status"]
    /**系统信息*/
    let systemArr = ["最新跟进","锁定","时限","负责","部门","创建人","修改人","分配人","创建时间","修改时间","分配时间","转手次数","退回原因"]
    let system = ["最新跟进":"last_fo_time","锁定":"is_lock","时限":"di","负责":"realname","部门":"dep","创建人":"addname","修改人":"edit_user","分配人":"distri_user","创建时间":"addtime","修改时间":"edit_time","分配时间":"distri_time","转手次数":"return_times","退回原因":"return_reason"]
    /**线索信息数组*/
    var cluesArr = [Array<Any>]()
    
    /**section个数*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    /**section高度*/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    /**头部视图*/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView()
        headView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        let title = UILabel()
        if section == 0 {
            title.text = "基本信息"
        }else{
            title.text = "系统信息"
        }
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.black
        headView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        return headView
    }
    /**行数*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 17
        }
        if self.pool == .privatePool{
             return 12
        }
        return 13
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
   
    /**返回cell*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = "indentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: str)
        if cell == nil {
            cell = SLCluesDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: str)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        let cellNew = cell as! SLCluesDetailCell
        cellNew.name.text = self.cluesArr[indexPath.section][indexPath.row] as? String
        let name = cellNew.name.text
        if indexPath.section==0 {
            let key = info[name!]
            if key==""{
                cellNew.content.text = ""
            }else{
                cellNew.content.text = basicDic[key!] as? String
               

            }
        }else{
            let key = system[name!]
            if key==""{
                cellNew.content.text = ""
            }else{
                cellNew.content.text = sysDic[key!] as? String
            }
        }
        
        return cell!
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ofSetY = scrollView.contentOffset.y
        if ofSetY>=0 && ofSetY<=SLHeadViewHeight {
            self.ofSet!(ofSetY)
        }
    }
}
