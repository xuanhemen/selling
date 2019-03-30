
//
//  CommissionView.swift
//  SLAPP
//
//  Created by rms on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

let barView_LeftMargin : CGFloat = 20
let CommissionView_HeaderHeight : CGFloat = 50
let moreNum = 4 //最大显示条数
class CommissionView: UIView,UITableViewDelegate,UITableViewDataSource  {
    
    var tableView : UITableView!
    var dateLable = UILabel()
    var modelArr : Array<Dictionary<String,Any>>!{
        didSet{
            
//            if  modelArr.count > moreNum {
//
//                let moreBtn = UIButton.init(frame: CGRect.init(x: frame.size.width - 50 - barView_LeftMargin, y: 5, width: 50, height: 40))
//                moreBtn.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
//
//                moreBtn.setTitle("更多", for: .normal)
//                moreBtn.setImage(UIImage.init(named: "ch_div_right_new"), for: .normal)
//                moreBtn.setTitleColor(UIColor.gray, for: .normal)
//                moreBtn.titleLabel?.font = kFont_Middle
//                moreBtn.changeImageTitleRect()
//                self.addSubview(moreBtn)
//            }
        }
        
    }
    /// 更多按钮点击事件的回调
    var moreBtnClickBlock : (() -> ())?
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
        titleLb.text = "待办事项"
        
        self.addSubview(titleLb)
        
        dateLable.frame = CGRect(x: titleLb.max_X+10, y: 10, width: 100, height: 30)
        dateLable.font = kFont_Big
        dateLable.textColor = kGreenColor
        self.addSubview(dateLable)
        
        
        
        let seperateLine = UIView.init(frame: CGRect.init(x: LEFT_PADDING, y: CommissionView_HeaderHeight - 0.5, width: frame.size.width - 2 * LEFT_PADDING, height: 0.5))
        seperateLine.backgroundColor = UIColor.lightGray
        self.addSubview(seperateLine)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: CommissionView_HeaderHeight, width: frame.size.width, height: frame.size.height - CommissionView_HeaderHeight))
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0.1))
        self.addSubview(tableView)
        
        tableView.register(CommissionTableViewCell.self, forCellReuseIdentifier: "CommissionTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return self.modelArr.count > moreNum ? moreNum : self.modelArr.count
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
        if indexPath.row == 0 {
            cell.dotLb.backgroundColor = kGreenColor
            cell.topLineV.isHidden = true
            dateLable.text = String.noNilStr(str: cell.model["date"])
        }else{
            cell.dotLb.backgroundColor = kGreenColor
            cell.topLineV.isHidden = false
        }
        if indexPath.row == (self.modelArr.count > moreNum ? moreNum : self.modelArr.count) - 1 {
            cell.bottomLineV.isHidden = true
        }else{
            cell.bottomLineV.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelArr[indexPath.row]
        if String.noNilStr(str: model["type"]) == "consult" {
            let vc = TutoringDetailVC()
            
            vc.new_consult_id = String.noNilStr(str: model["type_id"])
            
            PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
            
            //状态辅导
        }else if String.noNilStr(str: model["type"]) == "source" {
            //行动计划
            let mymodel = ProjectSituationModel()
            mymodel.id = String.noNilStr(str: model["project_id"])
//            mymodel. = String
//            print("000a0a0a0",model)
            let vc = QFProjectPlanDetailVC()
            vc.isProjectIn = false
//            vc.id = String.noNilStr(str: model["type_id"])
            vc.model = mymodel
            
            vc.id = String.noNilStr(str: model["type_id"])
            PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @objc func moreBtnClick(btn: UIButton){
        
        if self.moreBtnClickBlock != nil{
            
            self.moreBtnClickBlock!()
        }
    }
}
