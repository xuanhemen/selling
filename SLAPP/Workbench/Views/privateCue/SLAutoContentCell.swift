//
//  SLAutoContentCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/9.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLAutoContentCell: UITableViewCell {
    
    /**数据源*/
    var model = SLFollowUpModel()
    /**头像*/
    lazy var headImageView = UIImageView.init()
    /**发布人*/
    lazy var releaseName = UILabel()
    /**内容*/
    lazy var content = UILabel()
    /**图片数据源*/
    var imageArr = [SLFlollowUpFileModel]()
    /**客户联系人*/
    lazy var contact = UILabel()
    /**跟进人*/
    lazy var followUpPerson = UILabel()
    /**承载图片背景*/
    lazy var imageBgView = UIView()
    /**承载标签背景*/
    lazy var markView = UIView()
    /**发布时间*/
    lazy var time = UILabel()
    /**点赞评论视图*/
    var popView = SLAutoPopView.init()
    /**中间变量*/
    var selectView: SLAutoPopView?
    var seleId:String = ""
    
    /**点赞回调*/
    typealias Notice = () -> Void
    var fresh: Notice?
    /**评论回调*/
    typealias Comment = () -> Void
    var comment: Comment?
    /**通知tablview弹出popivew*/
    typealias PopTheView = (SLSpecialBtn,String) -> Void
    var pop: PopTheView?
    
    var idStr:String = ""
    
    var buttonTitle:String?
    /**删除跟踪记录*/
    typealias DeleteFollowUp = (Int) -> Void
    var delete: DeleteFollowUp?
    
    var sec: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
    }
    func setCell(model:SLFollowUpModel,section: Int) {
        //标识点击图片是属于哪个section
        self.sec = section
        self.imageArr = model.filesArr
        self.model = model
        headImageView.sd_setImage(with: NSURL.init(string:model.head! + imageSuffix)! as URL, placeholderImage: UIImage.init(named: "login_avatar"))
        self.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        releaseName.text = model.createname
        self.addSubview(releaseName)
        releaseName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(headImageView.snp.right).offset(10)
        }
        
        content.text = String.base64Decode(str: model.encode_note!)
        content.numberOfLines = 0
        self.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.equalTo(releaseName.snp.bottom).offset(10)
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            
        }
        /**图片宽、高,根据imageBgView得来*/
        let width = (SCREEN_WIDTH-100-20)/3
        let rows:CGFloat = ceil(CGFloat(imageArr.count)/3)
        imageBgView.backgroundColor = .white
        self.addSubview(imageBgView)
        imageBgView.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(rows*width+(rows+1)*10)
        }
        /**开始添加图片*/
        let row:Int = Int(rows)
        for index in 0..<row {
            for ind in 0..<3 {
                let count = 3*index+ind
                let redView = UIImageView.init()
                if count >= imageArr.count {
                    redView.backgroundColor = .clear
                    redView.isUserInteractionEnabled = false
                }else{
                    //redView.backgroundColor = .red
                    redView.isUserInteractionEnabled = true
                    redView.tag = count
                    let ges = UITapGestureRecognizer.init()
                    ges.addTarget(self, action: #selector(imageClick))
                    redView.addGestureRecognizer(ges)
                    let model = imageArr[count]
                    let url = URL.init(string: model.preview_url_small ?? "")
                    redView.sd_setImage(with: url, completed: nil)
                }
                
                redView.frame = CGRect(x: (width+10)*CGFloat(ind), y: 10+(width+10)*CGFloat(index),width:width ,height:width)
                imageBgView.addSubview(redView)
            }
            
            
        }
        
        contact.text = model.contactnames
        contact.font = FONT_14
        contact.numberOfLines = 0
        //contact.backgroundColor = UIColor.green
        self.addSubview(contact)
        contact.snp.makeConstraints { (make) in
            make.top.equalTo(imageBgView.snp.bottom).offset(10)
            make.left.equalTo(content)
        }
        followUpPerson.text = model.realname
        followUpPerson.font = FONT_14
        // followUpPerson.backgroundColor = UIColor.green
        self.addSubview(followUpPerson)
        followUpPerson.snp.makeConstraints { (make) in
            if contact.text==""{
                make.top.equalTo(imageBgView.snp.bottom).offset(10)
            }else{
                make.top.equalTo(contact.snp.bottom).offset(10)
            }
            make.left.equalTo(contact)
        }
        /**标签*/
        let markWidth = (SCREEN_WIDTH-100-30)/4
        let markRow = ceil(CGFloat(model.class_list?.count ?? 0)/4)
        markView.backgroundColor = .white
        self.addSubview(markView)
        markView.snp.makeConstraints { (make) in
            if contact.text == "" && followUpPerson.text == ""{
                make.top.equalTo(imageBgView.snp.bottom).offset(10)
            }else if contact.text == "" && followUpPerson.text != "" {
                make.top.equalTo(followUpPerson.snp.bottom).offset(10)
            }else if contact.text != "" && followUpPerson.text == "" {
                make.top.equalTo(contact.snp.bottom).offset(10)
            }
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            if model.class_list?.count == 0 {
                make.height.equalTo(0)
            }else{
                make.height.equalTo(30*markRow+(markRow+1)*5)
            }
            
        }
        let markRows = Int(markRow)
        for index in 0..<markRows {
            for ind in 0..<4 {
                let count = 4*index+ind
                let mark = UILabel.init()
                mark.font = FONT_14
                mark.textAlignment = NSTextAlignment.center
                mark.layer.masksToBounds = true
                mark.layer.cornerRadius = 6
                if count >= model.class_list?.count ?? 0 {
                    mark.backgroundColor = .white
                }else{
                    mark.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
                    let model = model.class_list![count]
                    mark.text = model.name
                }
                mark.frame = CGRect(x: (markWidth+10)*CGFloat(ind), y: (30+5)*CGFloat(index),width:markWidth ,height:30)
                markView.addSubview(mark)
            }
            
            
        }
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(Int(model.addtime!)!)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM月dd日 HH:mm" //自定义日期格式
        let timeStr = dateformatter.string(from: date as Date)
        time.text = timeStr
        time.textColor = kTitleColor
        time.backgroundColor = .white
        time.font = FONT_14
        self.addSubview(time)
        time.snp.makeConstraints { (make) in
            make.top.equalTo(markView.snp.bottom).offset(10)
            make.left.equalTo(markView)
            make.bottom.equalToSuperview().offset(-10)
        }
        for index in 0..<3 {
            let btn = SLSpecialBtn.init(type: UIButtonType.custom)
            if index==0 {
                btn.setImage(UIImage.init(named: "AlbumOperateMore"), for: UIControlState.normal)
            }else if index==1{
                btn.setTitle("删除", for: UIControlState.normal)
                btn.setTitleColor(kTitleColor, for: UIControlState.normal)
            }else{
                btn.setTitle("修改", for: UIControlState.normal)
                btn.setTitleColor(RGBA(R: 37, G: 171, B: 96, A: 1), for: UIControlState.normal)
            }
            btn.titleLabel?.font = FONT_14
            btn.tag = index
            btn.selectID = model.id
            btn.section = section
            btn.addTarget(self, action: #selector(operation), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerY.equalTo(time)
                make.right.equalToSuperview().offset(-(20+40*index))
            }
        }
        
        for objc in self.model.support! {
            self.idStr = self.idStr.appendingFormat(",%@", objc.userid!)
        }
        let userModel = UserModel.getUserModel()
        if self.idStr.contains(userModel.id!) {
            buttonTitle = "取消"
        } else {
            buttonTitle = "赞"
        }
        
    }
    //MARK: - 点击图片查看大图
    @objc func imageClick(ges: UITapGestureRecognizer) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("imgCliked"), object: nil, userInfo: ["whichOne" : ges.view?.tag ?? 0,"sec":self.sec ?? 0])
    }
    //MARK: - 修改、删除、弹出
    @objc func operation(btn:SLSpecialBtn) {
        
        if btn.tag==0 {
            self.pop!(btn,buttonTitle!)
        }else if btn.tag == 1 {
            print("删除")
            /**参数*/
            self.showProgress(withStr: "正在加载中...")
            var parameters = [String:String]()
            parameters["id"] = btn.selectID
            LoginRequest.getPost(methodName: "pp.followup.followup_del", params: parameters.addToken(), hadToast: true, fail: { (error) in
                print(error)
                
            }) { (dataDic) in
                self.showDismiss()
                self.delete!(btn.section!)
                
                
                
            }
        }else if btn.tag == 2 {
            NotificationCenter.default.post(name: NSNotification.Name("edit"), object: nil, userInfo: ["section":btn.section ?? 0])
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

