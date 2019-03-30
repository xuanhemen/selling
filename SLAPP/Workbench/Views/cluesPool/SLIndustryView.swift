//
//  SLIndustryView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLIndustryView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    /**数据源*/
    var dataArr = [SLIndustryModel]()
    /**数据源*/
    var subDataArr = [SLIndustryModel]()
    
    /**中间变量模型*/
    var seletedModel:SLIndustryModel?
    /**中间变量模型*/
    var levelTwoModel:SLIndustryModel?
    typealias PassModel = (SLIndustryModel,SLIndustryModel) -> Void
    var passModel:PassModel?
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect,array: [SLIndustryModel]) {
        super.init(frame: frame)
        
    }
    lazy var levelOneTableView: UITableView = {
        let levelOneTableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        levelOneTableView.tag = 111
        levelOneTableView.delegate = self
        levelOneTableView.dataSource = self
        levelOneTableView.tableFooterView = UIView()
        levelOneTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        levelOneTableView.register(SLIndustryCell.self, forCellReuseIdentifier: "Industry")
        self.addSubview(levelOneTableView)
        levelOneTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH/2)
            make.left.equalToSuperview()
        }
        return levelOneTableView
    }()
    lazy var levelTwoTableView: UITableView = {
        let levelTwoTableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        levelTwoTableView.tag = 222
        levelTwoTableView.delegate = self
        levelTwoTableView.dataSource = self
        levelTwoTableView.tableFooterView = UIView()
        levelTwoTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        levelTwoTableView.register(SLIndustryCell.self, forCellReuseIdentifier: "Industry")
        self.addSubview(levelTwoTableView)
        levelTwoTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH/2)
            make.right.equalToSuperview()
        }
        return levelTwoTableView
    }()
    //MARK: - 代理相关
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag==111 {
            return dataArr.count
        }else{
           return subDataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Industry") as! SLIndustryCell
        var model:SLIndustryModel!
        if tableView.tag == 111{
            model = self.dataArr[indexPath.row]
        }else{
            model = self.subDataArr[indexPath.row]
        }
        cell.name.text = model.name
        if model.select == false {
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.tintColor = RGBA(R: 88, G: 195, B: 88, A: 1)
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.tintColor = RGBA(R: 88, G: 195, B: 88, A: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag==111 {
            let model = self.dataArr[indexPath.row]
            if model != self.seletedModel{
                model.select = true
                self.seletedModel?.select = false
                self.seletedModel = model
            }
            self.levelOneTableView.reloadData()
            self.subDataArr = model.subArray
            self.levelTwoTableView.reloadData()
        }else{
            let model = self.subDataArr[indexPath.row]
            self.levelTwoModel = model
            self.passModel!(self.seletedModel!,self.levelTwoModel!)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
