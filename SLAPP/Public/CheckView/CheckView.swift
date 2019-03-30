//
//  CheckView.swift
//  SLAPP
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

public enum Style : Int {
    case single
    case multiple
}

class CheckView: UIView,UITableViewDelegate,UITableViewDataSource{

    
    var isCloseStatus:Bool = false
    
    private var dataArray = Array<String>()
    private var selectIndexPath = IndexPath.init(row: 0, section: 0)
  @objc  var selecArray = Array<String>()
    var style:Style?
    
 @objc   var click:(_ name:String,_ Index:IndexPath)->() = {_,_ in
        
    }
    
    func refresh(){
        self.table.reloadData()
    }
    
@objc  static  func configWithTitles(titles:Array<String>)->(CheckView){
    
    DLog(titles.count)
      let view = CheckView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT))
        UIApplication.shared.keyWindow?.addSubview(view)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.dataArray = titles
        view.configUI()
        return view
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        
        var height:CGFloat = 80.0
        for str in self.dataArray{
            let myheight = UILabel.getHeightWith(str: str, font: 14,width: MAIN_SCREEN_WIDTH-130)
            if myheight > 44 {
                height += myheight
            }else{
                height += 44
            }
        }
        DLog(height)
        DLog(MAIN_SCREEN_HEIGHT - 150)
        let backView = UIView.init(frame: CGRect(x: 30, y: 0, width: MAIN_SCREEN_WIDTH-60, height: height > MAIN_SCREEN_HEIGHT - 150 ?  MAIN_SCREEN_HEIGHT-150 : height))
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        backView.center = self.center
        backView.addSubview(nameLable)
        nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(30)
        }
        nameLable.font = UIFont.systemFont(ofSize: 15)
        nameLable.text = "请选择"
        nameLable.textColor = kGreenColor
        
        backView.addSubview(cancelBtn)
        backView.addSubview(sureBtn)
        cancelBtn.snp.makeConstraints {[weak sureBtn] (make) in
            make.width.equalTo(50)
            make.right.equalTo((sureBtn?.snp.left)!).offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(0)
        }
        
        sureBtn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.bottom.equalTo(0)
        }

        backView.addSubview(table)
        if height >= MAIN_SCREEN_HEIGHT-150 {
            table.isScrollEnabled = true
        }else{
            table.isScrollEnabled = false
        }
        
        table.snp.makeConstraints {[weak nameLable,weak cancelBtn] (make) in
            
            make.top.equalTo((nameLable?.snp.bottom)!).offset(0)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo((cancelBtn?.snp.top)!).offset(0)
        }
        
        
        table.delegate = self
        table.dataSource = self
        
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        sureBtn.addTarget(self, action: #selector(sure), for: .touchUpInside)
    }
    
    
    @objc func cancel(){
        self.removeFromSuperview()
    }
    
    @objc func sure(){
        
        if selecArray.count == 0 {
            PublicMethod.toastWithText(toastText: "请最少选择一个选项")
            return
        }
        
        if self.dataArray.count>0 {
            if self.style != .multiple {
                
                if self.isCloseStatus == true {
                     //关单临时改动处理
                    let index = self.dataArray.index(of: selecArray.first!)
                   
                    self.click(selecArray.first!,IndexPath.init(row: index!, section: 0))
                }
               
                
                
                
//
            }else{
                if selecArray.count > 1 {
                    self.click(selecArray.joined(separator: ","),IndexPath.init(row: 0, section: 0))
                }else{
                    self.click(selecArray.first!,IndexPath.init(row: 0, section: 0))
                }
            }
        }
        self.removeFromSuperview()
    }
    
    lazy var cancelBtn = { () -> UIButton in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(kGreenColor, for: .normal)
        return btn
    }()
    
    lazy var sureBtn = { () -> UIButton in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(kGreenColor, for: .normal)
        return btn
    }()
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 18)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = UILabel.getHeightWith(str: dataArray[indexPath.row], font: 14,width: MAIN_SCREEN_WIDTH-130)
        return height > 44 ? height : 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:CheckViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? CheckViewCell
        if cell == nil {
            cell = CheckViewCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.nameLable.text = self.dataArray[indexPath.row]
        if self.selecArray.contains((cell?.nameLable.text!)!) {
            if self.style == .multiple{
                cell?.headImage.image = UIImage.init(named: "dxSelect")
            }else{
                cell?.headImage.image = UIImage.init(named: "situationCellmarkSelect")
            }
            
        }else{
            if self.style != .multiple{
                cell?.headImage.image = UIImage.init(named: "logic_normal")
            }else{
                cell?.headImage.image = UIImage.init(named: "dxNormal")
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let str = self.dataArray[indexPath.row]
        if selecArray.contains(str)  {
            if self.style == .multiple {
                selecArray.remove(at: selecArray.index(of: str)!)
            }
            
        }else{
            if self.style != .multiple {
                selecArray.removeAll()
            }
            selecArray.append(str)
        }
        
        tableView.reloadData()
        if self.style != .multiple  && self.isCloseStatus != true {
            
            self.click(selecArray.first!,indexPath)
            self.removeFromSuperview()
        }
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        table.separatorStyle = .none
        return table
    }()

}
