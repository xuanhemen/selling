//
//  QFAddDepVC.swift
//  SLAPP
//
//  Created by qwp on 2018/5/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFAddDepVC: UIViewController,QFAddressVCDelegate {

    var parent_id = ""
    var parent_name = ""
    
    var provinceId = "0"
    var cityId = "0"
    var regionId = "0"
    var selectDepId = ""
    
    @IBOutlet weak var addButton: UIButton!
    var model:QFDepModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.title == "添加部门" {
            self.depLabel.text = self.parent_name
            self.depLabel.textColor = HexColor("#333333")
            self.nextArrowImageView.isHidden = true
            self.addButton.setTitle("添加", for: .normal)
        }else{
            selectDepId = (model?.parentid)!
            self.depLabel.text = self.parent_name
            self.depLabel.textColor = HexColor("#333333")
            if model?.area_name != "" {
                self.areaLabel.text = model?.area_name
                self.regionId = (model?.area)!
                self.areaLabel.textColor = HexColor("#333333")
            }
            if model?.city_name != "" {
                self.cityLabel.text = model?.city_name
                self.cityId = (model?.city)!
                self.cityLabel.textColor = HexColor("#333333")
            }
            if model?.province_name != "" {
                self.provinceLabel.text = model?.province_name
                self.provinceId = (model?.province)!
                self.provinceLabel.textColor = HexColor("#333333")
            }
            
            self.nameTextField.text = model?.name
            self.shortNameTextField.text = model?.short_name
            self.addButton.setTitle("修改", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var shortNameTextField: UITextField!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var depLabel: UILabel!
    @IBOutlet weak var nextArrowImageView: UIImageView!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBAction func areaButtonClick(_ sender: Any) {
        if cityId == "0" || cityId == ""{
            PublicMethod.toastWithText(toastText: "请先选择城市")
            return
        }
        let addressVC = QFAddressVC()
        addressVC.delegate = self
        addressVC.baseId = cityId
        addressVC.type = .Region
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    @IBAction func cityButtonClick(_ sender: Any) {
        if provinceId == "0" || provinceId == ""{
            PublicMethod.toastWithText(toastText: "请先选择省份")
            return
        }
        let addressVC = QFAddressVC()
        addressVC.delegate = self
        addressVC.baseId = provinceId
        addressVC.type = .City
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    @IBAction func provinceButtonClick(_ sender: Any) {
        let addressVC = QFAddressVC()
        addressVC.delegate = self
        addressVC.type = .Provence
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    @IBAction func addButtonClick(_ sender: Any) {
        if self.nameTextField.text == "" {
            PublicMethod.toastWithText(toastText: "部门名称不能为空")
            return
        }
        if self.shortNameTextField.text == "" {
            PublicMethod.toastWithText(toastText: "部门简称不能为空")
            return
        }
        if self.title == "添加部门" {
            self.addDep()
        }else{
            self.editDep()
        }
        
    }
    
    @IBAction func selectDepButtonClick(_ sender: Any) {
        if self.title == "添加部门" {
            return
        }else{
            let addressVC = QFAddressVC()
            addressVC.delegate = self
            addressVC.baseId = (model?.id)!
            addressVC.type = .Def
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    func selectId(id: String, string: String,type:TYPE) {
        switch type {
        case TYPE.Provence:
                print("QF -- log : 省",id,string)
                if provinceId != id {
                    provinceId = id
                    self.provinceLabel.text = string
                    self.provinceLabel.textColor = HexColor("#333333")
                    self.cityLabel.textColor = HexColor("#666666")
                    self.areaLabel.textColor = HexColor("#666666")
                    cityId = ""
                    regionId = ""
                    self.cityLabel.text = "请选择市"
                    self.areaLabel.text = "请选择地区"
                }
            break
        case TYPE.City:
            print("QF -- log : 市",id,string)
            if cityId != id {
                cityId = id
                self.cityLabel.text = string
                regionId = ""
                self.areaLabel.text = "请选择地区"
                self.cityLabel.textColor = HexColor("#333333")
                self.areaLabel.textColor = HexColor("#666666")
            }
            break
        case TYPE.Region:
            print("QF -- log : 地区",id,string)
            if regionId != id {
                regionId = id
                self.areaLabel.text = string
                self.areaLabel.textColor = HexColor("#333333")
            }
            break
        case TYPE.Def:
            print("QF -- log : 部门",id,string)
            if selectDepId != id {
                selectDepId = id
                self.depLabel.text = string
                self.depLabel.textColor = HexColor("#333333")
            }
            break
        default:
            break
        }
        
    }
    
    //添加部门
    func addDep(){
        PublicMethod.showProgress()
        let name = self.nameTextField.text
        let shortName = self.shortNameTextField.text

        LoginRequest.getPost(methodName: QF_ADD_DEP, params:["parent_id":parent_id,"name":name,"short_name":shortName,"provinceid":provinceId,"cityid":cityId,"areaid":regionId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    //修改部门
    func editDep(){
        PublicMethod.showProgress()
        let name = self.nameTextField.text
        let shortName = self.shortNameTextField.text
        
        LoginRequest.getPost(methodName: QF_EDIT_DEP, params:["parent_id":selectDepId,"dep_id":model?.id,"name":name,"short_name":shortName,"provinceid":provinceId,"cityid":cityId,"areaid":regionId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
