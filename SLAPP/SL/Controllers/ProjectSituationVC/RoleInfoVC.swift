//
//  RoleInfoVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import YBPopupMenu
class RoleInfoVC: BaseVC,UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate {
    //是否有编辑权限
    var isAuth:Bool?
    var isEditShow = true
    var click:()->() = {
        
    }
    var organizationChart:()->() = {
        
    }
    var titleArray = ["风格:","细分角色:","影响力:","参与度:","反馈态度:","支持度:","组织结果:","个人赢:","直接上级:"]
    var model:LogicPeopleInfoModel?
    var situationModel:ProjectSituationModel?
    var id:String?
    var isChange:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData(strId: id!)
    }

    
    func toRefresh(){
        self.isChange = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
    }
    
    func configData(strId:String){
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGIC_PEOPLE_INFO, params: ["people_id": id!].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
             PublicMethod.dismiss()
            if let mymodel = LogicPeopleInfoModel.deserialize(from: dic){
                self?.model = mymodel
                if Int(mymodel.save_auth)!>=1  {
                    if self?.isEditShow == true {
                        self?.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
                    }
                }
                if !(self?.model?.coach_str.isEmpty)! {
                    self?.titleArray.insert("指导级别:", at: 8)
                }
                self?.table.reloadData()
            }
           
        }
        

    }
    
    func configUI(){
        
        self.title = "角色信息"
        self.view.addSubview(self.table)
        self.table.separatorStyle = .none
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(kBottomSpace)
        }
        table.register(ProRoleInfoCell.self, forCellReuseIdentifier: "cell")
        self.table.delegate = self
        self.table.dataSource = self
        table.backgroundColor = UIColor.groupTableViewBackground
        
        if isEditShow == true {
            if self.isAuth == true {
                
                self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
            }
        }
        
        
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem.init(customView: btn)
    
       self.navigationItem.backBarButtonItem = barButtonItem
        
//        self.  nav_back
    }
    
    @objc func leftBtnClick(){
        if self.isChange {
            self.click()
        }
        self.organizationChart()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func rightBtnClick(button: UIButton) {
        
        YBPopupMenu.showRely(on: button, titles: ["编辑","删除"], icons: ["menuCopy","menuDelete"], menuWidth: 100, delegate: self)

    }
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        
        
        if index == 0 {
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName:PARAM_PEOPLE, params: ["project_id":self.situationModel?.id].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }, success: {[weak self] (dic) in
                
                PublicMethod.dismiss()
                if  let model:ProParamsPeople = ProParamsPeople.deserialize(from: dic)!{
                    let vc =  ProjectAddRoleAnalysisVC();
                    vc.projectId = self?.model?.id
                    vc.parentid = (self?.model?.parentid)!
                    vc.situationModel = self?.situationModel
                    vc.model = model;
                    vc.peopleId = self?.model?.id
                    
                    vc.textArray = [ self?.model?.name,self?.model?.department,self?.model?.level_str,self?.model?.style_str,self?.model?.sub_str,self?.model?.impact_str,self?.model?.engagement_str,self?.model?.feedback_str,self?.model?.support_str,self?.model?.orgresult_str,self?.model?.personalwin_str,self?.model?.parent_str,] as! [String];
                    if !(self?.model?.coach_str.isEmpty)! {
                        vc.textArray.insert((self?.model?.coach_str)!, at: 11)
                    }
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    vc.click = {[weak self](_,str) in
                        //                    self?.configData(strId: str)
                        self?.id = str;
                        self?.toRefresh();
                    }
                }
            })
        }
        if index == 1 {
            let alert = UIAlertController.init(title: "确定删除吗？", message: "", preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: { (ac, str) in
                if str != kCancel {
                    self.toDeleteLogicPeople(model: self.model!)
                }
            })
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //删除角色信息
    func toDeleteLogicPeople(model:LogicPeopleInfoModel){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DEL_PEOPLE, params: ["people_id":model.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            self?.toRefresh();
            self?.navigationController?.popViewController(animated: true)
            PublicMethod.dismissWithSuccess(str: "删除成功")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titleArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        let backView = UIView.init()
        backView.backgroundColor = .white
        headerView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
    
        let imageView = UIImageView()
        backView.addSubview(imageView)
        //imageView.backgroundColor = .red
        imageView.image = #imageLiteral(resourceName: "mine_avatar")
        imageView.layer.cornerRadius = (headerView.frame.size.height-35)/2.0
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(30)
            make.bottom.equalTo(-10)
            make.width.equalTo(imageView.snp.height)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.textColor = HexColor("#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        backView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(30)
            make.top.equalTo(10)
            make.height.equalTo((headerView.frame.size.height-35)/2.0)
            make.width.equalTo(100)
        }
        let bumenLabel = UILabel()
        bumenLabel.text = ""
        bumenLabel.textColor = HexColor("#888888")
        bumenLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        backView.addSubview(bumenLabel)
        bumenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.top.equalTo(10)
            make.height.equalTo((headerView.frame.size.height-35)/2.0)
            make.right.equalTo(-10)
        }
        let zhiweiLabel = UILabel()
        zhiweiLabel.text = ""
        zhiweiLabel.textColor = HexColor("#666666")
        zhiweiLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        backView.addSubview(zhiweiLabel)
        zhiweiLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.equalTo(-10)
            make.height.equalTo((headerView.frame.size.height-35)/2.0)
            make.right.equalTo(-30)
        }
        if self.model != nil {
            nameLabel.text = model?.name
            bumenLabel.text = model?.department
            zhiweiLabel.text = model?.level_str
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:ProRoleInfoCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! ProRoleInfoCell
        cell.nameLable.text = self.titleArray[indexPath.row]
        let image = #imageLiteral(resourceName: "QF_Tag_Red")
        
        if self.model != nil {
            switch indexPath.row+3 {
            case 3:
                cell.contentLable.text = model?.style_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.style_color)!)), image: image)
            case 4:
                cell.contentLable.text = model?.sub_str
                cell.rightImageView.image = nil
            case 5:
                cell.contentLable.text = model?.impact_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.impact_color)!)), image: image)
            case 6:
                cell.contentLable.text = model?.engagement_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.engagement_color)!)), image: image)
            case 7:
                cell.contentLable.text = model?.feedback_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.feedback_color)!)), image: image)
            case 8:
                cell.contentLable.text = model?.support_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.support_color)!)), image: image)
            case 9:
                cell.contentLable.text = model?.orgresult_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.orgresult_color)!)), image: image)
            case 10:
                cell.contentLable.text = model?.personalwin_str
                cell.rightImageView.image = self.imageWithColor(color: HexColor(String.init(format: "#%@", (model?.personalwin_color)!)), image: image)
                
            default:
                break
            }
            
            if titleArray[indexPath.row] == "指导级别:"{
                cell.contentLable.text = model?.coach_str
            }else if titleArray[indexPath.row] == "直接上级:"{
                cell.contentLable.text = model?.parent_str
            }
            
            cell.contentLable.text =  cell.contentLable.text?.doAwayColon()
        }
        
        return cell
    }
    //QF -- Tool : 改图片颜色
    func imageWithColor(color:UIColor,image:UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context?.clip(to: rect, mask: image.cgImage!)
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
