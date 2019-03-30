//
//  QFTeacherDetailVC.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON


class QFTeacherDetailVC: UIViewController {

    let scrolView = UIScrollView()
    let headerView = QFTeacherHeaderView.init(frame: CGRect.zero)
    let introductionView = QFTeacherProfileView.init(frame: CGRect.zero)
    let gongzuoView = QFTeacherExperienceView.init(frame: CGRect.zero)
    let tagView = QFTeacherTagView.init(frame: CGRect.zero)
    let jiaoyuView = QFTeacherExperienceView.init(frame: CGRect.zero)
    let bookView = QFTeacherTagView.init(frame: CGRect.zero)
    
    var teacherID = "0"
    var fen = "0"
    var eduArray = Array<QFExperienceModel>()
    var workArray = Array<QFExperienceModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configUI()
        self.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - ***********  QF -- mark 数据刷新     ***********
    func reloadData(){
        
        PublicMethod.showProgress()
        
        //let isNoValueShow = true
        //修改
        //这里传数据
        
        LoginRequest.getPost(methodName: QFRequest_FetchTeacherDetail, params:["teacher_id":teacherID].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            DLog("teacher_ =")
            DLog(dic)
            PublicMethod.dismiss()
            
            self.headerView.setData(name: JSON(dic["realname"] as Any).stringValue, zhicheng: JSON(dic["position"] as Any).stringValue, imageString: JSON(dic["avater"] as Any).stringValue, star: Float(self.fen)!)
         
            var introString = JSON(dic["intro"] as Any).stringValue
            if introString.count == 0 {
                introString = "该导师还没有填写简介……"
            }
            let introductionViewHeight = self.introductionView.setData(string: introString)
            
            
            let workList = JSON(dic["workList"] as Any).arrayValue
            let eduList = JSON(dic["eduList"] as Any).arrayValue
            
            for dict in workList {
                let smodel = QFExperienceModel()
                smodel.name = JSON(dict["company"]).stringValue
                smodel.detail = JSON(dict["description"]).stringValue
                smodel.date = "2012.8-至今，JAVA开发工程师"
                smodel.headerImageUrl = ""
                smodel.type = 0
                self.workArray.append(smodel)
            }
            for dict in eduList {
                let smodel = QFExperienceModel()
                smodel.name = JSON(dict["company"]).stringValue
                smodel.detail = ""
                smodel.date = JSON(dict["edu"]).stringValue
                smodel.headerImageUrl = ""
                smodel.type = 1
                self.eduArray.append(smodel)
            }
            
            
            var isHaveWork:Bool = false
            var gongzuoModel = QFExperienceModel()
            gongzuoModel.type = 0
            if self.workArray.count>0{
                isHaveWork = true
                gongzuoModel = self.workArray[0]
            }else{
                isHaveWork = false
            }
            //传工作经历的数据
            let gongzuoViewHeight = self.gongzuoView.setData(isShow: true, haveValue: isHaveWork, isShowArrow: isHaveWork, model: gongzuoModel)
            
            
            let tagList = JSON(dic["tagList"] as Any).arrayValue
            var tagArray = Array<String>()
            for subDict in tagList {
                let count = JSON(subDict["support_count"]).stringValue
                let tag = JSON(subDict["tag"]).stringValue
                let string = String.init(format: "%@(%@)", arguments: [tag,count])
                tagArray.append(string)
                
            }
            let tagViewHeight = self.tagView.setData(array: tagArray, type: 0)
            
            
            
            
            var isHaveEdu:Bool = false
            var jiaoyuModel = QFExperienceModel()
            jiaoyuModel.type = 1
            if self.eduArray.count>0{
                isHaveEdu = true
                jiaoyuModel = self.eduArray[0]
            }else{
                isHaveEdu = false
            }
        
            let jioayuViewHeight = self.jiaoyuView.setData(isShow: true, haveValue: isHaveEdu, isShowArrow: isHaveEdu, model: jiaoyuModel)
            
            
            let bookList = JSON(dic["bookList"] as Any).arrayValue
            var bookArray = Array<String>()
            for subDict in bookList {
                bookArray.append(JSON(subDict["book"]).stringValue)
            }
            let bookViewHeight = self.bookView.setData(array: bookArray, type: 1)
            
            //这里不用动
            self.reloadUI(array: [["height":SCREEN_WIDTH/2.2,"y":0],["height":introductionViewHeight,"y":0],["height":gongzuoViewHeight,"y":gongzuoViewHeight==0 ? 0 : 15],["height":tagViewHeight,"y":15],["height":jioayuViewHeight,"y":jioayuViewHeight==0 ? 0 : 15],["height":bookViewHeight,"y":15]])
        }
        
    }
    
    //MARK: - ***********  UI界面     ***********

    func reloadUI(array:Array<Dictionary<String,CGFloat>>) {
        self.scrolView.snp.remakeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    
        self.headerView.snp.remakeConstraints { (make) in
            make.top.left.equalTo(array[0]["y"]!)
            make.height.equalTo(array[0]["height"]!)
            make.width.equalTo(SCREEN_WIDTH)
        }
        self.introductionView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(array[1]["y"]!)
            make.left.equalTo(10)
            make.height.equalTo(array[1]["height"]!)
            make.width.equalTo(SCREEN_WIDTH-20)
        }
        self.gongzuoView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.introductionView.snp.bottom).offset(array[2]["y"]!)
            make.left.equalTo(10)
            make.height.equalTo(array[2]["height"]!)
            make.width.equalTo(SCREEN_WIDTH-20)
        }
        self.tagView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.gongzuoView.snp.bottom).offset(array[3]["y"]!)
            make.left.equalTo(10)
            make.height.equalTo(array[3]["height"]!)
            make.width.equalTo(SCREEN_WIDTH-20)
        }
        self.jiaoyuView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.tagView.snp.bottom).offset(array[4]["y"]!)
            make.left.equalTo(10)
            make.height.equalTo(array[4]["height"]!)
            make.width.equalTo(SCREEN_WIDTH-20)
        }
        self.bookView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.jiaoyuView.snp.bottom).offset(array[5]["y"]!)
            make.left.equalTo(10)
            make.height.equalTo(array[5]["height"]!)
            make.width.equalTo(SCREEN_WIDTH-20)
            make.bottom.equalTo(self.scrolView.snp.bottom).offset(-10)
        }
    }
    func configUI() {
        self.title = "教练档案"
        self.view.addSubview(self.scrolView)
        self.scrolView.addSubview(self.headerView)
        self.scrolView.addSubview(self.introductionView)
        self.scrolView.addSubview(self.gongzuoView)
        self.scrolView.addSubview(self.tagView)
        self.scrolView.addSubview(self.jiaoyuView)
        self.scrolView.addSubview(self.bookView)
        
        self.gongzuoView.btnClick = {
            let vc = QFTeacherExperienceVC()
            vc.configSubUI(gongzuoArray: self.workArray, jiaoyuArray: self.eduArray)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.jiaoyuView.btnClick = {
            let vc = QFTeacherExperienceVC()
            vc.configSubUI(gongzuoArray: self.workArray, jiaoyuArray: self.eduArray)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.scrolView.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 240/255.0, alpha: 1)
        
        self.introductionView.backgroundColor = .white
        self.gongzuoView.backgroundColor = .white
        self.tagView.backgroundColor = .white
        self.jiaoyuView.backgroundColor = .white
        self.bookView.backgroundColor = .white
        
        self.reloadUI(array: [["height":SCREEN_WIDTH/2.1,"y":0],["height":100,"y":15],["height":100,"y":15],["height":100,"y":15],["height":100,"y":15],["height":100,"y":15]])
        
    }
    
}
