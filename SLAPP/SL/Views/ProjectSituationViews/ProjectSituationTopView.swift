//
//  ProjectSituationTopView.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectSituationTopView: UIView {

    var topViewArray = Array<ProjectSituationTopSubView>()
    var otherViewArray = Array<ProjectSituationTopSubView>()
    var isAuth:Bool?
    var editBtn:UIButton?
    lazy var statusImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    var  editClick:()->() = {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        for i in 0...6 {
            let view = ProjectSituationTopSubView.init(frame: CGRect(x: 0.0, y: 0+CGFloat(i)*44, width: frame.size.width, height: 44.0))
            view.headImage.image = UIImage.init(named: "pst".appending("\(i)"))
            self.addSubview(view)
            
            if i == 0 {
                
                let btn = UIButton.init(frame: CGRect(x: frame.size.width-50, y: 7, width: 30, height: 30))
                btn.setImage(UIImage.init(named: "projectS-Nomal0"), for: .normal)
                view.addSubview(btn)
                btn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
                editBtn = btn
            }
//            if i == 2{
//                let subView = ProjectSituationTopSubView.init(frame: CGRect(x: MAIN_SCREEN_WIDTH/2-30, y: 0, width: frame.size.width/2, height: 44.0))
//                subView.headImage.image = UIImage.init(named: "pstPhone")
//                view.addSubview(subView)
//
//            view.nameLable.snp.updateConstraints({ (make) in
//                make.right.equalToSuperview().offset(MAIN_SCREEN_WIDTH/2+20)
//                })
//                subView.nameLable.snp.updateConstraints({ (make) in
//                make.right.equalToSuperview().offset(10)
//                })
//                otherViewArray.append(subView)
//            }
            
            if i == 5{
                let subView = ProjectSituationTopSubView.init(frame: CGRect(x: MAIN_SCREEN_WIDTH/2, y: 0, width: frame.size.width/2-30, height: 44.0))
                subView.headImage.image = UIImage.init(named: "pstY")
                view.addSubview(subView)
                view.nameLable.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(MAIN_SCREEN_WIDTH/2+20)
                })
                subView.nameLable.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(10)
                })
                otherViewArray.append(subView)
            }
            
            if i == 6{
                let subView = ProjectSituationTopSubView.init(frame: CGRect(x: MAIN_SCREEN_WIDTH/2, y: 0, width: frame.size.width/2-30, height: 44.0))
                subView.headImage.image = UIImage.init(named: "creater")
                view.addSubview(subView)
                view.nameLable.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(MAIN_SCREEN_WIDTH/2+20)
                })
                subView.nameLable.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(10)
                })
                otherViewArray.append(subView)
            }
             topViewArray.append(view)
        }
        
        self.addSubview(statusImage)
        statusImage.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-50)
            make.height.equalTo(45)
            make.width.equalTo(45)
        }
        statusImage.image = UIImage.init(named: "ch_project_detail_base_state_lose")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editBtnClick(){
        editClick()
    }
    
    func configWithModel(model:ProjectSituationModel){
        
//        close_status
//        状态：0开启（默认），1赢单，2丢单，3延缓，4暂停，5其他
       
        if model.close_status == "0" {
            statusImage.isHidden = true
        }else{
            statusImage.image = UIImage.init(named: "ch_project_detail_base_state_".appending(String.noNilStr(str: model.close_status)))
            statusImage.isHidden = false
        }
        
        
        
        for (index,view) in topViewArray.enumerated() {
            
            switch index {
            case 0:
                view.nameLable.text = model.name ?? ""
                
            case 1:
                view.nameLable.text = model.client_name ?? ""
//            case 2:
//                view.nameLable.text = model.chief_contact ?? ""
            case 2:
                let string = String.init(format: "%@/%@",model.trade_parent_name!,model.trade_name!)
                view.nameLable.text = string
            case 3:
                let string = String.init(format: "%@",model.deps_name)
                view.nameLable.text = string
            case 4:
                
               
                let strArray = model.project_product.compactMap({ (model) -> String? in
                    return model.product_name+String.init(format: "（%.2f）", model.amount)
                })
                
                view.nameLable.text = strArray.joined(separator: " ")
               
            case 5:
                view.nameLable.text = String.init(format: "%.2f（万）", model.amount)
            case 6:
                view.nameLable.text = model.dealtime_str ?? ""
            
            default: break
                
            }
            
            
        }
        
        if isAuth != true {
            //做权限判断
            self.editBtn?.isHidden = true
        }else{
            if model.close_status != "0" {
                //关单状态无编辑
                self.editBtn?.isHidden = true
            }else{
                self.editBtn?.isHidden = false
            }
        }
        
        
        for (index,view) in otherViewArray.enumerated() {
            switch index {
//            case 0:
//                view.nameLable.text = model.chief_contact_phone ?? ""
            case 0:
                view.nameLable.text = String.init(format: "%.2f（万）", model.down_payment)
            case 1:
                view.nameLable.text = String.init(format: "%@", model.realname ?? "")
            default: break
                
            }
        }
        
        
    }
    
    
}
