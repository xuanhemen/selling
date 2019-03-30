//
//  EvaluateTeacherView.swift
//  SLAPP
//
//  Created by rms on 2018/2/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

let scrollView_Y : CGFloat = 130
class EvaluateTeacherView: UIView {

    let btn_WH : CGFloat = 30
    let btn_Margin : CGFloat = 10
    var bgView : UIView!
    var bgScrollView : UIScrollView!
    var otherTextF : UITextField!
    var score : String! //导师的分
    var valuesTagArr = Array<Int>() //选择的标签tag
    var valuesArr = Array<Any>() // 获取的导师评价标签
    var consultId : String! //辅导id
    var teacherId : String! //导师id
    var willgoback = {}
    convenience init(consultId : String, teacherId : String, frame:CGRect) {
        self.init()
        self.frame = frame
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.consultId = consultId
        self.teacherId = teacherId
        self.score = "0"
        bgView = UIView.init(frame: CGRect.init(x: LEFT_PADDING, y: 20, width: frame.size.width - 2 * LEFT_PADDING, height: frame.size.height - 2 * 20 - NAV_HEIGHT))
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        let closeBtn = UIButton.init(frame: CGRect.init(x: 15, y: 15, width: 35, height: 35))
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchDown)
        closeBtn.setImage(UIImage.init(named: "close"), for: .normal)
        bgView.addSubview(closeBtn)
        
        let titlelb = UILabel.init(frame: CGRect.init(x: (bgView.frame.size.width - 100) * 0.5, y: 15, width: 100, height: 30))
        titlelb.textColor = UIColor.black
        titlelb.text = "辅导评价"
        titlelb.textAlignment = .center
        bgView.addSubview(titlelb)
        
        for i in 0..<5 {
            let btn = UIButton.init(frame: CGRect.init(x: (bgView.frame.size.width - (btn_WH * 5.0 + btn_Margin * 4.0)) * 0.5 + (btn_WH + btn_Margin) * CGFloat(i), y: 70, width: btn_WH, height: btn_WH))
            btn.addTarget(self, action: #selector(starBtnClick), for: .touchDown)
            btn.tag = 10 + i
            btn.setImage(UIImage.init(named: "evaluate_star_normal"), for: .normal)
            btn.setImage(UIImage.init(named: "evaluate_star_select"), for: .selected)
            btn.adjustsImageWhenHighlighted = false
            bgView.addSubview(btn)
        }
        
        let submitBtn = UIButton.init(frame: CGRect.init(x: LEFT_PADDING, y: bgView.height - 15 - 40, width: bgView.width - 2 * LEFT_PADDING, height: 40))
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchDown)
        submitBtn.backgroundColor = kGreenColor
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        submitBtn.setTitle("提交", for: .normal)
        bgView.addSubview(submitBtn)
        
        bgScrollView = UIScrollView.init(frame: CGRect.init(x: LEFT_PADDING, y: scrollView_Y, width: bgView.width - 2 * LEFT_PADDING, height: bgView.height - scrollView_Y - 40 - 15 * 2))
        bgView.addSubview(bgScrollView)
        otherTextF = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: bgScrollView.width, height: 40))
        otherTextF.layer.borderWidth = 0.5
        otherTextF.layer.borderColor = UIColor.gray.cgColor
        otherTextF.placeholder = "其他想说的(将匿名并延迟告知导师)"
        bgScrollView.addSubview(otherTextF)
        self.getTeacherValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func closeBtnClick(btn:UIButton){
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
        self.willgoback()
    }
    //打分
    @objc func starBtnClick(btn:UIButton){
        self.score = "\(btn.tag - 10 + 1)"
        for subView in bgView.subviews {
            if subView is UIButton
            {
                if (subView.tag >= 10 && subView.tag <= btn.tag) {
                    (subView as! UIButton).isSelected = true
                }else if subView.tag > btn.tag{
                    (subView as! UIButton).isSelected = false
                }
            }
        }
    }
    //提交
    @objc func submitBtnClick(){
    
        DLog(self.valuesTagArr)
        var valuesTempArr = Array<String>()
        for i in 0..<self.valuesTagArr.count{
            if self.valuesArr[i] is Dictionary<String,Any>{
                
                valuesTempArr.append((self.valuesArr[self.valuesTagArr[i] - 100] as! Dictionary<String,Any>)["name"] as! String)
            }
        }
        PublicMethod.showProgressWithStr(statusStr: "正在提交...")
        LoginRequest.getPost(methodName: CONSULT_TEACHER_SCORE, params: ["consult_id":self.consultId,"teacher_id":self.teacherId,"fen":self.score,"value":SignTool.makeJsonStrWith(object: valuesTempArr),"other_value":self.otherTextF.text!].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismissWithSuccess(str: "评价成功")
            NotificationCenter.default.removeObserver(self!)
            self?.removeFromSuperview()
            self?.willgoback()
        }
    }
    @objc func valueBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.valuesTagArr.append(btn.tag)
            btn.backgroundColor = kGreenColor
            btn.setTitleColor(UIColor.white, for: .normal)
        }else{
            for i in 0..<self.valuesTagArr.count{
                if self.valuesTagArr[i] == btn.tag{
                    self.valuesTagArr.remove(at: i)
                    break
                }
            }
            btn.backgroundColor = HexColor("e9e9e9")
            btn.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    @objc func keyboardShow(notify:NSNotification) {
        
        let beginKeyboardRect = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect)
        let endKeyboardRect = (notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect)
        
        let yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y
        let duration = notify.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        
        UIView.animate(withDuration: duration as! TimeInterval) {
            
            self.bgScrollView.contentOffset = CGPoint.init(x: 0, y: -(yOffset + self.bgScrollView.height - self.otherTextF.y + 35))
            
        }
    }
    @objc func keyboardHide(notify:NSNotification) {

        let duration = notify.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        
        UIView.animate(withDuration: duration as! TimeInterval) {
            
            self.bgScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
            
        }
    }
    
    func getTeacherValues(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONSULT_TEACHER_VALUE, params: ["teacher_id":self.teacherId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if dic["data"] is Array<Any>{
                self?.valuesArr = dic["data"] as! Array<Any>
                let scrollView_maxHeight = (self?.bgScrollView.height)! - 40
                let valuesCount = CGFloat((dic["data"] as! Array<Any>).count)
                if valuesCount > 0{
                    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: (self?.bgScrollView.width)!, height: (ceil(valuesCount/2) * 50 < scrollView_maxHeight) ? ceil(valuesCount/2)  * 50 : scrollView_maxHeight))
                    scrollView.contentSize = CGSize.init(width: scrollView.width, height: ceil(valuesCount/2) * 50)
                    self?.bgScrollView.addSubview(scrollView)
                    let btn_maigin : CGFloat = 15
                    let btn_width = (scrollView.width - btn_maigin) * 0.5
                    let btn_height : CGFloat = 35
                    for i in 0..<(dic["data"] as! Array<Any>).count {
                        let btnX = CGFloat(i%2) * (btn_width + btn_maigin)
                        let btnY = CGFloat(i/2) * (btn_height + btn_maigin)

                        let btn = UIButton.init(frame: CGRect.init(x: btnX, y: btnY, width: btn_width, height: btn_height))
                        btn.tag = 100 + i
                        btn.addTarget(self, action: #selector(self?.valueBtnClick), for: .touchDown)
                        btn.backgroundColor = HexColor("e9e9e9")
                        btn.setTitleColor(UIColor.darkGray, for: .normal)
                        btn.titleLabel?.font = kFont_Small
                        if (dic["data"] as! Array<Any>)[i] is Dictionary<String,Any>{
                            
                            btn.setTitle((((dic["data"] as! Array<Any>)[i] as! Dictionary<String,Any>)["name"] as? String)! + "(" + String.noNilStr(str: ((dic["data"] as! Array<Any>)[i] as! Dictionary<String,Any>)["count"]) + ")", for: .normal)
                        }
                        scrollView.addSubview(btn)
                    }
                    self?.otherTextF.y += scrollView.height
                }
            }
        }
        
    }

}
