//
//  QFChooseTypeView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
@objc protocol QFChooseTypeDelegate :NSObjectProtocol{
  @objc  func chooseModel(model:ProjectPlanStarModel)
}

class QFChooseTypeView: UIView {

   @objc var projectId = "";
    var tableView:UITableView?
   @objc var delegate:QFChooseTypeDelegate?
//    let dataArray = [
//        ["name":"常规交流","imageName":"project_message.png","star":5],
//        ["name":"方案呈现","imageName":"project_fangan.png","star":3],
//        ["name":"产品演示","imageName":"project_chanping.png","star":3],
//        ["name":"商务活动","imageName":"project_huodong.png","star":2],
//        ["name":"需求调研","imageName":"project_diaoyan.png","star":4],
//        ["name":"样板参观","imageName":"project_yangban.png","star":1],
//        ["name":"技术交流","imageName":"project_jishujiaoliu.png","star":3]]
    var dataArray:Array<ProjectPlanStarModel>?{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
   @objc func getStar(){
        
        
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        params["project_id"] = projectId
//        params["peoples_id"] = self.userView.resultIdStr()
        LoginRequest.getPost(methodName: ACTION_PLAN_STAR, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            
            let array =  JSON(dic["data"] as Any).arrayObject
            var dataArray  = Array<ProjectPlanStarModel>()
            for dic in array! {
                if let model:ProjectPlanStarModel = ProjectPlanStarModel.deserialize(from:(dic as! Dictionary<String,Any>)){
                    dataArray.append(model)
                }
            }
            self?.dataArray = dataArray
            self?.tableView?.reloadData()
        }
        
    }
    
    
    
    
    
   @objc func uiConfig()  {
        
        
        
        self.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        
        self.tableViewConfig(frame: CGRect(x: 0, y:0, width:UIScreen.main.bounds.size.width, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT))
    
    
    }
    func tableViewConfig(frame:CGRect)  {
        
       // self.labelConfig(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 30), fatherView: self)
        
        self.tableView = UITableView.init(frame: frame, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = self.backgroundColor
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.addSubview(self.tableView!)
        
        self.tableView?.addEmptyViewAndClickRefresh({ [weak self] in
            self?.getStar()
        })
        
        
    }
    func labelConfig(frame:CGRect,fatherView:UIView){
        let titleLabel = UILabel.init(frame: frame)
        titleLabel.text = "选择行动类型"
        titleLabel.backgroundColor = .black
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        fatherView.addSubview(titleLabel)
    }
}
extension QFChooseTypeView:UITableViewDelegate,UITableViewDataSource  {
    //MARK: - tableview代理
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray == nil {
            return 0
        }
        return dataArray!.count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "QFChooseCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = QFChooseCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        let model = self.dataArray![indexPath.row]
//        let model = QFActionTypeModel()
//        model.imageName = dict["imageName"] as! String
//        model.title = dict["name"] as! String
//        model.star = dict["star"] as! Int
        (cell as! QFChooseCell).setData(model:model)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
        }
        let model = self.dataArray![indexPath.row]
//        let model = QFActionTypeModel()
//        model.imageName = dict["imageName"] as! String
//        model.title = dict["name"] as! String
//        model.star = dict["star"] as! Int
        self.delegate?.chooseModel(model: model)
    }
    
}
