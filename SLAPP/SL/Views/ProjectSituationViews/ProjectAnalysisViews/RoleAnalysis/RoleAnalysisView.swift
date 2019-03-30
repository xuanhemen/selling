//
//  RoleAnalysisView.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
public enum clickType : Int {
    
    //增加角色
    case add
    //生成分析报告
    case creat
}

class RoleAnalysisView: UIView,UITableViewDelegate,UITableViewDataSource{
     let createBtn = UIButton.init(type: .custom)
    var isAuth:Bool = false
    var model:ProjectSituationModel?{
        didSet{
            table.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configUI()
    }
    
    
    var click:(_ type:clickType)->() = {_ in 
        
    }
    
    //1删除  0 点击  2修改
    var roleAction:(_ type:Int,_ pid:String,_ index:IndexPath)->() = { _,_,_ in
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
       
        self.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
//            make.height.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.backgroundColor = UIColor.groupTableViewBackground
        table.delegate = self
        table.dataSource = self
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 200))
        view.backgroundColor = UIColor.groupTableViewBackground
        table.tableFooterView = view
        
        let addBtn = UIButton.init(type: .custom)
        addBtn.setTitle("添加客户角色", for: .normal)
        addBtn.backgroundColor = UIColor.gray
        view.addSubview(addBtn)
        
       
        createBtn.setTitle("全部填完,生成分析报告", for: .normal)
        createBtn.backgroundColor = kGreenColor
        view.addSubview(createBtn)
        
        addBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        createBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(120)
             make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        addBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        createBtn.addTarget(self, action: #selector(createBtnClick), for: .touchUpInside)
    }
    
    
    @objc func addClick(){
        self.click(.add)
    }
    
    @objc func createBtnClick(){
        self.click(.creat)
    }
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model != nil {
            return  self.model!.logic_people.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "LogicPeopleCell"
        var cell:LogicPeopleCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? LogicPeopleCell
        if cell == nil {
            cell = LogicPeopleCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.click = {[weak self,weak cell] (model) in
            self?.roleAction(1,(cell?.model?.id)!,indexPath);
        }
        cell?.model = self.model?.logic_people[indexPath.row]
        if cell?.model?.whether_input == "0" {
            cell?.red.isHidden = false
        }else{
            cell?.red.isHidden = true
        }
      
        cell?.btn.isHidden = !self.isAuth
        cell?.btn.isHidden = true
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel:LogicPeopleModel = (self.model?.logic_people[indexPath.row])!
        if cellModel.whether_input == "0" {
            self.roleAction(2,(self.model?.logic_people[indexPath.row].id)!,indexPath);
        }else{
            self.roleAction(0,(self.model?.logic_people[indexPath.row].id)!,indexPath);
        }
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
}
