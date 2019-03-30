//
//  ThemeMessageCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/6/8.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
import SVProgressHUD
var myWidth = kScreenW - (10 + RCIM.shared().globalConversationPortraitSize.width + 10)*2

let extre = "你还:12313123k1kajs\ndajsdkajsddasdlajsdlk\n还行:kajskajsdkjsjdkajsdajdljasdkjasd"

class ThemeMessageCell: RCMessageCell {

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    var contentView: UIView?
    
    var topView = UIView.init()
    var bottomView = UIView.init()
    
    var contentLable = UILabel.init() //内容
    
    
    
    var headImage = UIImageView.init() //头像
    var lab1 = UILabel.init()
    var munImage = UIImageView.init()
    var numLable = UILabel.init()
    
    var lineView = UIView.init()
    var imageListView = UIView.init()
    var openBtn = UIButton.init(type: .custom)
    
    var extralable = UILabel.init()
    
    
    var joinBtn = UIButton.init(type: .custom)
    
    var didJoin = {
        (themeId:String) in
        DLog(themeId)
    }

    
    var backView = UIView.init()
    
    var openList:Array<String>?
    
    var didClickOpen = {
        (themeId:String) in
        DLog(themeId)
    
    }
    
    
    
//    //系统要求重写位置的方法
//    override class func size(for model: RCMessageModel!, withCollectionViewWidth: CGFloat, referenceExtraHeight: CGFloat) -> CGSize {
//        
//        
////        super.size(for: <#T##RCMessageModel!#>, withCollectionViewWidth: <#T##CGFloat#>, referenceExtraHeight: <#T##CGFloat#>)
//    
//    
//        
//        return CGSize.init(width:kScreenW, height: 100)
//    }
////
//    
    

    
    
    
    class func conFigSize(model:RCMessageModel,width:CGFloat,openList:Array<String>)->(CGSize){
        
        if kScreenW <= 320{
          myWidth = 200
        }
        
        let myModel = model.content as! ThemeMessageContent
        
        let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        
        let predicate = NSPredicate(format:"groupid == %@  AND is_delete == '0'",myModel.themeId)
        let r = ThemeInfoModel.objects(with: predicate)
        
        
        if openList.contains("\(model.messageId)") {
            
            var allHeight:CGFloat = 150;
            
            
            if r.count > 0 {
                let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
                
                allHeight +=  self.imageHeight(num: infoModel.imageNum, width: myWidth)
                DLog("图片 \(allHeight)")
                
            }
            
            
            allHeight += self.textHeight(model: myModel, width: bubbleBackgroundViewSize.width - 20)
            if allHeight < 200 {
                allHeight  = 200
            }
            
            allHeight += 30;
            
            if model.isDisplayMessageTime == true{
                 allHeight += 30
            }
            
            
            return CGSize.init(width: width, height: allHeight)
        }
        else{
            
            var extraHeight:CGFloat = 0
            if !myModel.extra.isEmpty {
                extraHeight = self.getTextHeight(textStr: myModel.extra, width: bubbleBackgroundViewSize.width - 20)
            }
            
            extraHeight += 30
            
            if model.isDisplayMessageTime == true{
                extraHeight += 30
            }
            
            var baseHeight:CGFloat = 90
            
            let textHeight  =  self.getTextHeight(textStr: myModel.content, width: bubbleBackgroundViewSize.width - 20)
            
            if textHeight < 63 {
                baseHeight += textHeight
            }
            else{
               baseHeight += 63
               baseHeight += 20
            
            }
            
//            DLog("高度--\(textHeight)")
            
            
            
            if r.count > 0 {
                let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
                
                if infoModel.imageNum.intValue > 0  || baseHeight <=  173{
                    baseHeight += 20
                }
                
            }

            
            return CGSize.init(width: width, height:baseHeight + extraHeight+20)
        }
        
        
    }
    
    
    class func imageHeight(num:NSNumber,width:CGFloat)->(CGFloat) {
        DLog(num)
        if num == 0 {
            return 0
        }
        let count = (Int(num)-1) / 3
        
      let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        
        return ((bubbleBackgroundViewSize.width-20)/3) * CGFloat(count + 1) + 5 * CGFloat(count+1)
    }
    
    class func textHeight(model:ThemeMessageContent,width:CGFloat)->(CGFloat) {
        
        if !model.extra.isEmpty {
          return self.getTextHeight(textStr: model.content, width: width) + self.getTextHeight(textStr: model.extra, width: width);
        }
        else{
          return self.getTextHeight(textStr: model.content, width: width)
        }
    }
    
    
    
    class func getTextHeight(textStr:String,width:CGFloat) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: 14)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = textLineSpace
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = textStr.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.height
    }

    
    
    
    
    
    //数据得到时的方法
    override func setDataModel(_ model: RCMessageModel!) {
//                DLog("hao_____\(cont)")
        for view in self.imageListView.subviews{
            view.removeFromSuperview()
        }
        DLog(model.objectName)
        
        super.setDataModel(model)
//        self.contentLable.text = cont.content
        
        
        DLog(myWidth)
        self.setAutoLayout()
        self.requestThemeInfo(model: model)
        
//        self.titleLabel.text = cont.title
    }
    
    class func getBubbleSize(textLabelSize:CGSize)->(CGSize){
    
        var bubbleSize = CGSize.init(width: textLabelSize.width, height: textLabelSize.height)
        if (bubbleSize.width + 12 + 20 > 50) {
            bubbleSize.width = bubbleSize.width + 12 + 20;
        } else {
            bubbleSize.width = 50;
        }
        if (bubbleSize.height + 7 + 7 > 40) {
            bubbleSize.height = bubbleSize.height + 7 + 7;
        } else {
            bubbleSize.height = 40;
        }
        
        return bubbleSize;
        
    }
    
    func setAutoLayout(){
        
        let cont = model.content as! ThemeMessageContent
        if kScreenW <= 320{
            myWidth = 200
        }
//        cont.extra = extre
        let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        var messageContentViewRect:CGRect = self.messageContentView.frame
        if model.isDisplayMessageTime == true {
//            messageContentViewRect.size.height -= 30
//           messageContentViewRect.size.width = myWidth
        }
        
//        messageContentView.frame = messageContentViewRect
        
        
        DLog(messageContentViewRect.size.height)
//        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        
        if .MessageDirection_RECEIVE == self.messageDirection {
        self.messageContentView.frame = CGRect(x: messageContentViewRect.origin.x, y: messageContentViewRect.origin.y, width: bubbleBackgroundViewSize.width, height: messageContentViewRect.size.height)
        }
        else{
//        self.messageContentView.frame = messageContentViewRect
            self.messageContentView.frame = CGRect(x: messageContentViewRect.origin.x-(bubbleBackgroundViewSize.width-messageContentViewRect.width), y: messageContentViewRect.origin.y, width: bubbleBackgroundViewSize.width, height: messageContentViewRect.size.height)
            
        }
        
        self.backView.frame = CGRect(x: 0, y: 0, width: self.messageContentView.frame.size.width, height: self.messageContentView.frame.size.height)
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width
        
        self.topView.frame = CGRect(x: 0, y: 0, width: messageContentViewRect.width, height: 30)
        
        
        var extraHeight:CGFloat = 0
        if !cont.extra.isEmpty {
            extraHeight = ThemeMessageCell.getTextHeight(textStr: cont.extra, width: bubbleBackgroundViewSize.width - 20)
        }
        
        
        
        
        self.contentLable.numberOfLines = 0
        self.contentLable.changeLineSpace(text: cont.content, space: textLineSpace)

        
        let conFrame = messageContentViewRect
        //一些子控件UI的调试
        

        let textHeight = ThemeMessageCell.getTextHeight(textStr: self.contentLable.text!, width: conFrame.size.width - 20)
        
        let predicate = NSPredicate(format:"groupid == %@  AND is_delete == '0'",cont.themeId)
        let r = ThemeInfoModel.objects(with: predicate)
        
        
        if textHeight < 63 {
            self.openBtn.isHidden = true
        }
        else{
            self.openBtn.isHidden = false
        }
        
        
        
        self.subviewsFrameConfig(conFrame: conFrame)

        
        if r.count > 0 {
            let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
            if infoModel.imageNum != 0 {
                self.openBtn.isHidden = false
            }
        }

        self.contentLable.frame = CGRect(x: 10, y: 30, width: conFrame.size.width-20, height: textHeight<63 ? textHeight:63)
        
        
        
        
        
        if openList != nil || openList?.count != 0 {
            //是否显示图片
            self.isShowImage(openList: openList!, cont: cont, conFrame: conFrame, textHeight: textHeight, r: r as! RLMResults<RLMObject>)
        }
        
        var bottomY:CGFloat = 0
        if self.imageListView.isHidden == false {
            bottomY =  self.imageListView.frame.origin.y + self.imageListView.frame.size.height
        }
        else{
           bottomY =  self.contentLable.frame.origin.y + self.contentLable.frame.size.height
        }
        
        
        self.bottomView.frame = CGRect(x: 0, y:bottomY, width: messageContentViewRect.width, height: 60 + extraHeight)
        
        
        if extraHeight > 0 {
            
            var extraY:CGFloat = 0
            if self.openBtn.isHidden == false {
                extraY = self.openBtn.frame.origin.y + self.openBtn.frame.size.height
            }
            
            self.extralable.frame = CGRect.init(x: 10, y: extraY+5, width: conFrame.size.width - 20, height: extraHeight)
            self.extralable.isHidden = false
            
            self.openBtn.frame = CGRect.init(x: -3, y: 10, width: 45, height: 30)
            self.extralable.changeLineSpace(text: cont.extra, space: textLineSpace)
            
            self.lineView.frame = CGRect.init(x: 5, y: self.extralable.frame.origin.y+extraHeight+5, width: conFrame.size.width - 10, height: 0.5)
            
            self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y:self.lineView.frame.origin.y+5, width: conFrame.size.width/2, height: 30)
            
            
            
            
        }else{
            self.extralable.isHidden = true
            if self.openBtn.isHidden == false {
                self.lineView.frame = CGRect.init(x: 5, y: self.openBtn.frame.origin.y+5+self.openBtn.frame.size.height, width: conFrame.size.width - 10, height: 0.5)
                
                self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y:self.lineView.frame.origin.y+5, width: conFrame.size.width/2, height: 30)
            }else{
            
            
                self.lineView.frame = CGRect.init(x: 5, y: 5, width: conFrame.size.width - 10, height: 0.5)
                
                self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y:self.lineView.frame.origin.y+5, width: conFrame.size.width/2, height: 30)
            
            
            
            }
            
            
            
            
        }
        
        self.backView.frame = CGRect(x: self.backView.frame.origin.x, y: self.backView.frame.origin.y, width: self.backView.frame.size.width, height: self.bottomView.frame.origin.y + self.joinBtn.frame.size.height + self.joinBtn.frame.origin.y+10)
       self.openBtn.titleLabel?.textAlignment = .left
       }
    
    
    
    func subviewsFrameConfig(conFrame:CGRect){
        
        self.headImage.frame = CGRect.init(x: 5, y: 5, width: 20, height: 20)
        self.headImage.backgroundColor = UIColor.hexString(hexString: "1782D2")
        
        
        self.lab1.frame = CGRect.init(x: 30, y: 5, width: conFrame.size.width/2-30, height: 20)
        self.munImage.frame = CGRect.init(x: 5 + conFrame.size.width-100, y: 5, width: 20, height: 20)
        self.numLable.frame = CGRect.init(x: 5 + conFrame.size.width-80, y: 10, width: 80, height: 10)
        self.numLable.textAlignment = .left
        self.openBtn.frame = CGRect.init(x: -3, y: 10, width: 60, height: 30)
        self.openBtn.setTitle("展开", for: .normal)
        self.lineView.frame = CGRect.init(x: 5, y:  self.bottomView.frame.size.height-36, width: conFrame.size.width - 10, height: 0.5)
        self.lineView.backgroundColor = UIColor.lightGray
        self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y:self.bottomView.frame.size.height-33, width: conFrame.size.width/2, height: 30)
        self.joinBtn.backgroundColor = UIColor.hexString(hexString: "1782D2")
        self.joinBtn.setTitle("进入话题", for: .normal)
    
    }
    
    
    //是否显示图片
    func isShowImage(openList:Array<String>,cont:ThemeMessageContent,conFrame:CGRect,textHeight:CGFloat,r:RLMResults<RLMObject>){
        if (openList.contains("\(model.messageId)")) {

            self.contentLable.frame = CGRect(x: 10, y: 30, width: conFrame.size.width-20, height:textHeight)
            
            self.openBtn.setTitle("收起", for: .normal)
            
           
            
            if r.count > 0 {
                 self.imageListView.isHidden = false
                let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
                let imageHeight = ThemeMessageCell.imageHeight(num: infoModel.imageNum, width: conFrame.size.height)
                
                self.imageListView.frame = CGRect(x: 0, y: 30+textHeight, width: conFrame.size.width, height: imageHeight)
                
                
                let anyArray = BaseRequest.makeJsonWithString(jsonStr: infoModel.imageArray)
                
                if let array:Array = anyArray as! Array<Any> {
                    
                    if array.count == 0{
                        return
                    }
                    
                    
                    for i in 0...array.count-1 {
                        let dic:Dictionary = array[i] as! Dictionary<String,String>
                        
                        let space:CGFloat = 5
                        let imageWidth:CGFloat = (conFrame.size.width-20)/3
                        let image = UIImageView.init(frame: CGRect(x: space + CGFloat(i%3) * imageWidth+CGFloat(i%3)*space, y:space + CGFloat(i/3) * imageWidth+CGFloat(i/3) * space, width: imageWidth, height: imageWidth))
                        self.imageListView.addSubview(image)
                        image.contentMode = .scaleAspectFill
                        image.clipsToBounds = true
                        image.sd_setImage(with: NSURL.init(string:(dic["thumb_url"])!)! as URL, placeholderImage: UIImage.init(named: "emoji"))
                        image.tag = i
                        let ges = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
                        ges.numberOfTapsRequired = 1
                        image.addGestureRecognizer(ges)
                        image.isUserInteractionEnabled = true
                    }
                    
                }
            }
        }
        else{
            self.openBtn.setTitle("展开", for: .normal)
            self.imageListView.isHidden = true
        }

    
    }
    
    
    
    
    @objc func tapped(_ tap:UITapGestureRecognizer){
        let image:UIImageView = tap.view as! UIImageView
        
        let photoBrowser = SDPhotoBrowser.init();
        photoBrowser.delegate = self as SDPhotoBrowserDelegate;
        photoBrowser.currentImageIndex = image.tag
        
        photoBrowser.imageCount = (self.imageListView.subviews.count);
        photoBrowser.sourceImagesContainerView = self.imageListView;
        
        photoBrowser.show()
        
    }

    
    /// 刷新话题信息
    ///
    /// - Parameter model: <#model description#>
    func requestThemeInfo(model:RCMessageModel){
    
        GroupRequest.getGroupSubjectInfo(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":(model.content as! ThemeMessageContent).themeId], hadToast: false, fail: { (dic) in
            
        }) { [weak self](dic) in
            DLog(dic)
            
            self?.headImage.sd_setImage(with: NSURL.init(string: dic["icon_url"] as! String) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            self?.numLable.text = dic["user_num"] as! String + "人参与"
            
            
            
            if (dic["titleFileList"] is Array<Dictionary<String, Any>>) {
                var urlArr : Array<Any>? = []
                for dict:Dictionary<String, Any> in (dic["titleFileList"] as! Array<Dictionary<String, Any>>){
                    urlArr?.append(dict)
                }
                //                            strongSelf.selectedUrls = urlArr
                //                            strongSelf.creatImageView()
            }
        }

    }
    
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
    
//        for view in self.imageListView.subviews{
//            view.removeFromSuperview()
//        }
//        
//        for view in self.messageContentView.subviews {
//            view.removeFromSuperview()
//            
//        }
        
        self.openList = nil
        self.initialize()
        
        
    }
    
    func initialize(){
        
//        self.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 200)
        
        
        
//        self.messageContentView.backgroundColor = UIColor.white
       
        //            self.messageContentView.eventBlock =
        
        self.backView.backgroundColor = UIColor.white
        self.backView.layer.cornerRadius = 5
        self.backView.layer.masksToBounds = true
        self.messageContentView.addSubview(self.backView)
        
        self.headImage.image = UIImage.init(named: "mine_avatar")
        //顶部内容
        self.topView.addSubview(self.headImage)
        self.topView.addSubview(self.lab1)
        self.lab1.text = "话题讨论"
        self.topView.addSubview(self.munImage)
        self.topView.addSubview(numLable)
        self.backView.addSubview(self.topView)
        
        
    self.backView.addSubview(self.contentLable)
    self.backView.addSubview(self.imageListView)
        
       
        self.bottomView.addSubview(self.openBtn)
        self.bottomView.addSubview(self.extralable)
        self.bottomView.addSubview(self.lineView)
        self.bottomView.addSubview(self.joinBtn)
        self.backView.addSubview(self.bottomView)
        
        
        
        
//        self.messageContentView.addSubview(self.headImage)
//        self.messageContentView.addSubview(self.lab1)
//        self.messageContentView.addSubview(self.contentLable)
//        
//        //            self.messageContentView.addSubview(self.imageView)
//        self.messageContentView.addSubview(self.munImage)
//        self.messageContentView.addSubview(self.numLable)
//        self.messageContentView.addSubview(self.lineView)
//        self.messageContentView.addSubview(self.imageListView)
//        self.messageContentView.addSubview(self.openBtn)
//        self.messageContentView.addSubview(self.joinBtn)
        
        let longPre = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressed(sender:)))
        self.backView.addGestureRecognizer(longPre)
        let sortPre = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(sender:)))
        self.backView.addGestureRecognizer(sortPre)
        
        DLog(self.messageContentView.frame.size.height)
        self.lab1.font = UIFont.systemFont(ofSize: 14)
        
        self.munImage.image = UIImage.init(named: "xljm5_Nomal")
        self.numLable.font = UIFont.systemFont(ofSize: 14)
        self.numLable.text = "0人参与"
        
        self.contentLable.font = UIFont.systemFont(ofSize: 14)
        self.extralable.font = UIFont.systemFont(ofSize: 14)
        self.contentLable.textColor = UIColor.darkGray
        self.extralable.textColor = UIColor.lightGray
        
        self.extralable.textAlignment = .left
        self.extralable.numberOfLines = 0
        self.extralable.lineBreakMode = .byCharWrapping
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        openBtn.titleLabel?.textAlignment = NSTextAlignment.left
        openBtn.setTitleColor(UIColor.hexString(hexString: "1782D2"), for: .normal)
        openBtn.addTarget(self, action: #selector(btnClickOpen(btn:)), for: .touchUpInside)
        
        
        joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        joinBtn.layer.cornerRadius = 5
        joinBtn.layer.masksToBounds = true
        joinBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        self.contentLable.numberOfLines = 0
        self.contentLable.lineBreakMode = .byCharWrapping
        
        
                    self.lab1.font = UIFont.systemFont(ofSize: 14)
        
                    self.munImage.image = UIImage.init(named: "xljm5_Nomal")
                    self.numLable.font = UIFont.systemFont(ofSize: 14)
                    self.numLable.text = "0人参与"
        
//        self.headImage.frame = CGRect.init(x: 5, y: 5, width: 20, height: 20)
//        self.lab1.frame = CGRect.init(x: 30, y: 10, width: conFrame.size.width/2-30, height: 10)
//        self.munImage.frame = CGRect.init(x: 5 + conFrame.size.width/2, y: 5, width: 20, height: 20)
//        self.numLable.frame = CGRect.init(x: 30 + conFrame.size.width/2, y: 10, width: conFrame.size.width/2-30, height: 10)
//        self.openBtn.frame = CGRect.init(x: conFrame.width - 50, y: conFrame.height - 70, width: 45, height: 15)
//
//        self.lineView.frame = CGRect.init(x: 5, y: conFrame.size.height - 50 , width: conFrame.size.width - 10, height: 1)
//        self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y: conFrame.size.height - 40, width: conFrame.size.width/2, height: 30)
    }
    
//                self.joinBtn.setTitle("进入话题", for: .normal)
    
    
    
    
//    //初始化的方法
//    override init!(frame: CGRect) {
//        DLog(frame)
//        super.init(frame: frame)
//        if self != nil {
////            self.messageContentView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 180)
//            
//            
//            
//
//            self.messageContentView.backgroundColor = UIColor.white
//            messageContentView.layer.cornerRadius = 5
//            messageContentView.layer.masksToBounds = true
////            self.messageContentView.eventBlock = 
//            DLog("跨度")
//            DLog(self.messageContentView.frame.size.width)
//            
//            self.messageContentView.addSubview(self.headImage)
//            self.messageContentView.addSubview(self.lab1)
//            self.messageContentView.addSubview(self.contentLable)
//           
////            self.messageContentView.addSubview(self.imageView)
//            self.messageContentView.addSubview(self.munImage)
//            self.messageContentView.addSubview(self.numLable)
//            self.messageContentView.addSubview(self.lineView)
//            self.messageContentView.addSubview(self.imageListView)
//            self.messageContentView.addSubview(self.openBtn)
//            self.messageContentView.addSubview(self.joinBtn)
//            
//            let longPre = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressed(sender:)))
//            self.messageContentView.addGestureRecognizer(longPre)
//            let sortPre = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(sender:)))
//            self.messageContentView.addGestureRecognizer(sortPre)
//            
//            
//            self.lab1.font = UIFont.systemFont(ofSize: 14)
//            
//            self.munImage.image = UIImage.init(named: "xljm5_Nomal")
//            self.numLable.font = UIFont.systemFont(ofSize: 14)
//            self.numLable.text = "0人参与"
//            
//            self.contentLable.font = UIFont.systemFont(ofSize: 15)
//            
//            
//            openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//            openBtn.titleLabel?.textAlignment = NSTextAlignment.right
//            openBtn.setTitleColor(UIColor.hexString(hexString: "1782D2"), for: .normal)
//            openBtn.addTarget(self, action: #selector(btnClickOpen(btn:)), for: .touchUpInside)
//            
//            
//            joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
//            joinBtn.layer.cornerRadius = 5
//            joinBtn.layer.masksToBounds = true
//            joinBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
//            
//            self.contentLable.numberOfLines = 0
////            self.contentLable.
//            //系统messageContentView的frame变动是的方法，conFrame是变动后的大小，不要在这里改变messageContentView的大小
////            self.messageContentView.registerFrameChangedEvent({ (conFrame) in
////                //头像
////                self.headImage.frame = CGRect.init(x: 5, y: 5, width: 20, height: 20)
////                self.headImage.backgroundColor = UIColor.hexString(hexString: "1782D2")
////                //话题讨论
////                self.lab1.frame = CGRect.init(x: 30, y: 10, width: conFrame.size.width/2-30, height: 10)
////                self.lab1.backgroundColor = UIColor.white
////                self.lab1.text = "话题讨论"
////                
////               
////                //人数图像
////                self.munImage.frame = CGRect.init(x: 5 + conFrame.size.width/2, y: 5, width: 20, height: 20)
//////                self.munImage.backgroundColor = UIColor.hexString(hexString: "1782D2")
////                //人数文字
////                self.numLable.frame = CGRect.init(x: 30 + conFrame.size.width/2, y: 10, width: conFrame.size.width/2-30, height: 10)
//////                self.numLable.backgroundColor = UIColor.white
//////                self.numLable.text = "话题讨论"
////                
////                if conFrame.height <= 200{
////                  
////                    
////                    self.imageListView.isHidden = true
////                //文字
////                self.contentLable.frame = CGRect.init(x: 10, y: 30, width: conFrame.size.width - 20, height: conFrame.size.height - 30 - 70 )
//////                self.contentLable.backgroundColor = UIColor.green
////                    self.openBtn.setTitle("展开", for: .normal)
////                }
////                else{
////                    
////                   
////                    self.imageListView.isHidden = false
////                   let myModel = self.model.content as! ThemeMessageContent
////                   self.contentLable.frame = CGRect.init(x: 10, y: 30, width: conFrame.size.width-20, height:ThemeMessageCell.getTextHeight(textStr: myModel.content, width: conFrame.size.width) )
////                    self.openBtn.setTitle("合起", for: .normal)
////                    
////                    
////                    
////                    
////                    
////                    let predicate = NSPredicate(format:"groupid == %@  AND is_delete == '0'",myModel.themeId)
////                    let r = ThemeInfoModel.objects(with: predicate)
////                    
////                    if r.count > 0 {
////                        let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
////                        let imageheiht = ThemeMessageCell.imageHeight(num: infoModel.imageNum, width: conFrame.size.width)
////                        self.imageListView.backgroundColor = UIColor.red
////                        self.imageListView.frame = CGRect(x: 0, y: conFrame.size.height - 100-imageheiht, width: conFrame.size.width, height: imageheiht)
////                        
////                    }
////
////                    
////                    
////                }
////                
////                self.openBtn.frame = CGRect.init(x: conFrame.width - 50, y: conFrame.height - 70, width: 45, height: 15)
////                
////                
////                self.lineView.frame = CGRect.init(x: 5, y: conFrame.size.height - 50 , width: conFrame.size.width - 10, height: 1)
////                self.lineView.backgroundColor = UIColor.gray
////                
////                self.joinBtn.frame = CGRect.init(x: conFrame.size.width/4, y: conFrame.size.height - 40, width: conFrame.size.width/2, height: 30)
////                self.joinBtn.setTitle("参与讨论", for: .normal)
////                self.joinBtn.backgroundColor = UIColor.hexString(hexString: "1782D2")
////            })
//            
//        }
//    }
    
    
    @objc func btnClickOpen(btn:UIButton){
        didClickOpen("\(model.messageId)")
    }
    @objc
    func btnClick(btn:UIButton){
        let predicate = NSPredicate(format:"userid == %@ AND groupid == %@  AND is_delete == '0'", sharePublicDataSingle.publicData.userid,(model.content as! ThemeMessageContent).themeId)
        let results = GroupUserModel.objects(with: predicate)
        if results.count == 0 {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setBackgroundColor(UIColor.darkGray)
            SVProgressHUD.setForegroundColor(UIColor.white)
            SVProgressHUD.show()

            GroupRequest.joinGroupSubject(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":(self.model.content as! ThemeMessageContent).themeId], hadToast: true, fail: { (error) in
                SVProgressHUD.dismiss()
            }, success: { (dic) in
                
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                
                if time == nil{
                    time = "0"
                }
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self](fail) in
                    if let strongSelf = self {
                        SVProgressHUD.dismiss()
                        strongSelf.didJoin((strongSelf.model.content as! ThemeMessageContent).themeId)
                        
                    }
                }, success: {[weak self] (dic) in
                    if let strongSelf = self {
                        SVProgressHUD.dismiss()
                        strongSelf.didJoin((strongSelf.model.content as! ThemeMessageContent).themeId)
                        
                    }
                    }
                )
                
            })
        }else{
            didJoin((model.content as! ThemeMessageContent).themeId)
        }
        
    }
    
    @objc func longPressed(sender:UILongPressGestureRecognizer) -> () {
        if sender.state == .ended {
            return
        }else if sender.state == .began {
            self.delegate.didLongTouchMessageCell!(self.model, in: self)
        }
    }
    @objc func singleTap(sender:UITapGestureRecognizer) -> () {
        self.delegate.didTapMessageCell!(self.model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 图片浏览器代理
extension ThemeMessageCell:SDPhotoBrowserDelegate{
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
        let imageView:UIImageView = imageListView.subviews[index] as! UIImageView
        return imageView.image
        
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        let cont = model.content as! ThemeMessageContent
        let predicate = NSPredicate(format:"groupid == %@  AND is_delete == '0'",cont.themeId)
        let r = ThemeInfoModel.objects(with: predicate)
        guard r.count>0 else {
            return NSURL.init(string: "")! as URL
        }
        let infoModel:ThemeInfoModel = r.firstObject() as! ThemeInfoModel
        let anyArray = BaseRequest.makeJsonWithString(jsonStr: infoModel.imageArray)
        if let array:Array = anyArray as! Array<Any> {
            let dic:Dictionary = array[index] as! Dictionary<String,String>
            let str = dic["url"]
            return NSURL.init(string: str!)! as URL
        }
        return NSURL.init(string: "")! as URL
    }
    
}

