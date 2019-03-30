//
//  SortAddressVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import LJContactManager
class SortAddressVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var table: UITableView!
   
    
    lazy var search:UISearchBar = {
       let searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width:MAIN_SCREEN_WIDTH, height: 50))
        searchView.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        searchView.placeholder = "搜索"
        return searchView
    }()
    
    var addUserBlock:((_ params:Dictionary<String,Any>,_ model:LJPerson?) -> ())?
    var addContact:Bool = false
    var dep_id = ""
    var currentDataSource:Array = Array<Any>()
    var dataSource:Array = Array<Any>()
    var currentkeys:Array = Array<Any>()
    var keys:Array = Array<Any>()
    /**点击cell回调给创建联系人界面数据*/
    typealias PassSelecteObjc = (LJPerson) -> Void
    @objc var passSelecteObjc:PassSelecteObjc? = nil
    //从新建联系人跳转过来
    @objc var indentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录";
        
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage.init(named: "nav_add"), for: .normal)
        btn.setImage(UIImage.init(named: "nav_add"), for: .highlighted)
        
        btn.addTarget(self, action: #selector(rightClick), for:.touchUpInside)
        let rightBarBtn = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        
        search.delegate = self
        self.view.addSubview(search)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: "cell")
       
        table.tableFooterView = UIView()
       table.delegate = self
        table.dataSource = self;
        
        LJContactManager.sharedInstance().accessSectionContactsComplection {[weak self] (succeed, contacts, keys) in
            
            guard contacts != nil else{
                
                let alert = UIAlertController(title: nil, message:"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的通讯录。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
                })
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
                return;
            }
          
           
            
            self?.dataSource = contacts!
            self?.keys = keys!;
            self?.currentDataSource = contacts!
            self?.currentkeys = keys!
            self?.table.reloadData()
            
            
        }
        
    }
    
    
   
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section < self.currentDataSource.count {
            let sectionModel:LJSectionPerson = self.currentDataSource[section] as! LJSectionPerson;
            return sectionModel.persons.count;
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! ContactTableViewCell
        if indexPath.section < self.currentDataSource.count {
        let sectionModel:LJSectionPerson = self.currentDataSource[indexPath.section] as! LJSectionPerson;
        let personModel:LJPerson = sectionModel.persons[indexPath.row];
            
        cell.model = personModel;
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("选择");
        let sectionModel:LJSectionPerson = self.currentDataSource[indexPath.section] as! LJSectionPerson;
        let personModel:LJPerson = sectionModel.persons[indexPath.row];
        
        if personModel.fullName.isEmpty {
            PublicMethod.toastWithText(toastText: "姓名不能为空")
            return;
        }
        
        if (personModel.phones.count == 0 ) {
            PublicMethod.toastWithText(toastText: "号码不能为空")
            return;
        }else if (personModel.phones.count > 1 ){
            
                        var dic = Dictionary<String,String>()
                        dic.updateValue("取消", forKey: kCancel)
                        for  myPhone:LJPhone in personModel.phones {
                            dic.updateValue(myPhone.phone, forKey: myPhone.phone)
                        }
            
            
                        //多号码做选择
                        let alert = UIAlertController.init(title: "请选择添加号码", message: "", preferredStyle: UIAlertControllerStyle.alert, btns: dic, btnActions: {[weak self] (action, str) in
                            if (str == kCancel) {
                                return
                            }
                            else {
                                self?.configParams(phone: str, model: personModel)
                            }
            
            
            
                        })
                        self.present(alert, animated: true, completion: nil)
            
                    }

        
        
        

        
    }
    
    
    func configParams(phone:String,model:LJPerson){
        
        if phone.isEmpty {
            PublicMethod.toastWithText(toastText: "号码不能为空")
            return;
        }
        
        
        self.toAddEdit(name: model.fullName, phone: phone, model: model)
        
//        let params = ["domains":"CC","username":phone,"realname":model.fullName] as [String : Any];
//
//        self.toADD(params: params, model: <#LJPerson?#>)
    }
    
    
    
    
    
    func toADD(params:Dictionary<String,Any>,model:LJPerson?){
        if addContact == true {
            if self.addUserBlock != nil {
                self.addUserBlock!(params,model)
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            PublicMethod.showProgress()
            
            LoginRequest.getPost(methodName: USER_REGISTER, params: params.addToken(), hadToast: true, fail: { (dic) in
                print(params.addToken())
                
                PublicMethod.dismissWithError()
            }) {[weak self] (dic) in
                PublicMethod.dismiss()
                PublicMethod.toastWithText(toastText: "邀请已发出，请等待该同事"); self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return (currentkeys as! [String]);
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.currentDataSource.count {
            let sectionModel:LJSectionPerson = self.currentDataSource[section] as! LJSectionPerson;
            return sectionModel.key;
        }
        return ""
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if  searchText == ""{
            currentDataSource = dataSource
            currentkeys = keys
            
            table.reloadData()
            return
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentkeys = keys
        currentDataSource.removeAll()
        
        if searchBar.text == nil {
            currentDataSource = dataSource
            table.reloadData()
            return
        }
        let str = searchBar.text!
        for i in 0..<dataSource.count {
            let aModel:LJSectionPerson = dataSource[i] as!  LJSectionPerson
            let bModel = LJSectionPerson()
            
            let pre = NSPredicate.init(format: "fullName CONTAINS %@ OR familyName CONTAINS %@ OR givenName CONTAINS %@ OR phoneticGivenName CONTAINS  %@ OR phoneticMiddleName CONTAINS %@ OR phoneticFamilyName CONTAINS %@ ",str,str,str,str,str,str)
            let array:NSArray = NSArray.init(array: aModel.persons)
            bModel.key = aModel.key
            bModel.persons = array.filtered(using: pre) as! [LJPerson]
            if bModel.persons.count != 0{
                currentDataSource.append(bModel)
            }
        }
        

        table.reloadData()
    }
    
    
    @objc func rightClick(){
        
        self.toAddEdit(name: "", phone: "",model:nil)
    }
    
    func toAddEdit(name:String,phone:String,model:LJPerson?){
        let view:AddcontactView = Bundle.main.loadNibNamed("AddcontactView", owner: self, options: nil)?.last as! AddcontactView
        view.backgroundColor = kGreenColor
        if addContact == true {
             view.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH-40, height: 200)
            view.isManagerView.isHidden = true
        }
        else{
            view.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH-40, height: 240)
        }
        
        let backView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT))
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backView.addSubview(view)
        view.centerX = backView.centerX
        view.centerY = backView.centerY - 100
        APPDelegate.window?.addSubview(backView)
        
        view.namaText.text = name
        view.phoneText.text = phone
        
        view.click = {[weak backView,weak self,weak view] (name,phone) in
            
            if !name.isEmpty {
                
                var manager = "0"
                if view?.isManager == true {
                    manager = "1"
                }
                
                let params = ["manager":manager,"domains":"CC","username":phone,"realname":name,"dep_id":self?.dep_id as Any] as [String : Any];
                
                self?.toADD(params: params,model: model)
                
            }
            
            backView?.removeFromSuperview()
            
            
            
        }
        
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
