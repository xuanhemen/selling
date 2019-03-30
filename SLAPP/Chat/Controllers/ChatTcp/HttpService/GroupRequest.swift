//
//  GroupRequest.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/3.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
//关于群组相关的请求

class GroupRequest: BaseRequest {

    
    /// 入群申请
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID msg:申请说明
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func groupJoinApply(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_JoinApply), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 批准入群申请
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token applyid:申请ID status:审核结果（1:同意入群;2:拒绝入群）
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func groupJoinApplyAudit(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_JoinApplyAudit), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 使用验证码加入群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID auth_code:群组验证码
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func groupJoinByCode(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_JoinByCode), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 扫描二维码加入群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID verify_code:群组验证码
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func groupJoinByQr(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_JoinByQr), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    /// 创建群组
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func creat(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Create), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
        
//        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }
    
    
    
    
    /// 修改群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID group_name:群组名称
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func update(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Update), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    /// 是否开放
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID is_open:公开状态（0不公开，1公开）
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func setOpen(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_SetOpen), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 退出群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func quit(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Quit), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 解散群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回{"code":1,"msg":"","data":null}
    public static func dismiss(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
         self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Dismiss), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 群组成员
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func userList(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 删除群组成员
    ///
    /// - Parameters:
    ///   - params: 请求参数 appToken:App登录Token groupId:群组ID userIdStr:删除的用户ID（,分割）
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func delUser(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_DelUser), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 获取加入群组
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func myGroupList(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 访问服务端获取用户信息

    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getUserByIds(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 搜索群组
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func search(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Search), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 置顶群组
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func setTop(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 获取群组信息
    ///
    /// - Parameters:
    ///   - params: 请求参数  app_token:App登录Token groupid:群组ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func info(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Info), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 邀请加入
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID userid_str:邀请用户ID字符串（,分割）
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func inviteUser(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_InviteUser), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 接受邀请加入
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token inviteid:邀请ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func acceptInvite(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        //group_AcceptInvite
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_AcceptInvite), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 主动加入
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func requestJoin(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 验证码加入
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func joinByAuthCode(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    
    
    /// 二维码加入
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func join(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: "", params: params, hadToast: hadToast, fail: fail, success: success);
    }

    /// 获取二维码
    ///
    /// - Parameters:
    ///   - params: 请求参数 appToken:App登录Token groupId:群组ID authCode:群组验证码
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getQrCode(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Qr_code), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    /// 加入公共群组
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token 
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func joinPublicGroup(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_JoinPublicGroup), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    /// 获取话题列表
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID keyword:关键词(非必填) is_join是否加入（默认:-1不限;0:未加入;1:加入)(非必填） offset当前页（默认:1）(非必填) length每页记录数（默认:-1不限）(非必填)
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getSubjectList(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_SubjectList), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: DataOperation.saveSimpleListDataWithTable(table: GroupModel.self, success: success));
    }
    
    /// 创建话题
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token groupid:群组ID title:标题(必填) msg_uid消息UID(非必填） file_json话题图片数据(非必填)
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func createGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Create_subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 修改话题
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID title:标题(必填)
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func updateGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Update_subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    /// 解散话题
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func dismissGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Dismiss_subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 多选消息
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func forwardGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Forward_Subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
 
    /// 退出话题
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func quitGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Quit_subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 结束辅导
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func finishOnlineConsult(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Finish_Online_Consult), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 获取话题信息
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID 
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getGroupSubjectInfo(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Subject_info), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: DataOperation.saveThemeInfoData(success: success));
    }
    
    /// 加入话题
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func joinGroupSubject(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Join_subject), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    /// 查看话题历史记录
    ///
    /// - Parameters:
    ///   - params: 请求参数 app_token:App登录Token sub_groupid:话题ID  lasttime:最近获取消息时间 length:取消息记录数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getGroupSubjectHistorymsg(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: group_Subject_msg_history), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    /// 图片上传（仅限图片类型）
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - params: 请求参数 groupid:群组ID ,maxLimit : int 是否尺寸限制（可选，1：有限制，0：无限制，默认0）,maxWidth： int 最大高度（可选，maxLimit为true时有效、必传）,maxHeight： int 最大宽度（可选，maxLimit为true时有效、必传）,thumb： int 是否要缩略图（可选，1：缩略，0：无缩略，默认0）,thumbWidht： int 缩略图宽度（可选，thumb为true时有效、必传）,thumbHeight： int 缩略图高度（可选，thumb为true时有效、必传）
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func uploadImage(image: UIImage, params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        let manager = BaseRequest.initManager()
        //HEADER 参数（用于服务端接口识别APP）：
        manager.requestSerializer.setValue("app", forHTTPHeaderField: "xslpdevice")
        manager.requestSerializer.setValue(sharePublicDataSingle.token as String, forHTTPHeaderField: "token")
        
        let postTask: URLSessionDataTask? = manager.post(tcp_host+"index.php/Api/Im/uploadImg", parameters: params, constructingBodyWith: { (formData:AFMultipartFormData) in //正式
//        let postTask: URLSessionDataTask? = manager.post("http://t-tcp.xslp.cn/index.php/Api/Im/uploadImg", parameters: params, constructingBodyWith: { (formData:AFMultipartFormData) in
        
            var imageData = UIImageJPEGRepresentation(image, 1)
            if (imageData?.count)! > 1024*1024 { //1M以及以上
                imageData = UIImageJPEGRepresentation(image, 0.1)
            }else if (imageData?.count)! > 512*1024 { //0.5M-1M
                imageData = UIImageJPEGRepresentation(image, 0.5)
            }else  if (imageData?.count)! > 200*1024 { //0.25M-0.5M
                imageData = UIImageJPEGRepresentation(image, 0.9)
            }
            
            let interval : TimeInterval = Date().timeIntervalSince1970 * 1000
            formData.appendPart(withFileData: imageData!, name: "uploadfile", fileName: "\(interval)-image.jpg", mimeType: "image/jpg")
        }, progress: { (uploadProgress:Progress) in
            
        }, success: { (task:URLSessionDataTask, responseObject:Any?) in
            if responseObject is Dictionary<String, Any>{
                
                //TODO:(harry标注)-- 等接口能用的时候 考虑是否只返回 data中的数据
                success(responseObject as! Dictionary<String, Any>)
            }else{
                let str = String.init(data: responseObject as! Data, encoding: String.Encoding.utf8)
                DLog(str ?? "")
                let dic = try?JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                if String.changeToString(inValue: dic?["errcode"] ?? "1") == "0" {
                    if dic?["data"] is Dictionary<String, Any>{
                        success(dic?["data"] as! Dictionary<String, Any>)
                    }else{
                        success(dic!)
                    }
                }else{
                    DLog(String.changeToString(inValue: dic?["msg"] ?? "某张图片上传失败，请注意查看！"))
                    if (dic != nil){
                        fail(dic!)
                    }
                    
                    if hadToast == true{
                        SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic?["msg"] ?? "某张图片上传失败，请注意查看！"))
                        SVProgressHUD.dismiss(withDelay: 0.5)
                    }
                }
            }

        }, failure: { (task:URLSessionDataTask?, error:Error) in
            if hadToast {
                SVProgressHUD.showError(withStatus: "网络出现错误")
                SVProgressHUD.dismiss(withDelay: 0.5)
            }
            DLog(error.localizedDescription.description )
        })
        postTask?.resume()
    }

}
