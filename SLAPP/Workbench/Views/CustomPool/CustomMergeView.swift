//
//  CustomMergeView.swift
//  SLAPP
//
//  Created by fank on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias EndClosure = () -> ()

typealias StringDictionary = [String:String]

class CustomMergeView: UIView {
    
    var endClosure : EndClosure?
    
    var first : MyCustomListModel!
    var second : MyCustomListModel!
    
    var showArray : [StringDictionary] = []
    
    var selectArray : StringDictionary = [:]
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [MyCustomListModel] = [] {
        didSet {
            self.compareDiffFunc()
        }
    }
    
    func compareDiffFunc() {
        
        self.first = self.dataArray.first!
        self.second = self.dataArray.last!
        
//        if first.nameString != second.nameString {
//            if (first.nameString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.nameString.value] = second.nameString ?? ""
//            } else if (second.nameString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.nameString.value] = first.nameString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.nameString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.nameString)(), MergeShowEnum.first.value:first.nameString ?? "", MergeShowEnum.second.value:second.nameString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.responsibleString != second.responsibleString {
//            if (first.responsibleString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.responsibleString.value] = second.responsibleString ?? ""
//            } else if (second.responsibleString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.responsibleString.value] = first.responsibleString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.responsibleString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.responsibleString)(), MergeShowEnum.first.value:first.responsibleString ?? "", MergeShowEnum.second.value:second.responsibleString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.tradeString != second.tradeString {
//            if (first.tradeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.tradeString.value] = second.tradeString ?? ""
//            } else if (second.tradeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.tradeString.value] = first.tradeString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.tradeString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.tradeString)(), MergeShowEnum.first.value:first.tradeString ?? "", MergeShowEnum.second.value:second.tradeString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.urlString != second.urlString {
//            if (first.urlString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.urlString.value] = second.urlString ?? ""
//            } else if (second.urlString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.urlString.value] = first.urlString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.urlString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.urlString)(), MergeShowEnum.first.value:first.urlString ?? "", MergeShowEnum.second.value:second.urlString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.emailString != second.emailString {
//            if (first.emailString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.emailString.value] = second.emailString ?? ""
//            } else if (second.emailString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.emailString.value] = first.emailString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.emailString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.emailString)(), MergeShowEnum.first.value:first.emailString ?? "", MergeShowEnum.second.value:second.emailString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.phoneString != second.phoneString {
//            if (first.phoneString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.phoneString.value] = second.phoneString ?? ""
//            } else if (second.phoneString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.phoneString.value] = first.phoneString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.phoneString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.phoneString)(), MergeShowEnum.first.value:first.phoneString ?? "", MergeShowEnum.second.value:second.phoneString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.faxString != second.faxString {
//            if (first.faxString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.faxString.value] = second.faxString ?? ""
//            } else if (second.faxString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.faxString.value] = first.faxString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.faxString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.faxString)(), MergeShowEnum.first.value:first.faxString ?? "", MergeShowEnum.second.value:second.faxString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.countString != second.countString {
//            if (first.countString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.countString.value] = second.countString ?? ""
//            } else if (second.countString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.countString.value] = first.countString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.countString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.countString)(), MergeShowEnum.first.value:first.countString ?? "", MergeShowEnum.second.value:second.countString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.postcodeString != second.postcodeString {
//            if (first.postcodeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.postcodeString.value] = second.postcodeString ?? ""
//            } else if (second.postcodeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.postcodeString.value] = first.postcodeString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.postcodeString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.postcodeString)(), MergeShowEnum.first.value:first.postcodeString ?? "", MergeShowEnum.second.value:second.postcodeString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.capitalString != second.capitalString {
//            if (first.capitalString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.capitalString.value] = second.capitalString ?? ""
//            } else if (second.capitalString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.capitalString.value] = first.capitalString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.capitalString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.capitalString)(), MergeShowEnum.first.value:first.capitalString ?? "", MergeShowEnum.second.value:second.capitalString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.remarksString != second.remarksString {
//            if (first.remarksString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.remarksString.value] = second.remarksString ?? ""
//            } else if (second.remarksString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.remarksString.value] = first.remarksString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.remarksString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.remarksString)(), MergeShowEnum.first.value:first.remarksString ?? "", MergeShowEnum.second.value:second.remarksString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.timeString != second.timeString {
//            if (first.timeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.timeString.value] = second.timeString ?? ""
//            } else if (second.timeString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.timeString.value] = first.timeString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.timeString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.timeString)(), MergeShowEnum.first.value:first.timeString ?? "", MergeShowEnum.second.value:second.timeString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.addressString != second.addressString {
//            if (first.addressString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.addressString.value] = second.addressString ?? ""
//            } else if (second.addressString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.addressString.value] = first.addressString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.addressString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.addressString)(), MergeShowEnum.first.value:first.addressString ?? "", MergeShowEnum.second.value:second.addressString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
//        if first.publicSeaString != second.publicSeaString {
//            if (first.publicSeaString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.publicSeaString.value] = second.publicSeaString ?? ""
//            } else if (second.publicSeaString ?? "").trimSpace().isEmpty {
//                self.selectArray[CustomInfoEnum.publicSeaString.value] = first.publicSeaString ?? ""
//            } else {
//                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum.publicSeaString.value, MergeShowEnum.name.value:CustomInfoEnum.description(.publicSeaString)(), MergeShowEnum.first.value:first.publicSeaString ?? "", MergeShowEnum.second.value:second.publicSeaString ?? "", MergeShowEnum.selected.value:"0"])
//            }
//        }
        
        // 用反射代码优雅但是效率略低，每次遍历所有的字段
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.nameString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.responsibleString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.tradeString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.urlString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.emailString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.phoneString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.faxString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.countString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.postcodeString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.capitalString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.remarksString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.timeString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.addressString))
        self.handleDiffFieldFunc(value: String(describing: CustomInfoEnum.publicSeaString))
        
        self.showArray.forEach { (dict) in
            self.selectArray[dict[MergeShowEnum.key.value]!] = ""
        }
        
        self.tableView.reloadData()
    }
    
    func handleDiffFieldFunc(value:String) {
        
        let firstValue = self.getValueByKeyFunc(obj: first, key: value) as? String
        
        let secondValue = self.getValueByKeyFunc(obj: second, key: value) as? String
        
        if firstValue != secondValue {
            if (firstValue ?? "").trimSpace().isEmpty {
                self.selectArray[CustomInfoEnum(type: value).value] = secondValue ?? ""
            } else if (secondValue ?? "").trimSpace().isEmpty {
                self.selectArray[CustomInfoEnum(type: value).value] = firstValue ?? ""
            } else {
                self.showArray.append([MergeShowEnum.key.value:CustomInfoEnum(type: value).value, MergeShowEnum.name.value:CustomInfoEnum(type: value).description(), MergeShowEnum.first.value:firstValue ?? "", MergeShowEnum.second.value:secondValue ?? "", MergeShowEnum.selected.value:"0"])
            }
        }
    }
    
    func getValueByKeyFunc(obj: AnyObject, key: String) -> Any {
        let hMirror = Mirror(reflecting: obj)
        for case let (label?, value) in hMirror.children {
            if label == key {
                return unwrapFunc(any: value)
            }
        }
        return NSNull()
    }
    
    func unwrapFunc(any: Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
    
    @IBAction func submitMergeFunc(_ sender: UIButton) {
        
        var isAllSelect = true
        
        self.selectArray.forEach { (dict) in
            if dict.value == "" { isAllSelect = false }
        }
        
        guard isAllSelect else {
            self.toast(withText: "请选择合并的条目", andDruation: 1)
            return
        }
        
        var params : [String:String] = [:]
        
        params["token"] = UserModel.getUserModel().token ?? ""
        params["main_client_id"] = first.idString
        params["vice_client_id"] = second.idString
        params["main_client_name"] = self.handleValue(key: CustomInfoEnum.nameString.value, value: first.nameString)
        
        let address = self.handleAddressFunc()
        params["province"] = address.province
        params["city"] = address.city
        params["area"] = address.area
        params[CustomInfoEnum.placeString.value] = address.place
        
        params[CustomInfoEnum.responsibleIdString.value] = self.getResponsibleIdFunc()

        let dateString = self.handleValue(key: CustomInfoEnum.timeString.value, value: first.timeString)
        params[CustomInfoEnum.timeString.value] = Date.getTimestamp(dateString: dateString).description
        
        params[CustomInfoEnum.tradeIdString.value] = self.getTradeIdFunc()
        params[CustomInfoEnum.tradeString.value] = self.handleValue(key: CustomInfoEnum.tradeString.value, value: first.tradeString)
        
        params[CustomInfoEnum.phoneString.value] = self.handleValue(key: CustomInfoEnum.phoneString.value, value: first.phoneString)
        params[CustomInfoEnum.faxString.value] = self.handleValue(key: CustomInfoEnum.faxString.value, value: first.faxString)
        
        params[CustomInfoEnum.publicSeaIdString.value] = self.getSeaIdFunc()
        params[CustomInfoEnum.publicSeaString.value] = self.handleValue(key: CustomInfoEnum.publicSeaString.value, value: first.publicSeaString)
        
        params[CustomInfoEnum.urlString.value] = self.handleValue(key: CustomInfoEnum.urlString.value, value: first.urlString)
        params[CustomInfoEnum.capitalString.value] = self.handleValue(key: CustomInfoEnum.capitalString.value, value: first.capitalString)
        params[CustomInfoEnum.remarksString.value] = self.handleValue(key: CustomInfoEnum.remarksString.value, value: first.remarksString)
        params[CustomInfoEnum.emailString.value] = self.handleValue(key: CustomInfoEnum.emailString.value, value: first.emailString)
        params[CustomInfoEnum.countString.value] = self.handleValue(key: CustomInfoEnum.countString.value, value: first.countString)
        
        print("*** params = \(params)")
        
        self.showProgress(withStr: "正在合并中...")
        
        LoginRequest.getPost(methodName: CUSTOM_POOL_MERGE_SEND_MERGE, params: params, hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            if let endClosure = self?.endClosure {
                
                self?.dismiss()
                endClosure()
            }
        }
    }
    
    func handleValue(key: String, value: String?) -> String {
        return self.selectArray[key] ?? value ?? ""
    }
    
    func handleAddressFunc() -> (province:String, city:String, area:String, place:String) {
        
        let result = self.selectArray[CustomInfoEnum.addressString.value]
        if result != nil { // 如果有值，说明选过，如果没有值，说明没选过
            if result == first.addressString {
                return (first.provinceIdString ?? "", first.cityIdString ?? "", first.areaIdString ?? "", first.placeString ?? "")
            } else if result == second.addressString {
                return (second.provinceIdString ?? "", second.cityIdString ?? "", second.areaIdString ?? "", second.placeString ?? "")
            }
        } else {
            return (first.provinceIdString ?? "", first.cityIdString ?? "", first.areaIdString ?? "", first.placeString ?? "")
        }
        return ("", "", "", "")
    }
    
    func getSeaIdFunc() -> String {
        
        let result = self.selectArray[CustomInfoEnum.publicSeaString.value]
        
        if result != nil { // 如果有值，说明选过，如果没有值，说明没选过
            if result == first.publicSeaString {
                return first.publicSeaIdString ?? ""
            } else if result == second.publicSeaString {
                return second.publicSeaIdString ?? ""
            }
        } else {
            return first.publicSeaIdString ?? ""
        }
        return ""
    }
    
    func getTradeIdFunc() -> String {
        
        let result = self.selectArray[CustomInfoEnum.tradeString.value]
        
        if result != nil { // 如果有值，说明选过，如果没有值，说明没选过
            if result == first.tradeString {
                return first.tradeIdString ?? ""
            } else if result == second.tradeString {
                return second.tradeIdString ?? ""
            }
        } else {
            return first.tradeIdString ?? ""
        }
        return ""
    }
    
    func getResponsibleIdFunc() -> String {
        
        let result = self.selectArray[CustomInfoEnum.responsibleString.value]
        
        if result != nil { // 如果有值，说明选过，如果没有值，说明没选过
            if result == first.responsibleString {
                return first.responsibleIdString ?? ""
            } else if result == second.responsibleString {
                return second.responsibleIdString ?? ""
            }
        } else {
            return first.responsibleIdString ?? ""
        }
        return ""
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeBtnClickFunc(_ sender: UIButton) {
        self.dismiss()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.topConstraint.constant = ScreenHeight
        self.alpha = 0
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
//        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            self.topConstraint.constant = 80
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    class func customMergeView() -> CustomMergeView? {
        return R.nib.customPool.secondView(owner: self, options: nil)
    }
}

extension CustomMergeView : CustomMergeCellDelegate {
    
    func customMergeCellBtnClickFunc(key: String, value: String, index: Int, tag: String) {
        self.showArray[index][MergeShowEnum.selected.value] = tag
        self.selectArray[key] = value
    }
}

extension CustomMergeView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = R.nib.customPool.thirdView(owner: self, options: nil)!
        
        cell.model = self.showArray[indexPath.row]
        
        cell.indexInt = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
}
