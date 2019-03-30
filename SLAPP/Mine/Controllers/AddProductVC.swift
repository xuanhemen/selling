//
//  AddProductVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddProductVC: BaseVC {
    var model:Dictionary<String,Any>?
    

    
    @IBOutlet weak var backView: UIView!
    var parentid : String?
    @IBOutlet weak var myText: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cacelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveBtn.backgroundColor = kGreenColor
        self.backView.layer.cornerRadius = 2
        self.backView.layer.borderWidth = 1
        self.backView.layer.borderColor = UIColor.lightGray.cgColor
        
        if model != nil {
            self.title = "修改产品"
            myText.text = model?["name"] as! String
        }else{
            
            self.title = "增加产品"
        }
    }

    func add(name:String){
        
        var params:Dictionary<String,Any> = Dictionary()
        if name == PRODUCT_EDIT {
            params["name"] = myText.text
            params["parentid"] = parentid!
            params["id"] = model?["id"]
        }
        else{
            params["name"] = myText.text
            params["parentid"] = parentid!
            
            
        }
        
        params = params.addToken()
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: name, params: params, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            
        }) { [weak self] (dic) in
             PublicMethod.dismiss()
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    @IBAction func saveclick(_ sender: Any) {
        if (self.myText.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "产品名称不能为空")
            return
        }
        
        if model == nil {
            self.add(name: PRODUCT_ADD)
            
        }else{
            
            self.add(name: PRODUCT_EDIT)
        }
        
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
