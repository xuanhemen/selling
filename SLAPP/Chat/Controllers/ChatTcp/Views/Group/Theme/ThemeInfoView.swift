//
//  ThemeInfoView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/6/27.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Foundation
let space:CGFloat = 20.0
let defaultHeight:CGFloat = 40

class ThemeInfoView: UIView {
    
    var themeLable:UILabel?
    var imagesView:UIView?
    var isOpen:Bool?
    var btn : UIButton?
    var backScroll:UIScrollView?
    
    var openUrl:(_ url:String)->() = {_ in 
        
    }
    //展开的回调
    var openBtnClick:()->() = {
        
    }
    
    
    
    var themeName:String?
    var imageArray:Array<Dictionary<String, String>>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: frame.size.height))
        backScroll?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        addSubview(backScroll!)
        isOpen = false;
       
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(mytapped(_:)))
        ges.numberOfTapsRequired = 1
        self.addGestureRecognizer(ges)

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    /// 创建显示lable  等初始化拿到要显示的数据后在调用
    func configUI(){
        themeLable = UILabel.init(frame: CGRect(x: space, y: 5, width: kScreenW-2*space, height: 30))
        themeLable?.numberOfLines = 1;
        themeLable?.textAlignment = .left
        themeLable?.textColor = UIColor.white
        themeLable?.font = UIFont.systemFont(ofSize: 15)
        themeLable?.lineBreakMode = .byTruncatingTail
        themeLable?.text = String.init(format: "[话题]%@", themeName!)
        
        themeLable?.enabledTapEffect = true

//
        self.backScroll?.addSubview(themeLable!)
        
        if  self.configHeight(text: themeName!) > 40 ||  (self.imageArray?.count)!>0  {
            btn = UIButton.init(type: .custom)
            
            btn?.frame = CGRect(x: kScreenW-35 - 90, y:5, width: 30, height: 30)
            btn?.setImage(UIImage.init(named: "down"), for: .normal)
            btn?.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            self.backScroll?.addSubview(btn!)
        }
        
       
        
    }
    
    
    
    /// 收缩按钮点击响应
    @objc func btnClick(){
        
        isOpen = !isOpen!
        if isOpen == true {
            self.openBtnClick()

            self.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: kScreenH-NAV_HEIGHT)
            
            themeLable?.frame =  CGRect(x: space, y: 5, width: kScreenW-2*space , height: self.getTextHeigh(textStr: (themeLable?.text)!
                ))
            themeLable?.numberOfLines = 0
            themeLable?.enabledTapEffect = true
            
//            let rex = "^(?=^.{3,255}$)(http(s)?://)?(www.)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:d+)*(/w+.w+)*([?&]w+=w*)*$"
            let rex = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
            
            let reguE = try? NSRegularExpression.init(pattern: rex, options: .caseInsensitive)
            DLog(reguE)
            DLog(themeLable?.text)
            let stringChecks = reguE?.matches(in: (themeLable?.text)!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (themeLable?.text as! NSString).length))
            var strings = Array<String>()
            
            for textChe in stringChecks! {
                strings.append((themeLable?.text?.substring(with: (themeLable?.text?.changeToRange(from: textChe.range))!))!)
            }
//            themeLable?.yb_addAttributeTapAction(strings, tapAction: { (str, ran, intValue) in
//                DLog(str)
////                let webView = UIWebView.init(frame: self.frame)
////                let wbc = BaseViewController.init()
//////                wbc.title = (model.content as! HistoryMessageContent).title
////                wbc.view = webView
////                webView.loadRequest(URLRequest.init(url: URL.init(string: str)!))
//                self.openUrl(str)
////                self.navigationController?.pushViewController(wbc, animated: true)
//            })
            
            btn?.setImage(UIImage.init(named: "up"), for: .normal)
            if imagesView == nil {
                self.addImages()
            }
            else{
               imagesView?.isHidden = false
            }
        }
        else{
            
            self.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: defaultHeight)
            if imagesView != nil {
                imagesView?.isHidden = true
            }
            themeLable?.frame = CGRect(x: space, y: 5, width: kScreenW-2*space-20 - 90, height: 30)
            btn?.setImage(UIImage.init(named: "down"), for: .normal)
            themeLable?.numberOfLines = 1;
//            isTapEffect = false
        }
        let size: CGRect = self.getSize(isScroll: false)
        self.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: size.height)
        self.backScroll?.frame = CGRect.init(x: 0, y: 0, width: kScreenW - 90, height:size.size.height);
        if self.frame.size.height >= kScreenH-NAV_HEIGHT {
            self.backScroll?.contentSize = CGSize(width: 0, height: self.getSize(isScroll: true).height)
            btn?.frame = CGRect(x: kScreenW-35 - 90, y:(self.backScroll?.contentSize.height)!-30, width: 30, height: 30)
        }
        else{
           self.backScroll?.contentSize = CGSize(width: 0, height: 0)
            
            if isOpen == true{
                btn?.frame = CGRect(x: kScreenW-35 - 90, y:self.frame.size.height-30, width: 30, height: 30)
            }else{
                btn?.frame = CGRect(x: kScreenW-35 - 90, y:5, width: 30, height: 30)
            }
        }
    }
    
    
    
    /// 返回当前应该显示的size
    ///
    /// - Parameter isScroll: 是否计算的是Scroll
    /// - Returns: 返回对应的size
    func getSize(isScroll:Bool)->(CGRect){
    
        if isOpen! == true {
            
            var textHeight = self.getTextHeigh(textStr: (themeLable?.text)!)
            if textHeight < 40 {
                textHeight = 40
            }
            let imageHeight = self.getImageHeight()
            
            
            if isScroll == true {

                var height = textHeight+imageHeight
                if height < defaultHeight {
                    height = defaultHeight
                }

                return CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: height);
            }
            else{
                
                var height = (textHeight+imageHeight > kScreenH-NAV_HEIGHT) ?kScreenH-NAV_HEIGHT:textHeight+imageHeight
                if height < defaultHeight {
                    height = defaultHeight
                }
                return CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: height);
                
            }
        }
        else{
            return CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height:40);
        }
        
    }
    
    
    
        func configHeight(text:String)->CGFloat {
    
        if text.isEmpty {
            return 40
        }
        let font = UIFont.systemFont(ofSize: 15)
            let attributes = [NSAttributedStringKey.font: font]
        
        var size = CGRect()
        
        let labelSize = CGSize.init(width: kScreenW-2*space-10, height: CGFloat(MAXFLOAT))
        
        
        size = text.boundingRect(with: labelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context: nil);
        DLog( size.height)
        return (size.height < 20.0) ? 40 : 70
        
    }
    
    
    /// 计算文本高度
    ///
    /// - Parameter textStr: 要计算的文本
    /// - Returns: 返回高度
    func getTextHeigh(textStr:String) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: 15)
        let attributes = [NSAttributedStringKey.font: font]
        
        var size = CGRect()
    
        var spaceOpen:CGFloat = 0;
        if isOpen == false{
           spaceOpen = -10
        }
        let labelSize = CGSize.init(width: kScreenW-2*space+spaceOpen , height: CGFloat(MAXFLOAT))
    
       
        size = textStr.boundingRect(with: labelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context: nil);
        
        return (size.height<20) ?  40 : size.height
    }
    
    
    
    /// 计算图片显示区域的高度
    ///
    /// - Returns: 返回高度
    func getImageHeight()->(CGFloat){
    
        if imageArray?.count == 0 {
            return 30
        }
        if imageArray?.count != 0 {
            let imageWidth:CGFloat = (kScreenW-4*space)/3
            return (space + imageWidth) * CGFloat((((imageArray?.count)!)-1)/3+1) + space + 50
            
        }
        
        return 0
    }
    
    
    
    
    /// 添加图片显示区域
    func addImages(){
        
        if imageArray?.count == 0 {
            return
        }
        imagesView = UIView.init(frame: CGRect(x: 0, y:self.getTextHeigh(textStr: (themeLable?.text)!), width: kScreenW, height:self.getImageHeight()-30))
        self.backScroll?.addSubview(imagesView!)
        let imageWidth:CGFloat = (kScreenW-4*space)/3
        
        
        for i in 0...(imageArray?.count)!-1{
         
            let image = UIImageView.init(frame: CGRect(x: space+CGFloat(i%3) * imageWidth+CGFloat(i%3)*space, y:space + CGFloat(i/3) * imageWidth+CGFloat(i/3) * space, width: imageWidth, height: imageWidth))
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            imagesView?.addSubview(image)
            let dic = imageArray?[i]
            image.sd_setImage(with: NSURL.init(string:(dic?["thumb_url"])!)! as URL, placeholderImage: UIImage.init(named: "emoji"))
            image.tag = i
            let ges = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
            ges.numberOfTapsRequired = 1
            image.addGestureRecognizer(ges)
            image.isUserInteractionEnabled = true
        }
    
    }
    
    
    /// 图片点击响应
    ///
    /// - Parameter tap: <#tap description#>
    @objc func tapped(_ tap:UITapGestureRecognizer){
        let image:UIImageView = tap.view as! UIImageView
        
        let photoBrowser = SDPhotoBrowser.init();
        photoBrowser.delegate = self as SDPhotoBrowserDelegate;
        photoBrowser.currentImageIndex = image.tag
        photoBrowser.imageCount = (imageArray?.count)!;
        photoBrowser.sourceImagesContainerView = imagesView;
        
        photoBrowser.show()
    
    }
    
    
    
    /// 遮罩点击响应
    ///
    /// - Parameter tap: <#tap description#>
    @objc func mytapped(_ tap:UITapGestureRecognizer){
//        if self.isOpen == true {
//            self.btnClick()
//        }
        
    }
}




// MARK: - 图片浏览器代理
extension ThemeInfoView:SDPhotoBrowserDelegate{
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
        let imageView:UIImageView = imagesView?.subviews[index] as! UIImageView
        return imageView.image
        
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        let dic = imageArray?[index]
        let str = dic?["url"]
        return NSURL.init(string: str!)! as URL
    }

}
