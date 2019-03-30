//
//  SLCreateCluesVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SLCluesOperation {
    case create
    case edit
}

class SLCreateCluesVC: BaseVC,UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UITextFieldDelegate,PassSource,PassIndustry,AreaDelegate {
    
    var operation:SLCluesOperation?
    
    //数据源
    var dataArr = [SLAddCluesModel]()
    //更多数据源
    var moreDataArr = [SLAddCluesModel]()
    /**更多展示数据*/
    var moreTitles = [String]()
    
    var dataDic = [String:String]()
    /**参数*/
    var parameters = [String:String]()
    /**性别中间变量*/
    var sexTextField:UITextField?
    /**公海中间变量*/
    var hsTextField:UITextField?
    /**来源中间变量*/
    var scTextField:UITextField?
    /**行业中间变量*/
    var isTextField:UITextField?
    /**地区中间变量*/
    var areaTextField:UITextField?
    /**公司中间变量*/
    var companyTextField:UITextField?
    
    
    /**公海数据*/
    var highSeas = [SLHighSeasModel]()
    /**来源数据源*/
    var sourceArr:[SLSourceModel] = []
    
    var seleModel:SLAddCluesModel?
    /**地域数据源*/
    var areaArr = [SLProvinceModel]()
    /**地区视图*/
    lazy var areaView = SLAreaBottomView()
    /**编辑的时候带过来的数据*/
    var infoDic = [String:String]()
    /**保存成功，返回刷新详情*/
    typealias FreshDetail = (Bool) -> Void
    var fresh:FreshDetail!
    
    var pool:WhichPool?
    /**线索id 编辑时需传*/
    var cluesID:String?
    
    var midTextField:UITextField?
    
    var editInfoDic = [String:Any]()
    
    var titleArr = [String]()
    
    var count:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var style = SLCluesOperation.create
        style = operation ?? .create
        switch style {
        case .create:
            self.title = "创建线索"
            break
        case .edit:
            self.title = "编辑线索"
            break
        }
        
        self.view.backgroundColor = .white
        let rightItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveInfo))
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        /**请求行业，用修改线索的接口*/
        self.requestData()
        /**请求区域*/
        self.requestAreas()
        /**请求编辑数据*/
        self.requestEditData()
        //        /**初始化本地数据*/
        //        self.initData()
        self.tableView.reloadData()
        /**请求来源*/
        self.requestSource()
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        textField.tintColor = UIColor.gray
        //        let model = self.dataArr[textField.tag]
        //        seleModel = model
        //        let key = model.name
        //        if
        if textField.tag == 0{
            return true
        }else{
            self.midTextField?.resignFirstResponder()
            
            return true
        }
        
    }
    //MARK: - 弹出可选项
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.tintColor = UIColor.gray
        let model = self.dataArr[textField.tag]
        seleModel = model
        let key = model.name
        if key == "性别" {
            self.view.endEditing(true)
            sexTextField = textField
            sexTextField!.isEnabled = false
            let sheetView = LCActionSheet.init(title: "请选择性别", buttonTitles: ["男","女"], redButtonIndex: -1, delegate: self)
            sheetView?.tag = 99
            sheetView?.show()
        }else if key == "所属" {
            hsTextField = textField
            hsTextField!.isEnabled = false
            var highSeas = [String]()
            for item in self.highSeas{
                highSeas.append(item.name!)
            }
            let sheetView = LCActionSheet.init(title: "请选择公海", buttonTitles: highSeas, redButtonIndex: -1, delegate: self)
            sheetView?.tag = 77
            sheetView?.show()
            
        }else if key == "来源" {
            textField.tintColor = UIColor.clear
            scTextField = textField
            self.popSourceView()
            self.view.endEditing(true)
        }else if key == "行业"{
            textField.tintColor = UIColor.clear
            isTextField = textField
            let ivc = SLIndustryVC()
            ivc.delegate = self
            self.navigationController?.pushViewController(ivc, animated: true)
            self.view.endEditing(true)
        }else if key == "城市"{
            textField.tintColor = UIColor.clear
            areaTextField = textField
            areaTextField!.isEnabled = false
            let bottomView = SLAreaBottomView.init(array: self.areaArr)
            bottomView.delegate = self
            bottomView.dismissNotice = {
                self.areaTextField!.isEnabled = true
            }
            bottomView.show()
        }else if key == "公司"{
            companyTextField = textField
            companyTextField!.isEnabled = false
            let vc = HYSelectCompanyVC()
            vc.selectBlock = { companyName in
                self.view.endEditing(true)
                self.companyTextField?.isEnabled = true
                self.parameters["corp_name"] = companyName
                self.companyTextField?.text = companyName
                self.seleModel?.content = companyName
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            midTextField = textField
            return
        }
    }
    func passAreaInfo(name: String, provinceID: String, cityID: String, areaID: String) {
        areaTextField!.isEnabled = true
        areaTextField?.text = name
        seleModel?.content = name
        parameters["province"] = provinceID
        parameters["city"] = cityID
        parameters["area"] = areaID
        self.view.endEditing(true)
    }
    //MARK: - 收集参数
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let model = self.dataArr[textField.tag]
        model.content = textField.text
        let key = model.name
        guard key=="所属" || key=="性别" || key == "来源" || key == "行业" else {
            
            let paraKey = self.dataDic[key!]
            self.parameters[paraKey!] = textField.text
            
            return
        }
    }
    //MARK: - 回调行业
    func passValue(name: String, id: String) {
        self.view.endEditing(true)
        self.parameters["trade_id"] = id
        isTextField?.text = name
        seleModel?.content = name
    }
    func isStrEmpty(_ string: String) -> Bool{
        if string.count==0 || string.isEmpty || string=="" {
            return true
        }else{
            return false
        }
    }
    //MARK: - 保存
    @objc func saveInfo(){
        self.view.endEditing(true)
        
        if  let name = parameters["name"]{
            if name==""||name.count==0{
                self.toast(withText: "名字未填写", andDruation: 1.5)
                return
            }
        }else{
            self.toast(withText: "名字未填写", andDruation: 1.5)
            return
        }
        
        if let belongArea = parameters["gonghai_cate"]{
            if belongArea==""||belongArea.count==0{
                self.toast(withText: "所属公海未填写", andDruation: 1.5)
                return
            }
        }else{
            self.toast(withText: "所属公海未填写", andDruation: 1.5)
            return
        }
        self.showProgress(withStr: "正在保存中...")
        var urlString:String = ""
        if pool == WhichPool.privatePool {
            urlString = "pp.clue.addupdate_clue"
        }else{
            urlString = "pp.clue.addupdate_gonghai_clue"
        }
        var style = SLCluesOperation.create
        style = operation ?? .create
        switch style {
        case .create:
            break
        case .edit:
            parameters["id"] = self.cluesID
            break
        }
        print("参数\(parameters)")
        LoginRequest.getPost(methodName: urlString, params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            
            self.showDismiss()
            self.toast(withText: "保存成功", andDruation: 1.5)
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                self.fresh!(true)
                self.navigationController?.popViewController(animated: true)
            })
            
            
        }
        
        
    }
    //MARK: - tableView相关
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section==0 {
            return 40
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIButton.init(type: UIButtonType.custom)
        footView.backgroundColor = .white
        footView.setTitle("添加更多信息", for: UIControlState.normal)
        footView.setTitleColor(RGBA(R: 47, G: 85, B: 199, A: 1), for: UIControlState.normal)
        footView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        footView.addTarget(self, action: #selector(addMoreInfo), for: UIControlEvents.touchUpInside)
        return footView
        
    }
    //MARK: - tableview代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1)
        let title = UILabel()
        if section==0 {
            title.text = "基本信息"
        }else if(section==1){
            title.text = "线索所有人"
        }
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.black
        headView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        return headView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return self.dataArr.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0 {
            let cell = SLAddCluesCell()
            let model = self.dataArr[indexPath.row]
            cell.setCellWithModel(model: model)
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            cell.textField.text = model.content
            if indexPath.row == 1 {
                let logoImageView = UIImageView.init()
                logoImageView.image = UIImage.init(named: "qichacha")
                cell.addSubview(logoImageView)
                logoImageView.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-15)
                    make.size.equalTo(CGSize(width:25,height:25))
                }
            }
            return cell
        }else{
            let cell = UITableViewCell()
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.textLabel?.text = "所有人"
            cell.textLabel?.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
            let lable = UILabel()
            lable.text = "我自己"
            lable.textColor = kTitleColor
            lable.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(lable)
            lable.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - 请求编辑数据
    func requestEditData() {
        var para = [String:String]()
        para["id"] = self.cluesID
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: "pp.clue.edit_clue_page", params: para.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.count += 1
            if self.count==4{
                self.showDismiss()
            }
            if let json = JSON(dataDic).dictionaryObject{
                self.editInfoDic = json
            }
            self.initData()
        }
    }
    //MARK: - 创建数据源
    func initData() {
        /**映射*/
        dataDic = ["姓名":"name","公司":"corp_name","手机":"phone","所属":"gonghai_cate","性别":"sex","行业":"trade_id","部门":"dep","职位":"position","电话":"tel","邮箱":"email","微信":"wechat","QQ":"qq","城市":"province","地址":"address","邮编":"postcode","来源":"source_id","备注":"note"]
        /**初始数据*/
        let contentArr = self.infoDic.keys
        let arr = ["姓名","公司","手机","所属","性别","行业","部门","职位"]
        print("数组\(contentArr)")
        for (index,item) in arr.enumerated() {
            let model = SLAddCluesModel()
            model.name = item
            if index==0 || index==3 {
                model.isLogo = true
            }
            if contentArr.contains(item){
                model.content = self.infoDic[item]
                let key = dataDic[item]
                if item == "所属"{
                    
                    parameters[key!] = self.editInfoDic["gonghai_cate"] as? String
                }else if item == "性别"{
                    parameters[key!] = self.editInfoDic["sex"] as? String
                    
                }else if item == "行业"{
                    parameters[key!] = self.editInfoDic["trade_id"] as? String
                }else{
                    parameters[key!] = model.content
                }
                
            }
            self.dataArr.append(model)
        }
        /**更多数据*/
        moreTitles = ["电话","邮箱","微信","QQ","城市","地址","邮编","来源","备注"]
        for item in moreTitles {
            let model = SLAddCluesModel()
            model.name = item
            if contentArr.contains(item){
                model.content = self.infoDic[item]
                self.dataArr.append(model)
                let key = dataDic[item]
                if item == "城市"{
                    parameters["province"] = self.editInfoDic["province"] as? String
                    parameters["city"] = self.editInfoDic["city"] as? String
                    parameters["area"] = self.editInfoDic["area"] as? String
                }else if item == "来源"{
                    parameters[key!] = self.editInfoDic["source_id"] as? String
                }else{
                    parameters[key!] = model.content
                }
                
            }else{
                self.moreDataArr.append(model)
            }
            
        }
        self.tableView.reloadData()
    }
    //MARK: - 添加更多信息
    @objc func addMoreInfo(){
        
        titleArr.removeAll()
        for model in self.moreDataArr {
            titleArr.append(model.name ?? "")
        }
        let sheetView = LCActionSheet.init(title: "更多信息", buttonTitles: titleArr, redButtonIndex: -1, delegate: self)
        sheetView?.tag = 88
        sheetView?.show()
    }
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        if actionSheet.tag == 88{
            if buttonIndex==titleArr.count {return}
            /**从更多信息中找到model，添加到列表中*/
            let model = self.moreDataArr[buttonIndex]
            self.dataArr.append(model)
            /**相应移除*/
            self.moreDataArr.remove(at: buttonIndex)
            self.moreTitles.remove(at: buttonIndex)
            /**刷新列表*/
            self.tableView.reloadData()
        }else if actionSheet.tag == 99{
            sexTextField!.isEnabled = true
            if buttonIndex==0{
                /**设置参数*/
                self.parameters["sex"] = "0"
                sexTextField?.text = "男"
                seleModel?.content = "男"
            }else if buttonIndex==1{
                /**设置参数*/
                self.parameters["sex"] = "1"
                sexTextField?.text = "女"
                seleModel?.content = "女"
            }else{
                return
            }
        }else if actionSheet.tag == 77{
            hsTextField!.isEnabled = true
            if buttonIndex==highSeas.count {return}
            let model = self.highSeas[buttonIndex]
            /**设置参数*/
            self.parameters["gonghai_cate"] = model.id
            print(parameters)
            self.hsTextField?.text = model.name
            seleModel?.content = model.name
        }
        
        self.view.endEditing(true)
        
    }
    //MARK: - 请求所属公海
    func requestData() {
        let para = [String:String]()
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: "pp.clue.edit_clue_page", params: para.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.count += 1
            if self.count==4{
                self.showDismiss()
            }
            let arr = dataDic["gonghai_cate_arr"] as! [Any]
            self.highSeas = [SLHighSeasModel].deserialize(from: arr) as! [SLHighSeasModel]
        }
    }
    //MARK: - 请求来源
    func requestSource() {
        let para = [String:String]()
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: "pp.clue.source_list", params: para.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.count += 1
            if self.count==4{
                self.showDismiss()
            }
            
            if let json = JSON(dataDic).dictionary,let arr = json["data"]?.arrayObject{
                self.sourceArr = [SLSourceModel].deserialize(from: arr) as! [SLSourceModel]
            }
        }
    }
    //MARK: - 请求区域
    func requestAreas() {
        let para = [String:String]()
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: "pp.user.all_city_message", params: para.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            
            self.count += 1
            if self.count==4{
                self.showDismiss()
            }
            if let json = JSON(dataDic).dictionary,let arr = json["list"]?.arrayObject{
                self.areaArr = [SLProvinceModel].deserialize(from: arr) as! [SLProvinceModel]
            }
        }
    }
    /**弹出来源选择框*/
    func popSourceView() {
        
        let popView = SLPopSourceView()
        popView.delegate = self
        popView.dataArr = sourceArr
        self.view.addSubview(popView)
        UIView.animate(withDuration: 0.3) {
            var frame = popView.frame
            let y = frame.origin.y-300
            frame.origin.y = y
            popView.frame = frame
        }
    }
    /**popview回调参数*/
    func passSourceIDAndName(id: String, name: String) {
        self.parameters["source_id"] = id
        scTextField?.text = name
        seleModel?.content = name
        self.view.endEditing(true)
    }
    //    /**拖拽列表结束编辑*/
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        self.view.endEditing(true)
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

