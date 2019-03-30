//
//  SituationAndFlowCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SituationAndFlowCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    
    var myclick:()->() = { 
        
    }
    
    
    var model:ProAnalysisModel?{
        
        didSet{
            self.nameLable.text = model?.title
            table.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    
    func configUI(){
        
        self.contentView.addSubview(headImage)
        
        self.contentView.addSubview(topleftImage)
         self.contentView.addSubview(toprightImage)
        self.contentView.addSubview(topImage)
        self.topImage.addSubview(nameLable)
        self.topImage.addSubview(topMarkImage)
        self.contentView.addSubview(table)
        table.delegate = self;
        table.dataSource = self;
        
        
        
        headImage.layer.cornerRadius = 8
        headImage.clipsToBounds = true
        headImage.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        topImage.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(-9)
            make.right.equalTo(9)
            make.height.equalTo(40)
        }
        
        topleftImage.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo(20)
            make.right.equalTo((self?.contentView.snp.left)!).offset(0)
            make.height.equalTo(50)
            make.width.equalTo(10)
        }
        
        toprightImage.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo((self.contentView.snp.right)).offset(0)
            make.height.equalTo(50)
            make.width.equalTo(10)
        }
        
        
        topMarkImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        
        nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(45)
            make.right.equalTo(-5)
            make.bottom.equalTo(0)
        }
        
        
        table.snp.makeConstraints {[weak topImage] (make) in
            make.top.equalTo((topImage?.snp.bottom)!).offset(5)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .left
        return lable
    }()
    
    lazy var topImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "analysisProblemCenter")
        return image
    }()
    
    lazy var topMarkImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "projectWenHao")
        return image
    }()
    
    
    lazy var topleftImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "analysisProblemLeft")
        return image
    }()
    
    lazy var toprightImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "analysisProblemRight")
        return image
    }()
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "projectSituationBack")
        return image
    }()
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model?.list != nil {
            return  (model?.list.count)!
        }
        return 0
//
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:projectSituationAndFlowCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! projectSituationAndFlowCell
        if model?.select != nil && model?.select?.index == model?.list[indexPath.row].index {
            cell.headImage.image = UIImage.init(named: "situationCellmarkSelect")
        }else{
            cell.headImage.image = UIImage.init(named: "situationCellmarkNomal")
        }
        cell.nameLable.text = model?.list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model?.select = model?.list[indexPath.row]
        tableView.reloadData()
        self.myclick()
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        
       table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        table.register(projectSituationAndFlowCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
