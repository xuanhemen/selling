//
//  SLFollowUpModel.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/4.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLFollowUpModel: SLModel {
    
    /**条目id*/
    var id:String?
    /**名字*/
    var name:String?
    
    var relationid:String?
    
    var tablename:String?
    
    var userid:String?
     /**跟进人*/

    var realname:String = ""

    
    var dep_id:String?
    
    var dep_name:String?
    /**内容*/
    var activity_note:String?
    /**编码内容*/
    var encode_note:String?
    /**发布时间*/
    var addtime:String?
    
    var stamp:String?
    
    var corpid:String?
    
    var location:String?
    
    var contactids:String?
    /**客户联系人*/

    var contactnames:String = ""

    var createuserid:String?
    /**发布者*/
    var createname:String?
    /**头像*/
    var head:String?
    var client_id:String?
    var remind_user:String?
    /**图片字符串，需要解析成数组*/
    var files:String?
    /**点赞的人数组*/
    var support:[SLSupportModel]?
    /**标签数组*/
    var class_list:[SLTheLabelModel]?
    /**评论数组*/
    var comments:[SLCommentsModel]?
    /**图片或者文件数组*/
    var filesArr = [SLFlollowUpFileModel]()

}
/**图片或者文件*/
class SLFlollowUpFileModel: SLModel {
    
    /**图片地址*/
    var preview_url:String?
    /**缩略图*/
    var preview_url_small:String?
    /**类型*/
    var type:String?
    /***/
    var url:String?
    /***/
    var url_small:String?
    
}
/**标签*/
class SLTheLabelModel: SLModel {
    /**id*/
    var id:String?
    /**标签名*/
    var name:String?
}
/**点赞*/
class SLSupportModel: SLModel{
    /**点赞的人id*/
    var userid:String?
    /**点赞人姓名*/
    var realname:String?
}
/**评论*/
class SLCommentsModel: SLModel {
    
    /**id*/
    var id:String?
    /**内容*/
    var content:String?
    
    var encode_content:String?
    
    var is_reply:String?
    
    var create_userid:String?
    
    var to_userid:String?
    
    var fo_id:String?
    
    var addtime:String?
    
    var stamp:String?
    
    var to_comment_id:String?
    
    var corpid:String?
    
    var is_del:String?
    /**是否是本人*/
    var is_me:Int?
    /**评论人*/
    var create_realname:String?
    /**评论了谁*/
    var to_realname:String?
   
}

