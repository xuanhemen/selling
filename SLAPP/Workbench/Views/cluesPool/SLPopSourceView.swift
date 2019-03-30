//
//  SLPopSourceView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

/**点击确定按钮回调给控制器*/
protocol PassSource {
    func passSourceIDAndName(id: String,name: String)
}
class SLPopSourceView: UIView,UITableViewDelegate,UITableViewDataSource {
   
    /**数据源*/
    var dataArr:[SLSourceModel] = []
    /**中间变量模型*/
    var seletedModel:SLSourceModel?
    
    var delegate:PassSource? = nil
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: SCREEN_HEIGHT-NAV_HEIGHT, width: SCREEN_WIDTH, height: 300)
        let topLayer = CALayer()
        topLayer.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        topLayer.frame = CGRect(x: 0, y: 0.3, width: SCREEN_WIDTH, height: 0.3)
        self.layer.addSublayer(topLayer)
        let layer = CALayer()
        layer.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        layer.frame = CGRect(x: 0, y: 49, width: SCREEN_WIDTH, height: 0.3)
        self.layer.addSublayer(layer)
        self.backgroundColor = .white
        let cancel = UIButton.init(type: UIButtonType.custom)
        cancel.setTitle("取消", for: UIControlState.normal)
        cancel.setTitleColor(RGBA(R: 47, G: 85, B: 199, A: 1), for: UIControlState.normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancel.addTarget(self, action: #selector(cancelClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancel)
        cancel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
        })
        let sure = UIButton.init(type: UIButtonType.custom)
        sure.setTitle("确定", for: UIControlState.normal)
        sure.setTitleColor(RGBA(R: 47, G: 85, B: 199, A: 1), for: UIControlState.normal)
        sure.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sure.addTarget(self, action: #selector(sureClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(sure)
        sure.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-15)
        })
        self.tableView.reloadData()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = RGBA(R: 233, G: 233, B: 233, A: 1)
        tableView.register(SLSourceTableViewCell.self, forCellReuseIdentifier: "source")
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-SAFE_HEIGHT)
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "source") as! SLSourceTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let model = self.dataArr[indexPath.row]
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
        let model = self.dataArr[indexPath.row]
        if model != self.seletedModel{
             model.select = true
             self.seletedModel?.select = false
             self.seletedModel = model
        }
       
        self.tableView.reloadData()
    }
     /**点击取消*/
    @objc func cancelClick() {
        self.seletedModel?.select = false
        UIView.animate(withDuration: 1) {
            self.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.top.equalTo((self.superview?.snp.bottom)!)
            })
            
        }
        self.removeFromSuperview()
    }
    /**点击确定*/
    @objc func sureClicked(){
        let id = self.seletedModel?.id
        if id==nil || id=="" {
            return
        }
        self.cancelClick()
        self.delegate?.passSourceIDAndName(id: (self.seletedModel?.id)!, name: (self.seletedModel?.name)!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
