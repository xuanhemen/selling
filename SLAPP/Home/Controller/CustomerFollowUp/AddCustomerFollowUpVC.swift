//
//  AddCustomerFollowUpVC.swift
//  SLAPP
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
class AddCustomerFollowUpVC: BaseVC,TZImagePickerControllerDelegate {
    
    
    var fo_id:String?
    
   var imageUrArry = Array<Dictionary<String,Any>>()
    
//    跟进model
   @objc  var model:SDTimeLineCellModel?
    
   @objc var contactName:String = ""
   @objc var clientId:String = ""
   var proModel:QFFollowUpProjectModel?
   var type:VC_CHOOSE_TYPY?
    var tagList = Array<String>()
    
    
    /// 做type赋值
    ///
    /// - Parameter type: 0 - 1 - 2 客户  联系人  项目
   @objc func configType(t:Int){
        if t == 0 {
            self.type = .client
        }else if t == 1 {
            self.type = .contact
        }else if t == 3{
            self.type = .clues
        }else {
            self.type = .project
        }
        
    }
    
    @objc var needRefresh:()->() = {
        
    }
    
    //图片选择
    let imageChooseView = FollowUpIImageChoose()
    
    //项目列表
    let category = MemberShowView()
    
    //项目列表
    let project = MemberShowView()
    //联系人
    let contact = MemberShowView()
    //提醒谁看
    let spectialContact = MemberShowView()
    
    let back = UIScrollView()
    //对应跟进的 客户  或者  联系人  或者 项目id
    @objc var proId:String = ""
    
    var cluesID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(back)
        back.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview().offset(0)
          
        }
        
        
        self.configUI()
        
      
        
    }
    
    func configUI(){
        
        self.setRightBtnWithArray(items: ["发布"])
        
        
        
        back.addSubview(content);
        content.placeholder = "请填写内容"
        content.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(kScreenW-20)
            make.height.equalTo(200)
        }
        content.layer.borderWidth = 0.5
        content.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
        back.addSubview(imageChooseView)
//        imageChooseView.backgroundColor = UIColor.red
        imageChooseView.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(kScreenW-20)
            make.height.equalTo((kScreenW-4*imageSpace-20)/3.0+imageSpace*2)
        }
        
        imageChooseView.refresh = {[weak imageChooseView](h)in
            imageChooseView?.snp.updateConstraints({ (make) in
                make.height.equalTo(h)
            })
        }
        imageChooseView.showImage()
        imageChooseView.delete = { [weak imageChooseView] in
            imageChooseView?.showImage()
        }
        
        imageChooseView.clickAdd = {[weak self](num)in
            
          let vc = TZImagePickerController.init(maxImagesCount: num, delegate: self)
            
            self?.present(vc!, animated: true, completion: nil)

        }
        let line = UIView()
        line.backgroundColor = HexColor("#F2F2F2")
        back.addSubview(line)
        line.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.imageChooseView.snp.bottom)!)
            make.left.equalTo(10)
            make.width.equalTo(kScreenW-20)
            make.height.equalTo(1)
        }
        
        back.addSubview(category)
        category.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(10)
            make.width.equalTo(kScreenW-20)
            make.height.equalTo(50)
        }
        category.btnClick = { [weak self] in
            let vc = HYChooseTagVC()
            vc.alreadyArray.removeAllObjects()
            for str in (self?.tagList)! {
                vc.alreadyArray.add(str)
            }
            vc.action = { [weak self] (array, nameArray) -> () in
                
                self?.category.tagsString = (nameArray as! [String]).joined(separator: "、")
                
                self?.tagList.removeAll()
                for str in array! {
                    self?.tagList.append(str as! String)
                }
                print(self?.tagList as Any)
                }
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if self.model != nil {
            if self.model?.class_list != nil && (self.model?.class_list.count)!>0{
                for dict in (model?.class_list)! {
                    self.tagList.append(String.noNilStr(str: (dict as! Dictionary)["id"]))
                }
            }
        }
        
        
        if self.type == .project {
            back.addSubview(contact)
            contact.snp.makeConstraints {[weak self] (make) in
                make.top.equalTo((self?.category.snp.bottom)!)
                make.left.equalTo(10)
                make.width.equalTo(kScreenW-20)
                make.height.equalTo(50)
            }
            
            self.title = self.model == nil ? "添加项目跟进": "修改项目跟进";
        }
        else if self.type == .contact {
            back.addSubview(project)
            project.snp.makeConstraints { (make) in
                make.top.equalTo(category.snp.bottom)
                make.left.equalTo(10)
                make.width.equalTo(kScreenW-20)
                make.height.equalTo(50)
            }
            self.title = self.model == nil ? "添加联系人跟进": "修改联系人跟进";
        }else if self.type == .clues{

            self.title = self.model == nil ? "添加跟进记录": "修改跟进记录";

           
        }else{
            back.addSubview(project)
            project.snp.makeConstraints { (make) in
                make.top.equalTo(category.snp.bottom)
                make.left.equalTo(10)
                make.width.equalTo(kScreenW-20)
                make.height.equalTo(50)
            }
            back.addSubview(contact)
            contact.snp.makeConstraints {[weak self] (make) in
                make.top.equalTo((self?.project.snp.bottom)!)
                make.left.equalTo(10)
                make.width.equalTo(kScreenW-20)
                make.height.equalTo(50)
            }
            
            self.title = self.model == nil ? "添加客户跟进": "修改客户跟进";
        }
        
        category.nameLable.text = "所属分类:"
        category.headImage.image = #imageLiteral(resourceName: "followP")
        category.remindImage.isHidden = true
        if self.title == "跟进记录" {
            return
        }
        project.nameLable.text = "项目列表:"
        project.headImage.image = #imageLiteral(resourceName: "followProject")
        project.remindImage.isHidden = true
       
        
        project.btnClick = { [weak self] in
            let vc = QFFollowUpProjectListVC()
            vc.id = (self?.proId)!
            if self?.type == .contact{
                vc.isContact = true
            }else{
                vc.isContact = false
            }
            
             self?.navigationController?.pushViewController(vc, animated: true)
            vc.selectProjectModel = { (model) in
//                if self?.proModel != nil {
                    self?.deleteMembers()
//                }
                self?.proModel = model
                self?.project.configProjectWithModel(model: model)
            }
        }
        
        project.proDeleteClick = { [weak self] in
            //  点击了删除
            self?.proModel = nil
            return true
        }
        
        contact.headImage.image = #imageLiteral(resourceName: "qf_contactImage")
        
        contact.nameLable.text = "联系人:"
       
        contact.btnClick = { [weak contact,weak self] in
            //联系人点击
            let vc = ProFollowUpChooseMemberVC()
            vc.type = self?.type!
            if self?.type == .project {
                //项目只传项目id
                vc.proId = self?.proId;
            }else{
                //客户都传
                if self?.proModel != nil {
                    vc.proId = (self?.proModel?.id)!
                }
                vc.id = (self?.proId)!
            }
            
            vc.result = { (m) in
                let h = contact?.configWithArray(array: m)
                contact?.snp.updateConstraints({ (make) in
                    make.height.equalTo(h!)
                })
            }
            vc.selectArray = (contact?.dataArray)!
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        spectialContact.headImage.image = #imageLiteral(resourceName: "followR")
        spectialContact.remindImage.isHidden = true
        back.addSubview(spectialContact)
        spectialContact.nameLable.text = "提醒谁看:"
        spectialContact.snp.makeConstraints {[weak self] (make) in
            if self?.type == .clues{
                make.top.equalTo((self?.category.snp.bottom)!)
            }else{
                if self?.type != .contact {
                    make.top.equalTo((self?.contact.snp.bottom)!)
                }else{
                    make.top.equalTo((self?.project.snp.bottom)!)
                }
            }
            
            
            make.left.equalTo(10)
           make.width.equalTo(kScreenW-20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-10)
        }
        spectialContact.btnClick = {[weak spectialContact,weak self] in
            //提醒点击
            let vc =  ProFollowUpChooseSpecaiVC()
            
            
            
            vc.type = self?.type
            
            if self?.type == .project {
                //项目只传项目id
                vc.proId = self?.proId;
            }else if self?.type == .clues{
                vc.clientID = ""
            }else{
                //客户都传
                if self?.proModel != nil {
                    vc.proId = (self?.proModel?.id)!
                }
                vc.id = (self?.proId)!
            }
            
            vc.result = { (m) in
                let h = spectialContact?.configWithArray(array: m)
                spectialContact?.snp.updateConstraints({ (make) in
                    make.height.equalTo(h!)
                })
            }
            vc.selectArray = (spectialContact?.dataArray)!
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        self.configData()
    }
    
    
    /// 换项目要清选择的数据
    func deleteMembers(){
        if contact.getIds().count > 0 || spectialContact.getIds().count > 0 {
            PublicMethod.toastWithText(toastText: "选择项目需重新选择提醒人和联系人")
        }
        
        let h = contact.configWithArray(array: [])
        contact.snp.updateConstraints({ (make) in
            make.height.equalTo(h)
        })
        
        let h1 = spectialContact.configWithArray(array: [])
        spectialContact.snp.updateConstraints({ (make) in
            make.height.equalTo(h1)
        })
    }
    
    //MARK: - 数据
    func configData(){
        //修改是调用
        guard model != nil else {
            return
        }
//        self.title = "跟进修改"
//        self.content.text = model?.msgContent.replacingOccurrences(of: "+", with: "%20").removingPercentEncoding
        print(model?.msgContent)
        self.content.text = model?.msgContent
        let cNameArray = self.model?.contactnames.components(separatedBy: ",")
        let cIdArray = self.model?.contactids.components(separatedBy: ",")
        if cIdArray?.count == cNameArray?.count {
            var array = Array<MemberModel>()
            for i in 0...(cNameArray?.count)!-1{
                let model  = MemberModel()
                model.name = cNameArray?[i]
                model.id = cIdArray?[i]
                model.head = ""
                array.append(model)
            }
            let h = contact.configWithArray(array: array)
            contact.snp.updateConstraints({ (make) in
                make.height.equalTo(h)
            })
        }
        
        
        if self.model?.proId != "" && self.model?.proId != nil {
            let pModel = QFFollowUpProjectModel()
            pModel.id = (self.model?.proId)!
            pModel.name = (self.model?.proName)!
            self.proModel = pModel;
            project.configProjectWithModel(model: self.proModel!)
        }
        
        
        if model?.picNamesArray != nil {
            imageChooseView.imageUrlData = model?.picNamesArray as! Array<[String : Any]>;
            imageChooseView.showImage()
        }
        
//        if ([dic[@"files"] isNotEmpty]){
//            id file = [LoginRequest makeJsonWithStringWithJsonStr:[NSString stringWithFormat:@"%@",dic[@"files"]]];
//            //NSLog(@"%@",file);
//
//            if ([file isKindOfClass:[NSArray class]] ){
//                if ([file isNotEmpty]){
//                    model.picNamesArray = (NSArray *)file;
//                }
//
//            }
//        }
        
        
        
        
        guard self.model?.remind_user_name != "" && self.model?.remind_user_name != nil else {
            return
        }
        let sNameArray = self.model?.remind_user_name.components(separatedBy: ",")
        let sIdArray = self.model?.remind_user.components(separatedBy: ",")
        if sIdArray?.count == sNameArray?.count {
            var array = Array<MemberModel>()
            for i in 0...(sNameArray?.count)!-1{
                let model  = MemberModel()
                model.name = sNameArray?[i]
                model.id = sIdArray?[i]
                model.head = ""
                array.append(model)
            }
            let h = spectialContact.configWithArray(array: array)
            spectialContact.snp.updateConstraints({ (make) in
                make.height.equalTo(h)
            })
        }
        
        
        
        
    }
    
    
    override func rightBtnClick(button: UIButton) {
        
        if content.text == "" && (imageChooseView.imageData.count + imageChooseView.imageUrlData.count) == 0 {
            PublicMethod.toastWithText(toastText: "内容不能为空")
            return
        }
        
        
        
        
        if self.type != .contact {
            if contact.dataArray.count == 0 && self.type != .clues {
                PublicMethod.toastWithText(toastText: "请选择联系人")
                return
            }
        }
        
        if imageChooseView.imageData.count == 0 {
            self.imageUrArry.removeAll()
            self.imageUrArry += imageChooseView.imageUrlData
            self.toAdd()
        }else{
            
            self.sendImage(array: imageChooseView.imageData)
            
        }
        
        
        
    }
    
    
    //MARK: - 发布
    func toAdd(){
        
        var params = Dictionary<String,Any>()
        var usrStr:String = ""
        if self.title=="添加跟进记录"{
            usrStr = "pp.clue.clue_fo_add"
            params["clue_id"] = self.cluesID
            params["note"] = String.base64Encode(str: content.text!)
            params["files"] = LoginRequest.makeJsonStringWithObject(object: self.imageUrArry)
            params["classification"] = self.tagList
            
        }else if self.title=="修改跟进记录"{
            usrStr = "pp.clue.clue_fo_edit"
            params["clue_id"] = self.cluesID
            params["fo_id"] = self.fo_id
            params["encode_note"] = String.base64Encode(str: content.text!)
            params["files"] = LoginRequest.makeJsonStringWithObject(object: self.imageUrArry)
            params["classification"] = self.tagList
        }else{
            params["classification"] = self.tagList
            
            params["ids"] = contact.getIds().joined(separator: ",")
            params["names"] = contact.getNames().joined(separator: ",")
            //        params["note"] = SDTimeLineTableViewController().encode(toPercentEscape: content.text)
            
            params["encode_note"] = String.base64Encode(str: content.text!)
            params["files"] =  LoginRequest.makeJsonStringWithObject(object: self.imageUrArry)
            if spectialContact.dataArray.count > 0 {
                params["remind_user"] = spectialContact.getIds()
            }
            if self.proModel != nil {
                params["pro_id"] = self.proModel?.id
            }
            usrStr = FOLLOWUP_FO_ADD
            switch self.type! {
            case .client:
                params["client_id"] = self.proId
            //           usrStr = ClIENT_FOLLOWUP_ADD
            case .contact:
                params["ids"] = self.proId
                params["client_id"] = self.clientId
                params["names"] = self.contactName
            //           usrStr = QF_contact_add_followup
            case .project:
                params["pro_id"] = self.proId
            //            usrStr = Pro_DOADD
            default: break
                
            }
            
            if model != nil {
                
                if self.type == .contact {
                    //                params["activity_note"] = SDTimeLineTableViewController().encode(toPercentEscape: content.text)
                    
                    params["encode_note"] = String.base64Encode(str: content.text)
                    let dic = ["id":self.proId,"name":self.contactName]
                    params["contacts"] = [dic]
                    params["fo_id"] = model?.id
                    usrStr = Pro_DOEdit
                    
                }
                else{
                    
                    //                params["activity_note"] = SDTimeLineTableViewController().encode(toPercentEscape: content.text)
                    params["encode_note"] = String.base64Encode(str: content.text)
                    let cArray = contact.getIds()
                    let nArray = contact.getNames()
                    var contactArray = Array<Dictionary<String,Any>>()
                    if cArray.count > 0 {
                        for i in 0 ... cArray.count-1 {
                            let dic = ["id":cArray[i],"name":nArray[i]]
                            contactArray.append(dic)
                        }
                    }
                    params["contacts"] = contactArray
                    params["fo_id"] = model?.id
                    usrStr = Pro_DOEdit
                }
            }
        }
        
        
       
        params = params.addToken()
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: usrStr, params: params, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            self?.needRefresh()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    
    lazy var content = { () -> KMPlaceholderTextView in
        let lable = KMPlaceholderTextView()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()

    
//    imagePickerController

    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
        DLog("aaaaaaaa")
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: Any!) {
        DLog("bbbbbbbb")
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        
        
//        self.sendImage(array: photos)
        
        imageChooseView.imageData += photos
        imageChooseView.showImage()
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        DLog("ddddddddd")
    }
    
    
    
    func sendImage(array:Array<UIImage>){
        
        self.imageUrArry.removeAll()
        self.imageUrArry += imageChooseView.imageUrlData
        var urlDict:Dictionary<String,Dictionary<String,Any>> = Dictionary<String,Dictionary<String,Any>>()
        
        PublicMethod.showProgress()
        UploadManager.uploadImages(with: array,passport+SEND_FOLLOW_IMAGE,["dir":"Followup"].addToken(), uploadFinish: { [weak self] in
            PublicMethod.dismiss()
            DLog("完成llllllLLLl")
            
            var keyArray = Array(urlDict.keys)
            keyArray.sort(by: {(num1, num2) in
                return num1 < num2
            })
            
            for key in keyArray{
                self?.imageUrArry.append(urlDict[key]!)
            }
            self?.toAdd()
            
        }, success: { [weak self](dic, idx) in
           DLog(dic)
            let idxStr = String.init(format: "%d", idx)
            urlDict[idxStr] = dic as! Dictionary<String, Any>
            
           DLog(idx)
        }) { (e, idx) in
            DLog(idx)
        }
        
        
        
        
        
    }
    
    
    
    
}
