//
//  PersonalInfoVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SDWebImage
class PersonalInfoVC: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let titleArray = ["头像","姓名","手机号","Email","密码"]
    
    var infoModel:Dictionary<String,Any>?
    
    lazy var headImage = { () -> UIImageView in
        let imageView = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH-90, y: 10, width: 60, height: 60))
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.groupTableViewBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMineInfo()
    }
    
    
    func getMineInfo(){
        
        
        PublicMethod.showProgress()
        
        LoginRequest.getPost(methodName: LOGINER_MESSAGE, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            
            DLog(dic)
            PublicMethod.dismiss()
            self?.infoModel = dic
            self?.tableView.reloadData()
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else{
            return 44
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "reuseIdentifier")
        }
        
        cell?.textLabel?.text = titleArray[indexPath.row]
        switch indexPath.row {
        case 0:
//            let headImage = UIImageView.init(frame: )
            cell?.contentView.addSubview(headImage)
            headImage.sd_setImage(with: NSURL.init(string: String.noNilStr(str: infoModel?["head"]).appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            
            break
        case 1:
            cell?.detailTextLabel?.text = String.noNilStr(str: infoModel!["realname"]!)
            cell?.accessoryType = .disclosureIndicator
            break
        case 2:
            cell?.detailTextLabel?.text = String.noNilStr(str: infoModel!["mobile"]!)
            break
        case 3:
            cell?.detailTextLabel?.text = String.noNilStr(str: infoModel!["email"]!)
            break
        case 4:
           cell?.detailTextLabel?.text = "修改密码"
           cell?.accessoryType = .disclosureIndicator
            break
        default:
            break
        }

        return cell!
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > 1 {
            let vc = MineReviseVC()
            let url = URL.init(string: String.init(format:"%@/User/Personal/id_validate/type/%@/token/%@",passport,indexPath.row == 2 ? "mobile" : indexPath.row == 3 ? "email":"password",UserModel.getUserModel().token!))
            vc.title = indexPath.row == 2 ? "修改手机号" : indexPath.row == 3 ? "修改邮箱" : "修改密码"
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        
        
        switch indexPath.row {
        case 0:
            self.updatePortrait()

            break
        case 1:
            let vc = ReviseVC()
            vc.titleStr = "修改姓名"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = ReviseVC()
            vc.titleStr = "修改手机号"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = ReviseVC()
            vc.titleStr = "修改邮箱"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            
            break
        default:
            break
        }
    }
    
    
    
    func updatePortrait(){
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction.init(title: "取消", style: .default) { (action) in
            
        }
        let albumAction = UIAlertAction.init(title: "从相册中选择", style: .default) { (action) in
            self.addPohtoOfAblum()
        }
        let photoAction = UIAlertAction.init(title: "拍照", style: .default) { (action) in
            self.addPohtoFromCamera()
        }
        
        alert.addAction(albumAction)
        alert.addAction(photoAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //相册
    func addPohtoOfAblum(){
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if(authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied){
            //无权限
            let alert = UIAlertController(title: nil, message:"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的相册。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true, completion: nil)
        
    }
    
    func addPohtoFromCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        if(authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied){
            //无权限
            let alert = UIAlertController(title: nil, message:"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的相机。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .camera
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage]
//        head_upload
        PublicMethod.showProgress()
        LoginRequest.sendHeadImage(image: image as! UIImage, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
           
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.clearCache(image:image as! UIImage)
        }
        
        
    }
    
    func clearCache(image:UIImage){
        headImage.image = image
//        headImage.sd_setImage(with: NSURL.init(string: String.noNilStr(str: self.infoModel?["head"]).appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
        
        
       
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
