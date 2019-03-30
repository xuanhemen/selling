//
//  UserModel.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class UserModel: NSObject,NSCoding {
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(corpid, forKey: "corpid")
        aCoder.encode(guide, forKey: "guide")
        aCoder.encode(is_pass, forKey: "is_pass")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(is_root, forKey: "is_root")
        aCoder.encode(companies, forKey: "companies")
        aCoder.encode(avater, forKey: "avater")
        aCoder.encode(realname, forKey: "realname")
        aCoder.encode(im_token, forKey: "im_token")
        aCoder.encode(im_userid, forKey: "im_userid")
        aCoder.encode(tcp_userid, forKey: "tcp_userid")
        aCoder.encode(ismanager, forKey: "ismanager")
        aCoder.encode(depId, forKey: "depId")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.corpid = aDecoder.decodeObject(forKey: "corpid") as? String
        self.guide = aDecoder.decodeObject(forKey: "guide") as? String
        self.is_pass = aDecoder.decodeObject(forKey: "is_pass") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.is_root = aDecoder.decodeObject(forKey: "is_root") as? String
        self.companies = aDecoder.decodeObject(forKey: "companies") as? Dictionary<String, String>
        self.avater = aDecoder.decodeObject(forKey: "avater") as? String
        self.realname = aDecoder.decodeObject(forKey: "realname") as? String
        self.im_token = aDecoder.decodeObject(forKey: "im_token") as? String
        self.im_userid = aDecoder.decodeObject(forKey: "im_userid") as? String
        self.tcp_userid = aDecoder.decodeObject(forKey: "tcp_userid") as? String
        self.ismanager = aDecoder.decodeObject(forKey: "ismanager") as? String
        self.depId = aDecoder.decodeObject(forKey: "depId") as? String
    }
    
    var ismanager:String? //部门管理者
  @objc  var id:String?
    var corpid:String?
    var guide:String?
    var is_pass:String?  //是否强制修改密码
  @objc  var token:String?
    @objc var is_root:String?  //企业管理者
    var companies:Dictionary<String,String>?
    
    @objc var depId:String?
    
    //融云相关用户信息
  @objc  var avater:String?
  @objc  var realname:String?
    var im_token:String?
  @objc  var im_userid:String?
    var tcp_userid:String? //tcp里的userid
    /**
     *  从本地获取保存的 用户信息
     *
     *  @return 返回usermodel
     */
  @objc class func getUserModel() -> UserModel{
        if UserDefaultRead(key: kUserid) == nil || UserDefaultRead(key: "userModel" + (UserDefaultRead(key: kUserid) as! String)) == nil{
            return UserModel.init()
        }
        
        let keyStr = "userModel" + (UserDefaultRead(key: kUserid) as! String)
        let data = UserDefaultRead(key: keyStr)
        let unarchiver = NSKeyedUnarchiver.init(forReadingWith: data as! Data)
        let model = unarchiver.decodeObject(forKey: "userModel")
        unarchiver.finishDecoding()
        return model as! UserModel
    }
    
    @objc func saveUserModel() {
        let data = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(self, forKey: "userModel")
        archiver.finishEncoding()
        let keyStr = "userModel" + self.id!
        UserDefaultWrite(id: data, key: keyStr)
    }
    
}
