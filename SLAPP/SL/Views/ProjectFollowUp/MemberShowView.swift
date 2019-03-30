//
//  MemberShowView.swift
//  SLAPP
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MemberShowView: UIView {
    
    var cluesMark:String?
    
    
     let btn = UIButton()
    var dataArray = Array<MemberModel>()
    var projectView:MemberProjectView?
    func getIds()->([String]){
        return dataArray.map({ (m) -> String in
            return m.id!
        })
    }
    
    func getNames()->([String]){
        return dataArray.map({ (m) -> String in
            return m.name ?? ""
        })
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    
    
    /// 选择了项目调用
    ///
    /// - Parameter model: <#model description#>
    func configProjectWithModel(model:QFFollowUpProjectModel){
        
        btn.isHidden = true
        if projectView == nil {
            projectView = MemberProjectView()
            projectView?.btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            backView.addSubview(projectView!)
            projectView?.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalTo(0)
            }
        }
        
        projectView?.name.text = model.name
        
    }
    
    
    
    func configWithArray(array:Array<MemberModel>)->(CGFloat){
        dataArray = array
        for view in backView.subviews {
            view.removeFromSuperview()
        }
       
        var width = backView.frame.size.width/5.0
        if width == 0 {
            width = (MAIN_SCREEN_WIDTH - 120 )/5.0
        }
        let height:CGFloat = array.count <= 5 ? 50:30.0
        
        if array.count > 0 {
            for i in 0...array.count-1 {
                let u = MemberView.init(frame: CGRect(x: 0+width*CGFloat(i%5), y: 0+height*CGFloat(i/5), width: width, height: height))
                u.model = array[i]
                backView.addSubview(u)
                
                
            }
        }
        
        
        
        
        
        return height * CGFloat((array.count-1)/5 + 1)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var btnClick:()->() = {
        
    }
    
    var proDeleteClick:()->(Bool) = {
        return true
    }
    
    var tagsString : String? {
        didSet {
            self.tagsLable.text = tagsString
        }
    }
    
    func configUI(){
        
        
        
        
        self.addSubview(headImage)
        self.addSubview(nameLable)
        self.addSubview(markImage)
        self.addSubview(tagsLable)
        self.addSubview(backView)
        self.addSubview(remindImage)
//        backView.backgroundColor = UIColor.gray
        
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        nameLable.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(3)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(15)
        }
        
        markImage.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        tagsLable.snp.makeConstraints { (make) in
            make.right.equalTo(remindImage.snp.right).offset(-5)
            make.left.equalTo(nameLable.snp.right)
            make.centerY.equalToSuperview()
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(nameLable.snp.right)
            make.right.equalTo(markImage.snp.left).offset(-10)
//            make.height.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        remindImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(8)
            make.right.equalTo(markImage.snp.left).offset(-1)
        }
        
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = HexColor("#F2F2F2")
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.3)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
       
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    @objc func click(){
        self.btnClick()
    }
    
    @objc func deleteClick(){
        if (self.proDeleteClick()){
            projectView?.removeFromSuperview()
            projectView = nil
            btn.isHidden = false
        }
       
    }
    
    lazy var backView = { () -> UIView in
        let lable = UIView()
        return lable
    }()
    
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        return lable
    }()
    
    lazy var tagsLable = { () -> UILabel in
        let lable = UILabel()
        lable.textAlignment = NSTextAlignment.right
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        lable.textColor = UIColor(hexString: "45BB60")
        return lable
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
//        image.backgroundColor = UIColor.red
        return image
    }()
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "theme_rightArrow")
//        image.backgroundColor = UIColor.green
        return image
    }()
    
    lazy var remindImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "*")
        
        //        image.backgroundColor = UIColor.green
        return image
    }()
    
}



class MemberProjectView: UIView {
    
    var name:UILabel = UILabel()
    var btn:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 14)
        name.textColor = UIColor.lightGray
        self.addSubview(name)
        self.addSubview(btn)
        
        name.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(-50)
        }
        btn.setImage(UIImage.init(named: "menuClose"), for: .normal)
        btn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class MemberView: UIView {
    
    
    var model:MemberModel?{
        didSet{
           
            if model?.head == "" {
                nameLable.isHidden = false
                nameLable.text = String((model?.name?.prefix(1))!)
               // headImage.backgroundColor = kGreenColor
            }else{
                nameLable.isHidden = true
                headImage.setImageWith(url: (model?.head)!, imageName: "mine_avatar")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headImage)
        let width = 20
        headImage.snp.makeConstraints { (make) in
           make.width.height.equalTo(width)
           make.center.equalToSuperview()
        }
        
        self.addSubview(nameLable)
        nameLable.textAlignment = .center
        nameLable.textColor = UIColor.white
        nameLable.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
}
