//
//  ProRolePlanVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProRolePlanVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    var currentName:String = ""
    var currentUserId:String?
    var  scatter:ScatterView?
    var projectId:String = ""
    var myModel:ProBublesModel?
    var peopleModel:bublesPeopleSubModel?
    var model:ProjectSituationModel?
    var lableName:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       
        self.configUI()
        self.configData()
    }

    func configUI(){
        
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.groupTableViewBackground
        
        let labelBackView = UIView.init(frame: CGRect(x: 10, y: 10, width: MAIN_SCREEN_WIDTH-20, height: 40))
        labelBackView.backgroundColor = kBackGreen
        
        let lab = UILabel.init(frame: CGRect(x: 10, y: 0, width: MAIN_SCREEN_WIDTH-40, height: 40))
        lab.textColor = UIColor.white
        lab.text = currentName
        lableName = lab
        labelBackView.addSubview(lab)
        
        let imageView = UIImageView.init(frame: CGRect(x:MAIN_SCREEN_WIDTH-60, y: 5, width: 30, height: 30))
        imageView.image = #imageLiteral(resourceName: "arrowWhite")
        labelBackView.addSubview(imageView)
        
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH-20, height: 40))
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        labelBackView.addSubview(btn)
        
        
        let sView = ScatterView.init(frame: CGRect(x: 10, y: 60, width: MAIN_SCREEN_WIDTH-20, height: MAIN_SCREEN_WIDTH-20))
        sView.backgroundColor = UIColor.white
        sView.selectRoleId = { [weak self] (roleid) in
            
            if self?.currentUserId == roleid {
                            let vc = RoleInfoVC()
                            //vc.isAuth = self?.isAuth
                            vc.situationModel = self?.model
                vc.isEditShow = false
                            vc.id = roleid
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.click = { [weak self] in
                
                            }
            }else{
                self?.currentUserId = roleid
                self?.configData()
            }
            
           

            
        }
        self.scatter = sView
        sView.currentUserId = self.currentUserId!
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_WIDTH+40))
        headView.backgroundColor = UIColor.groupTableViewBackground
        headView.addSubview(sView)
        
        headView.addSubview(labelBackView)
        table.separatorStyle = .none
        table.tableHeaderView = headView
    }
    
    
    @objc func  btnClick(){
        let vc = RoleInfoVC()
    //vc.isAuth = self?.isAuth
        vc.situationModel = self.model
        vc.isEditShow = false
        vc.id = self.currentUserId
        self.navigationController?.pushViewController(vc, animated: true)
        vc.click = { [weak self] in
    
        }
    }
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = self.peopleModel?.plan[indexPath.section].desc ?? ""
        let labelHeight = self.heightForView(text: str, font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH-40)
        return  labelHeight + 40
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        //QF -- mark -- 调整行间距
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: text)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = setStr
        label.sizeToFit()
        return label.frame.height+label.font.ascender
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.peopleModel != nil {
            return (self.peopleModel?.plan.count)!
        }
        return 0
//
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.peopleModel != nil {
            return 1
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:ProBublesCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProBublesCell
        if cell == nil {
            cell = ProBublesCell.init(style: .default, reuseIdentifier: cellIde)
        }
        let text = self.peopleModel?.plan[indexPath.section].desc
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: text!)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (text?.count)!))
        cell?.nameLable.attributedText = setStr
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    
    
    func configData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGICANALYSE_GETPLANSUGGESTION, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
           PublicMethod.dismiss()
        }) { [weak self](dic) in
//            DLog(dic)
//            DLog("ssssssssssssss")
            PublicMethod.dismiss()
            if let model:ProBublesModel = ProBublesModel.deserialize(from: dic){
                self?.myModel = model
                DLog(self?.currentUserId)
                self?.scatter?.configWithModel(model: (self?.myModel)!)
                self?.peopleModel = self?.myModel?.currentModel(userid: (self?.currentUserId)!)
                DLog(self?.peopleModel?.name)
                self?.lableName?.text = self?.peopleModel?.name
                self?.table.reloadData()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
