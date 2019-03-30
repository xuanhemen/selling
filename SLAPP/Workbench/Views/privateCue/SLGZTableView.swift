//
//  SLGZTableView.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/5.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLGZTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    typealias PassContentOfSet = (CGFloat) -> Void
    var ofSet:PassContentOfSet?
    /**数据源*/
    var dataArr = [SLFollowUpModel]()
    /**弹出键盘通知*/
    typealias PopKeyBoard = (_ section: Int,_ row: Int,_ style: String) -> Void
    var popTextView: PopKeyBoard?
    
    lazy var popView: SLAutoPopView = {
        let popView = SLAutoPopView.init()
        popView.suportBtn.addTarget(self, action: #selector(suport), for: UIControlEvents.touchUpInside)
        popView.commentsBtn.addTarget(self, action: #selector(comments), for: UIControlEvents.touchUpInside)
        return popView
    }()
    
    var seleID:String?
    
    
    var selectedBtn:UIButton?
    
    var seBtn:UIButton?
    
    var selectedCell: SLAutoContentCell?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataArr[section]
        let count = model.comments?.count ?? 0
        return count + 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        headView.backgroundColor = UIColor.lightGray
        return headView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView.init()
        footView.backgroundColor = .white
        return footView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row==1 {
            let model = self.dataArr[indexPath.section]
            if model.support?.count==0 {
                return 0
            }else{
                return UITableViewAutomaticDimension
            }
            
        }else if indexPath.row==0{
            return UITableViewAutomaticDimension
        }else{
            let model = self.dataArr[indexPath.section]
            if model.comments?.count==0 {
                return 0
            }else{
                return UITableViewAutomaticDimension
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = SLAutoContentCell.init()
            cell.setCell(model: model,section: indexPath.section)
            let tap = UITapGestureRecognizer.init()
            tap.addTarget(self, action: #selector(headImageClicked))
            cell.headImageView.isUserInteractionEnabled = true
            cell.headImageView.tag = indexPath.section
            cell.headImageView.addGestureRecognizer(tap)
            cell.pop = { (button,title) in
                self.seleID = button.selectID
                var center = button.center
                self.popView.center.x = center.x
                self.popView.center.y = cell.time.center.y
                self.popView.size = CGSize(width: 0, height: 30)
                self.popView.suportBtn.setTitle(title, for: UIControlState.normal)
                self.popView.suportBtn.tag = indexPath.section
                self.popView.commentsBtn.tag = indexPath.section
                if button != self.selectedBtn{
                    self.selectedBtn?.isSelected = false
                    self.selectedBtn = button
                    self.popView.center = center
                    
                    self.seBtn = button
                }
                
                cell.addSubview(self.popView)
                button.isSelected = !button.isSelected
                if button.isSelected == true {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.popView.size = CGSize(width: 120, height: 30)
                        center.x = center.x - 82
                        self.popView.center = center
                    })
                    
                }
                
            }
            cell.delete = { section in
                self.dataArr.remove(at: section)
                self.reloadData()
            }
            return cell
        }else if indexPath.row == 1 {
            let cell = SLSuportCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            var string:String = ""
            for (index,objc) in model.support!.enumerated() {
                if index == 0 {
                    string = string.appendingFormat("%@", objc.realname ?? "")
                }else{
                    string = string.appendingFormat(",%@", objc.realname ?? "")
                }
            }
            if model.support?.count != 0{
                cell.likeView.image = UIImage(named: "Like")
            }
            cell.content.text = string
            return cell
        }else{
            let commentModel = model.comments![indexPath.row-2]
            let cell = SLCommentsInfoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            let toRealName = commentModel.to_realname ?? ""
            let string = toRealName == "" ?"：":"回复\(toRealName)："
            let str = (commentModel.create_realname ?? "")+string+(commentModel.content ?? "")
            
            let conversion = SLConversion.init()
            let attiStr = conversion.conversion(str, andReleName: commentModel.create_realname ?? "", reply: toRealName)
            conversion.releClick = { (number) in
                let pvc = PersonalCenterVC()
                pvc.tcpUserid = ""
                if number==0{
                    pvc.userId = commentModel.create_userid ?? ""
                }else if number==1{
                    pvc.userId = commentModel.to_userid ?? ""
                }
                let vc = self.nextresponsder(viewself: self)
                vc.navigationController?.pushViewController(pvc, animated: true)
            }
            cell.content.attributedText = attiStr
            return cell
        }
        
    }
    //MARK: - 头像点击
    @objc func headImageClicked(ges: UITapGestureRecognizer) {
        let model = self.dataArr[(ges.view?.tag)!]
        let pvc = PersonalCenterVC()
        pvc.tcpUserid = ""
        pvc.userId = model.userid ?? ""
        let vc = self.nextresponsder(viewself: self)
        vc.navigationController?.pushViewController(pvc, animated: true)
    }
    //MARK: - 删除评论或回复评论
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            self.selectedBtn?.isSelected = false
            self.selectedBtn = self.seBtn
            self.popView.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
            return
        }
        if indexPath.row == 1{return}
        let model = self.dataArr[indexPath.section]
        let commentModel = model.comments![indexPath.row-2]
        if commentModel.is_me == 0 {//回复评论
            self.popTextView!(indexPath.section,indexPath.row-2,"reply")
        }else if commentModel.is_me == 1 {//删除评论
            let reminStr = "你确定要删除自己的评论吗"
            let alertVC = UIAlertController.init(title: "", message: reminStr, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                return
            }
            let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
                
                self.showProgress(withStr: "正在加载中...")
                var parameters = [String:String]()
                parameters["id"] = commentModel.id
                LoginRequest.getPost(methodName: "pp.followup.comment_del", params: parameters.addToken(), hadToast: true, fail: { (error) in
                    print(error)
                    
                }) { (dataDic) in
                    self.showDismiss()
                    model.comments?.remove(commentModel)
                    self.reloadSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.fade)
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(sureAction)
            let vc = self.nextresponsder(viewself: self)
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    /**找出父视图*/
    func nextresponsder(viewself:UIView)->UIViewController{
        var vc:UIResponder = viewself
        
        while vc.isKind(of: UIViewController.self) != true {
            vc = vc.next!
        }
        return vc as! UIViewController
    }
    //MARK: - 点赞
    @objc func suport(button: UIButton) {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["fo_id"] = self.seleID
        LoginRequest.getPost(methodName: "pp.followup.support", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            var idString:String = ""
            let model = self.dataArr[button.tag]
            for objc in model.support! {
                idString = idString.appendingFormat(",%@", objc.userid!)
            }
            let userModel = UserModel.getUserModel()
            
            if idString.contains(userModel.id!) {
                for objc in model.support! {
                    if objc.userid==userModel.id{
                        model.support?.remove(objc)
                    }
                }
            } else {
                let suportModel = SLSupportModel()
                suportModel.userid = userModel.id
                suportModel.realname = userModel.realname
                model.support?.append(suportModel)
            }
            
            self.reloadSections(IndexSet.init(integer: button.tag), with: UITableViewRowAnimation.fade)
        }
        
    }
    //MARK: - 点击评论
    @objc func comments(button: UIButton) {
        //弹出输入框
        self.popTextView!(button.tag,0,"comments")
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
        self.dataSource = self
        self.delegate = self
        self.sectionFooterHeight = 10
        self.tableFooterView = UIView.init()
        // self.register(SLAutoContentCell.self, forCellReuseIdentifier: "followUp")
        self.estimatedRowHeight = 250
        self.rowHeight = UITableViewAutomaticDimension
        self.separatorColor = UIColor.clear
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.selectedBtn?.isSelected = false
        self.selectedBtn = self.seBtn
        self.popView.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        let ofSetY = scrollView.contentOffset.y
        print(ofSetY)
        if ofSetY>=0 && ofSetY<=SLHeadViewHeight {
            self.ofSet!(ofSetY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

