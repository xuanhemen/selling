//
//  ThemeCreatVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/14.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
private let textView_height : CGFloat = 150.0
fileprivate let maxTextLength = 1000
class ThemeCreatVC: BaseViewController {

    var textView : UITextView?
    var placeholderLabel : UILabel?
    var imageBgView : UIScrollView?
    var selectedAssets : Array<Any>? = [] //记录已经选择的图片(传给imagepick)
    var selectedPhotos : Array<UIImage>? = [] //记录选择的UIImage类型图片
    var selectedUrls : Array<Any>? = [] //记录话题已经包含的图片url(修改话题或图片转为话题时使用)
    var isSelectOriginalPhoto : Bool? = false //记录选择图片时是否选择原图
    var subGroupid : String?
    var groupid : String?{
        didSet{
            self.title = subGroupid != nil ? "修改话题" : "新建话题"
            self.configUI()
            if subGroupid != nil {
                let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",subGroupid!)).firstObject() as! GroupModel?
                if groupModel != nil {
                    textView?.text = groupModel?.group_name
                    placeholderLabel?.isHidden = true
                    self.progressShow()
                    GroupRequest.getGroupSubjectInfo(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":subGroupid!], hadToast: true, fail: { [weak self](error) in
                        if let strongSelf = self {
                            strongSelf.progressDismissWith(str: "获取话题信息失败")
                        }

                    }, success: { [weak self](dic) in
                        if let strongSelf = self {
                            strongSelf.progressDismiss()
                            if (dic["titleFileList"] is Array<Dictionary<String, Any>>) {
                                var urlArr : Array<Any>? = []
                                for dict:Dictionary<String, Any> in (dic["titleFileList"] as! Array<Dictionary<String, Any>>){
                                    urlArr?.append(dict)
                                }
                                strongSelf.selectedUrls = urlArr
                                strongSelf.creatImageView()
                            }
                        
                        }
                    })
                }
            }
        }
    }

    var creatThemeSuccessBlock : ((_ themeid:String?) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
      
    }
    
    func configUI() {
        let scrollView = UIScrollView.init(frame: self.view.bounds)
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            
        }
        scrollView.contentSize = CGSize.init(width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT + 1)
        scrollView.backgroundColor = UIColor.groupTableViewBackground
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        textView = UITextView.init(frame: CGRect.init(x: LEFT_PADDING, y: NAV_HEIGHT + LEFT_PADDING, width: MAIN_SCREEN_WIDTH - 2 * LEFT_PADDING, height: textView_height));
        textView?.backgroundColor = UIColor.groupTableViewBackground
        textView?.textColor = UIColor.black
        textView?.font = kFont_Middle
        textView?.delegate = self
//        解决UITextView文本自动滑动问题。
        textView?.layoutManager.allowsNonContiguousLayout = false
        textView?.becomeFirstResponder()

        scrollView.addSubview(textView!)
        placeholderLabel = UILabel.init()
        placeholderLabel?.font = kFont_Middle
        placeholderLabel?.textColor = UIColor.lightGray
        textView?.addSubview(placeholderLabel!)
        placeholderLabel?.text = "请输入话题内容"
        placeholderLabel!.mas_makeConstraints { (make) in
            make!.top.equalTo()(8)
            make!.left.equalTo()(5)
        }
        imageBgView = UIScrollView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT + textView_height + 20, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT - (NAV_HEIGHT + textView_height + 20)))
        scrollView.addSubview(imageBgView!)
        self.setRightBtnWithArray(items: ["完成"]);
        self.creatImageView()
    }
    func creatImageView() {

        for subView in (imageBgView?.subviews)! {
            subView.removeFromSuperview()
        }
        let imgMargin : CGFloat = 10.0
        let imgW : CGFloat = (MAIN_SCREEN_WIDTH - 4 * imgMargin)/3.0
        let btnW : CGFloat = 30.0

        imageBgView?.contentSize = CGSize.init(width: MAIN_SCREEN_WIDTH, height: (imgMargin + imgW) * CGFloat(((self.selectedUrls?.count)! + (self.selectedPhotos?.count)!)/3 + 1))
        for i in 0..<(self.selectedUrls?.count)! {
           
            let imageView = UIImageView.init(frame: CGRect.init(x: imgMargin * CGFloat(i%3 + 1) + imgW * CGFloat(i%3), y: imgMargin * CGFloat(i/3 + 1) + imgW * CGFloat(i/3), width: imgW, height: imgW))
            imageView.tag = 10 + i
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: NSURL.init(string: (self.selectedUrls?[i] as! Dictionary)["thumb_url"]!) as URL?, placeholderImage: UIImage.init(named: ""))
            let ges = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
            ges.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(ges)
            imageBgView?.addSubview(imageView)
            
            let delBtn = UIButton.init(frame: CGRect.init(x: imgW - btnW, y: 0, width: btnW, height: btnW))
            delBtn.tag = 20 + i
            delBtn.addTarget(self, action: #selector(delBtnClick), for: .touchUpInside)
            delBtn.setImage(UIImage.init(named: "delect"), for: .normal)
            imageView.addSubview(delBtn)

        }

        for i in 0..<(self.selectedPhotos?.count)! + 1 {
            if i == self.selectedPhotos?.count {
                let chooseImageBtn = UIButton.init(frame: CGRect.init(x: imgMargin * CGFloat((i + (self.selectedUrls?.count)!)%3 + 1) + imgW * CGFloat((i + (self.selectedUrls?.count)!)%3), y: imgMargin * CGFloat((i + (self.selectedUrls?.count)!)/3 + 1) + imgW * CGFloat((i + (self.selectedUrls?.count)!)/3), width: imgW, height: imgW))
                chooseImageBtn.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
                chooseImageBtn.setBackgroundImage(UIImage.init(named: "select_photo"), for: .normal)
                chooseImageBtn.setTitleColor(UIColor.black, for: .normal)
                chooseImageBtn.layer.borderWidth = 0.5
                chooseImageBtn.layer.borderColor = UIColor.lightGray.cgColor
                imageBgView?.addSubview(chooseImageBtn)
            }else{
                let imageView = UIImageView.init(frame: CGRect.init(x: imgMargin * CGFloat((i + (self.selectedUrls?.count)!)%3 + 1) + imgW * CGFloat((i + (self.selectedUrls?.count)!)%3), y: imgMargin * CGFloat((i + (self.selectedUrls?.count)!)/3 + 1) + imgW * CGFloat((i + (self.selectedUrls?.count)!)/3), width: imgW, height: imgW))
                imageView.tag = 10 + (i + (self.selectedUrls?.count)!)
                imageView.isUserInteractionEnabled = true
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = self.selectedPhotos?[i]
                imageBgView?.addSubview(imageView)
                let ges = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
                ges.numberOfTapsRequired = 1
                imageView.addGestureRecognizer(ges)
                
                let delBtn = UIButton.init(frame: CGRect.init(x: imgW - btnW, y: 0, width: btnW, height: btnW))
                delBtn.tag = 20 + (i + (self.selectedUrls?.count)!)
                delBtn.addTarget(self, action: #selector(delBtnClick), for: .touchUpInside)
                delBtn.setImage(UIImage.init(named: "delect"), for: .normal)
                imageView.addSubview(delBtn)

            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITextView {
            return
        }
        if (textView?.isFirstResponder)! {
            textView?.resignFirstResponder()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func rightBtnClick(button: UIButton) {
        if (textView?.text.characters.count)! == 0 {
            self.view.makeToast("话题名称不能为空", duration: 1.0, position: self.view.center)
            
            return
        }
        self.progressShow()
        var photoArr : Array<Dictionary<String, Any>>? = []
        if (self.selectedPhotos?.count)! > 0 {
            
            for i in 0..<(self.selectedPhotos?.count)! {
                
                GroupRequest.uploadImage(image: (self.selectedPhotos?[i])!, params: ["groupid":self.groupid!,"thumb":1,"thumbWidht":300,"thumbHeight":300], hadToast: true, fail: { [weak self](fail) in
                     if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                }, success: { [weak self](success) in
                    if let strongSelf = self {
                        var tempDic : Dictionary<String, Any>? = [:]
                        tempDic?["url"] = success["url"]
                        tempDic?["thumb_url"] = success["thumb_url"]
                        photoArr?.append(tempDic!)
                        if photoArr?.count == strongSelf.selectedPhotos?.count{
                            DispatchQueue.main.async {
                              
                                strongSelf.creatTheme(photoArr:photoArr)
                            }
                        }
                    }
                })
            }
        }else{
            self.creatTheme(photoArr:photoArr)
        }
    }

    func creatTheme(photoArr:Array<Dictionary<String, Any>>?)  {
        var params : Dictionary<String, Any> = [:]
        if subGroupid != nil {
            //TODO:修改话题图片
            var tempArr : Array<Dictionary<String, Any>>? = photoArr
            for i in 0..<(selectedUrls?.count)! {
                tempArr?.insert(self.selectedUrls?[i] as! [String : Any], at: i)
            }
            if (tempArr?.count)! > 0 {
                params = ["app_token":sharePublicDataSingle.token,"sub_groupid":subGroupid!,"title":textView?.text!,"file_json":SignTool.makeJsonStrWith(object: tempArr!)]
            }else{
                params = ["app_token":sharePublicDataSingle.token,"sub_groupid":subGroupid!,"title":textView?.text!]
            }

            GroupRequest.updateGroupSubject(params: params, hadToast: true, fail: { [weak self] (fail) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                }
            }) { (success) in
                print("修改话题成功",success)
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                
                if time == nil{
                    time = "0"
                }
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                    }, success: {[weak self] (dic) in
                        if let strongSelf = self {
                            strongSelf.progressDismiss()
                            strongSelf.selectedAssets?.removeAll()
                            strongSelf.selectedPhotos?.removeAll()
                            strongSelf.isSelectOriginalPhoto = false
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                )
                
            }

        }else{
            if (photoArr?.count)! > 0 {
                params = ["app_token":sharePublicDataSingle.token,"groupid":self.groupid!,"title":textView?.text!,"file_json":SignTool.makeJsonStrWith(object: photoArr!)]
            }else{
                params = ["app_token":sharePublicDataSingle.token,"groupid":self.groupid!,"title":textView?.text!]
            }
            GroupRequest.createGroupSubject(params: params, hadToast: true, fail: { [weak self] (fail) in
                if let strongSelf = self {
                    strongSelf.progressDismissWith(str: "创建话题失败")
                }
            }) { [weak self](success) in
                print("创建话题成功",success)
                if let strongSelf = self{
                    let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                    var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                    
                    if time == nil{
                        time = "0"
                    }
                    let themeid : String? = String.changeToString(inValue: success["subGroupId"])
                    let newMess = ThemeMessageContent()
                    newMess.content = (strongSelf.textView?.text)!
                    newMess.extra = ""
                    newMess.imageURL = ""
                    newMess.thumbnailUrl = ""
                    newMess.url = ""
                    newMess.groupId = strongSelf.groupid!
                    newMess.themeId = themeid!
                    for i in 0..<(strongSelf.navigationController?.childViewControllers.count)!{
                        if strongSelf.navigationController?.childViewControllers[i] is TMTabbarController{
                            
                            let Tab:TMTabbarController =  strongSelf.navigationController?.childViewControllers[i] as! TMTabbarController
                            let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                            smak.isRunApi = false
                            smak.sendMessage(newMess, pushContent: PublicDataSingle.makePushContent(newMess, groupId: smak.targetId))
                            break
                        }
                    }
                   
                    UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                        if let strongSelf = self {
                            strongSelf.progressDismiss()
                        }
                        }, success: {[weak self] (dic) in
                            if let strongSelf = self {
                                strongSelf.progressDismiss()
                                strongSelf.selectedAssets?.removeAll()
                                strongSelf.selectedPhotos?.removeAll()
                                strongSelf.isSelectOriginalPhoto = false
                                strongSelf.navigationController?.popViewController(animated: false)
                                if strongSelf.creatThemeSuccessBlock != nil{
                                    strongSelf.creatThemeSuccessBlock!(themeid)}
                            }
                        }
                        
                    )
                    
                }
            }
        }
    }
    @objc func chooseImage() {
        if (self.selectedUrls?.count)! >= 9 {
            self.view.makeToast("最多选择九张图片", duration: 1.0, position: self.view.center)
            return
        }
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: (9 - (self.selectedUrls?.count)!) > 0 ? (9 - (self.selectedUrls?.count)!) : 0, delegate: self)
        imagePickerVc?.allowPickingOriginalPhoto = false
        imagePickerVc?.selectedAssets = NSMutableArray.init(array: self.selectedAssets!)
        imagePickerVc?.isSelectOriginalPhoto = self.isSelectOriginalPhoto!
        imagePickerVc?.didFinishPickingPhotosHandle = ({ (photos : Array<UIImage>?, assets : Array<Any>?,isSelectOriginalPhoto:Bool?) in
            
            self.selectedAssets = assets
            self.isSelectOriginalPhoto = isSelectOriginalPhoto
            if isSelectOriginalPhoto! {
                DispatchQueue.main.async {
                    var tempPhotos : Array<UIImage>? = []
                    for i in 0..<(assets?.count)! {
                        
                        TZImageManager().getOriginalPhoto(withAsset: assets?[i], completion: { (image, dic) in
                            tempPhotos?.append(image!)
                            if tempPhotos?.count == (assets?.count)!{
                                DispatchQueue.main.async {

                                    self.selectedPhotos = tempPhotos
                                    
                                    self.creatImageView()
                                }
                            }
                        })
                    }
                }
            }else{
                self.selectedPhotos = photos
                self.creatImageView()
            }
        })
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
    /// 图片点击响应
    ///
    /// - Parameter tap: <#tap description#>
    @objc func tapped(_ tap:UITapGestureRecognizer){
        let image:UIImageView = tap.view as! UIImageView
        
        let photoBrowser = SDPhotoBrowser.init()
        photoBrowser.delegate = self as SDPhotoBrowserDelegate
        photoBrowser.currentImageIndex = image.tag - 10
        photoBrowser.imageCount = (imageBgView?.subviews.count)! - 1
        photoBrowser.sourceImagesContainerView = imageBgView
        
        photoBrowser.show()
        
    }
    
    @objc func delBtnClick(btn:UIButton) {
        if btn.tag - 20 < (self.selectedUrls?.count)! {
            self.selectedUrls?.remove(at: btn.tag - 20)
        }else{
            self.selectedAssets?.remove(at: btn.tag - (20 + (self.selectedUrls?.count)!))
            self.selectedPhotos?.remove(at: btn.tag - (20 + (self.selectedUrls?.count)!))
            if (self.selectedAssets?.count)! == 0 {
                self.isSelectOriginalPhoto = false
            }
        }
        self.creatImageView()
    }
}
extension ThemeCreatVC : TZImagePickerControllerDelegate{

    
}
extension ThemeCreatVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.contentSize = CGSize.init(width: textView.frame.size.width, height: textView.layoutManager.usedRect(for: textView.textContainer).size.height + 20)
//        textView.layoutIfNeeded()
    }
    func textViewDidChange(_ textView: UITextView) {//同样的代码:适配iOS8
        if textView.textInputMode?.primaryLanguage == "zh-Hans" {
            let selectedRange : UITextRange? = textView.markedTextRange
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textView.position(from: (selectedRange?.start)!, offset: 0)!
            }
            if position == nil {
                if (textView.text?.characters.count)! > 0 {
                    placeholderLabel?.isHidden = true
                }else{
                    placeholderLabel?.isHidden = false
                }
//                if (textView.text?.characters.count)! > maxTextLength {
//                    textView.text = textView.text?.substring(to: (textView.text?.index((textView.text?.startIndex)!, offsetBy: maxTextLength))!)
//                    return
//                }

            }else{
                
            }
        }else{
            if (textView.text?.characters.count)! > 0 {
                placeholderLabel?.isHidden = true
            }else{
                placeholderLabel?.isHidden = false
            }
//            if (textView.text?.characters.count)! > maxTextLength {
//                textView.text = textView.text?.substring(to: (textView.text?.index((textView.text?.startIndex)!, offsetBy: maxTextLength))!)
//                return
//            }

        }
        
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            return false
//        }
        var str = textView.text?.replacingCharacters(in: (textView.text?.changeToRange(from: range)!)!, with: text)
        if textView.textInputMode?.primaryLanguage == "zh-Hans" {
            let selectedRange : UITextRange? = textView.markedTextRange
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textView.position(from: (selectedRange?.start)!, offset: 0)!
            }
            if position == nil {
                if (str?.characters.count)! > 0 {
                    placeholderLabel?.isHidden = true
                }else{
                    placeholderLabel?.isHidden = false
                }
//                if (str?.characters.count)! > maxTextLength {
//                    textView.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
//                    return false
//                }

            }else{
                
            }
        }else{
            if (str?.characters.count)! > 0 {
                placeholderLabel?.isHidden = true
            }else{
                placeholderLabel?.isHidden = false
            }
//            if (str?.characters.count)! > maxTextLength {
//                textView.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
//                return false
//            }

        }
        
        return true
    }
}
// MARK: - 图片浏览器代理
extension ThemeCreatVC:SDPhotoBrowserDelegate{
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        
        let imageView:UIImageView = imageBgView?.subviews[index] as! UIImageView
        return imageView.image
        
    }
    
//    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
//        
//        let dic = imageArray?[index]
//        let str = dic?["url"]
//        return NSURL.init(string: str!)! as URL
//    }
    
}
