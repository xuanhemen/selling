//
//  ToSetPermanceVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ToSetPermanceVC: UIViewController,UITextFieldDelegate {
   
    

//    let table = UITableView()
    var lookatModel:Dictionary<String,Any>?
    var userid:String = ""
    var isManager:Bool?
    let yearText = UITextField()
    let bottomLable = UILabel()
    var array = Array<ToSetPermanceCell>()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置业绩"

        self.configUI()
    }
    
    func configUI(){
        
        self.setRightBtnWithArray(items: ["完成"])
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 70))
        topView.backgroundColor = kGrayColor_Slapp
        self.view.addSubview(topView)
        
        
        let lable = UILabel.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        lable.text = "年度目标:"
        lable.textColor = UIColor.white
        topView.addSubview(lable)
        
//        let year = UITextField.init(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        yearText.textAlignment = .center
        yearText.backgroundColor = UIColor.groupTableViewBackground
        topView.addSubview(yearText)
        yearText.delegate = self
        
        let lable1 = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        lable1.text = "万"
        lable1.textColor = UIColor.white
        topView.addSubview(lable1)
        
        yearText.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        lable.snp.makeConstraints {[weak yearText] (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.right.equalTo((yearText?.snp.left)!).offset(-10)
            make.centerY.equalTo(yearText!)
        }
        
        lable1.snp.makeConstraints {[weak yearText] (make) in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.left.equalTo((yearText?.snp.right)!).offset(10)
            make.centerY.equalTo(yearText!)
        }
        
       
        
        
        let back = UIScrollView.init(frame: CGRect(x: 0, y: 70, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-70))
        back.contentSize = CGSize(width: MAIN_SCREEN_WIDTH, height: 800+120)
        back.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(back)
        
        
        self.view.addSubview(bottomLable)
        bottomLable.backgroundColor = kGreenColor
        bottomLable.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-30)
            make.height.equalTo(50)
        }
        
        bottomLable.textColor = UIColor.white
        bottomLable.textAlignment = .center
        
        yearText.text = String.noNilStr(str: lookatModel?["planamount"])
        
        for i in 0...3 {
            let cell:ToSetPermanceCell = Bundle.main.loadNibNamed("ToSetPermanceCell", owner: self, options: nil)?.first as! ToSetPermanceCell
            cell.frame = CGRect(x: 0, y: 0+i*200, width: Int(MAIN_SCREEN_WIDTH), height: 200)
            cell.index = i
            cell.lookatModel = lookatModel
            back.addSubview(cell)
            array.append(cell)
            cell.textChange = { [weak self] in
                self?.congfigYear()
            }
        }
        
        self.congfigYear()
    }
    
    func congfigYear(){
        
        var sum = 0.0
        for cell in array {
            sum += cell.mySum
        }
        bottomLable.text = "年度合计：\(sum) 万"
    }
    
    
    override func rightBtnClick(button: UIButton) {
        var sum = 0.0
        for cell in array {
            let check = cell.check()
            if check.0 == false {
                return
//                break
            }else{
                sum += check.1
            }
        }
        
       
        if !String.isNumberType(str: yearText.text!) {
            PublicMethod.toastWithText(toastText: "年度目标必须为数字")
            return
        }else{
            
            if sum != 0 {
            if sum != Double(yearText.text!){

                PublicMethod.toastWithText(toastText: "您的12个月度目标合计数与年度总目标不相等，请修改后再提交", druation: 4)
                return
                }
                
            }
        }
        
        var params = Dictionary<String,Any>()
        var url = "'"
        
        if isManager == true {
             params["dep_id"] = userid
            url = DEP_SAVE
        }else{
            params["userid"] = userid
            url = ONESELF_SAVE
            
        }
        params["planamount"] = yearText.text!
        for cell in array {
            let dic = cell.configData()
            for (key,value) in dic {
                params[key] = value
            }
        }
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { (dic) in
            PublicMethod.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:ToSetPermanceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToSetPermanceCell
//        cell.index = indexPath.row
//        return cell
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField.text?.isEmpty)! {
            textField.text = "0"
        }else{
            let str = textField.text!
            if str.last == "." {
                textField.text = str.replacingOccurrences(of: ".", with: "")
                
            }
            
            
        }
        
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.isEmpty)! && string == "." {
            PublicMethod.toastWithText(toastText: "第一位必须输入数字")
            return false
        }
        
        if string == "."{
            if textField.text?.range(of: string) != nil {
                PublicMethod.toastWithText(toastText: "只能输入一个小数点")
                return false
            }
            
        }
        return true
    }
    
    

}
