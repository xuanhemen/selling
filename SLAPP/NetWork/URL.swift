//
//  URL.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

//MARK:----------------------初始化----------------------
//let passport = "https://passport.xslp.cn/index.php?s="
//let host_url = "http://gw.xslp.cn/index.php?" //网络接口 //正式
//let h5_host = "http://sl.xslp.cn/"
//let tcp_host = "http://tcp.xslp.cn/"
//let ryKey = "sfci50a7sqloi"  //融云key
//let defaultHeaderImageURL = "http://tcp.xslp.cn/static/images/userpic.jpg"
//let umAnalyticsKey = "5b077084f43e486f0e0000dc" //友盟统计Appkey
//let umChannel = "App Store" //友盟统计Channel

var passport = "https://t-passport.xslp.cn/index.php?s="
var host_url = "http://t-gw.xslp.cn/index.php?" //网络接口 //测试
var h5_host = "http://t-sl.xslp.cn/"
var tcp_host = "http://t-tcp.xslp.cn/"
var ryKey = "qf3d5gbjqpxeh"
var defaultHeaderImageURL = "http://t-tcp.xslp.cn/static/images/userpic.jpg"
var umAnalyticsKey = "5b076fa8f43e487fa7000098" //友盟统计Appkey
var umChannel = "App Store" //友盟统计Channel



//MARK:----------------------登录----------------------
let LOGIN_URL = "pp.user.login"
let LOGIN_URL_COMPANY = "pp.user.company_enter"

let MEMBER_SAVE_PWD = "pp.user.member_save_pwd"
let USER_UPDATE = "pp.user.member_message"

//获取验证码
let VERIFY_PHONE = "pp.user.verify_phone"

//找回密码
let FIND_PW = "pp.user.retrieve_password"

//获取更新
let QFRequest_FetchVersion = "pp.user.latest_version"

//MARK:----------------------融云----------------------
let IM_GetToken = "tcp.im.get_token"  //获取token
let GROUP_Finish_Online_Consult = "tcp.group.finish_online_consult" //结束辅导
let CONSULT_DEL = "pp.consult.consult_del" //取消辅导

//MARK:----------------------我的----------------------
let LOGINER_MESSAGE = "pp.user.loginer_message"
//注册下属接口
let USER_REGISTER = "pp.user.register"
let MEMBER_DELETE = "pp.user.member_delete"

let MEMBER_IS_DIMISSION = "pp.user.member_is_dimission"
let LEADER_SAVE_PWD = "pp.user.leader_save_pwd"
//授权信息
let COMPANY_MESSAGE = "pp.user.company_message"
//机构信息
let COMPANY_INFO = "pp.user.company_information"
//部门管理 能查看的下属列表
let MANAGE_MEMBERS = "pp.user.department_member"
//QF -- Add 通过父id 获取部门和人员
let QF_USERDEP_LIST = "pp.user.dep_list_parent"
//添加部门
let QF_ADD_DEP = "pp.user.dep_add"
//显示可以修改的部门
let QF_SHOW_DEP = "pp.user.dep_parent"
//修改部门
let QF_EDIT_DEP = "pp.user.dep_save"
//删除部门
let QF_DELETE_DEP = "pp.user.dep_del"

//QF -- 批量转移部门
let QFbatch_transfer_dep = "pp.user.batch_transfer_department"
//批量发短信重新邀请
let QFbatch_send_message = "pp.user.batch_send"
//部门人员详情
let  QFdep_Personnel_info = "pp.user.look_personal_center"
//修改是否是主管
let QFdep_Personnel_isManager = "pp.user.leader_save_manager"


//付费记录
let COACHPAY_LIST = "pp.consult.list_consult"
//获取省
let PROVINCE = "pp.user.province"
//获取城市
let CITIES = "pp.user.city"
let REGION = "pp.user.area"
let COMPANYINFO_SAVE = "pp.user.company_information_save"
//意见反馈
let RECOMMEND = "pp.user.recommend"

//功能介绍
let INTRODUCTION  = "pp.user.introduction"

//个人中心
let PERSONAL_INDEX = "pp.personal.index"



//MARK:----------------------首页----------------------
let INDEX1_COMMISSION = "pp.index.index1_commission"//首页展示信息 代办的事情（辅导） 第一版
let COMMISSION_MORE = "pp.index.commission_more"//代办事项 点击更多以后
let INDEX1_COMPLETION_RATE = "pp.index.index1_completion_rate"//首页展示信息绩效完成率 第一版
let INDEX1_INTELLISENSE = "pp.index.index1_intellisense"//首页展示信息 智能提示 第一版
//智能查看更多
let INTELLISENSE_MORE = "pp.index.intelliSense_more"

//通过USERID查看绩效设置
let ONESELF_FIND = "pp.index.target_oneself_find"
let DEP_FIND = "pp.index.target_dep_find"

//通过USERID设置
let ONESELF_SAVE = "pp.index.target_oneself_save"
let DEP_SAVE = "pp.index.target_dep_save"

//首页待办新
let INDEX2_COMMISSION = "pp.index.index2_commission"

//MARK:----------------------首页搜索相关----------------------
let LAST_VIEWED = "pp.index.last_viewed"//点击搜索 展示最近看过的内容
let SEARCH_PROCESS = "pp.index.search_process"//点击搜索 模糊查询收过的内容
let CLECK_SEARCH = "pp.index.click_search"//点击搜索 点击搜索按钮后 搜索内容

//录音上传地址
let SEND_RECORD = "User/User/storage_upload"
let RECORD_LABEL = "pp.index.record_label" //以前录音的标签
let SEND_HEAD_IMAGE = "User/User/head_upload"
//跟进记录上传图片地址
let SEND_FOLLOW_IMAGE = "User/Upload/only_upload"

//MARK: - ---------------------客户 联系人 相关的接口------------------

//通过父id获取 获取部门和人员（未离职的）
let DEP_LIST_JOBON = "pp.user.dep_list_parent_jobon"

//返回自己部门及以下的所有数据
let DEP_LIST = "pp.user.dep_list"


//行业列表
let TRADE_LIST = "pp.user.industry_information"


//单个客户下的所有项目
/*
 参数：
 id (int)
 客户id
 token
 */
let CLIENT_PROJECT_LIST  = "pp.clientContact.client_project"


//获取教师详情
let QFRequest_FetchTeacherDetail = "pp.member.get_teacher_information"


//单个联系人详情
/*
 参数：
 contact_id
 联系人id
 token
 */
let CONTACT_DETAIL = "pp.clientContact.contact_one"

//单个客户下的联系人
let ONE_CLIENT_CONTACTS = "pp.clientContact.customer_contact"

//显示所有的联系人
/*
 参数：
 token
 */
let CONTACT_LIST = "pp.clientContact.contact"
let QFAddProject_CONTACT_LIST = "pp.clientContact.client_contact"
//新增联系人
/*
 参数：
 contact_name
 联系人名字
 contact_position
 联系人职务（没有空字符串）
 contact_phone
 联系人电话（没有0）
 contact_client_id
 联系人关联的客户id（没有0）
 contact_client_name
 联系人关联的客户姓名（在客户id为空的情况下使用）（没有空字符串）
 trade_id
 二级行业id（在客户id为空并且客户名称不为空
 trade_name
 二级行业名字（在客户id为空并且客户名称不为空
 contact_email
 联系人邮箱（没有空字符串）
 contact_qq
 联系人qq（没有空字符串）
 contact_wechat
 联系人微信（没有空字符串）
 contact_addr
 联系人地址（没有空字符串）
 contact_postcode
 联系人邮编（没有空字符串）
 contact_fax
 联系人传真（没有空字符串）
 contact_dep
 联系人部门（没有空字符串）
 contact_sex
 联系人性别（没有空字符串）男，女
 contact_comment
 联系人备注（没有空字符串）
 token
 */
let CONTACT_ADD = "pp.clientContact.contact_add"
//修改联系人
let CONTACT_SAVE = "pp.clientContact.contact_save"
//修改客户
/*
 参数：
 client_id
 客户id
 clientname
 名字
 trade_id
 二级行业id
 trade_name
 二级行业名字
 [text]
 token
 */
let CLIENT_SAVE = "pp.clientContact.save_client"


//客户分配 展示客户分配给谁使用
/*
 参数：
 id
 客户id
 token
 */
let CLIENT_ASSIGN  = "pp.clientContact.client_user"


//客户分配修改
/*
 参数：
 id
 客户id
 member_ids
 分配者的id字符串形式已（|）隔开
 token
 */
let CLIENT_ASSIGN_REVISION  = "pp.clientContact.batchs_client_member"



//单个客户信息
/*
 参数：
 id
 客户id
 token
 */
let CLIENT_DETAIL = "pp.clientContact.client_one"

//删除客户/
/*
 参数：
 clientid
 客户id
 token
 */
let CLIENT_DELETE = "pp.clientContact.del_client"


//添加客户
/*
 参数：
 clientname
 名字
 trade_id
 二级行业id
 trade_name
 二级行业名字
 contact_name
 联系人名字
 contact_position
 联系人职务
 contact_phone
 联系人电话
 token
 */
let CLIENT_ADD = "pp.clientContact.add_client"


//所有客户信息
/*
 参数：
 token
 */
//let CLIENT_LIST = "pp.clientContact.client"
let CLIENT_LIST = "pp.clientContact.client_list"
//客户列表  选择客户用   没有红点信息
let CLIENT_LIST_SELECT = "pp.clientContact.inquire_client"


/// 单个客户的详情
let SINGLE_CLIENT = "pp.clientContact.client_one"


//获取指定的一条消息
/*
 参数：
 msg_id
 消息id
 token
 */
let MESSAGE_DETAIL  = "pp.user.search_one"


//获取消息中心
/*
 参数：
 domain
 云教练传CC（传空也默认CC）
 status
 0未看过1看过2全部
 msg_type
 0全部其他待定
 p
 第几页从1开始
 token
 */
let MESSAGE_LIST = "pp.user.search"


//系统管理员所有产品
/*
 参数：
 token
 */
let PRODUCTS_LIST = "pp.user.all_products"

//管理员展示产品
let MANAGE_PRODUCTS = "pp.user.products"

//删除产品
let PRODUCTS_DELETE = "pp.user.del_products"

//修改
let PRODUCT_EDIT = "pp.user.save_products"

//增加
let PRODUCT_ADD = "pp.user.add_products"
//修改——在线辅导
/*
 参数：
 consult_id
 辅导id
 teacher_id
 老师id
 begintimes
 开始时间时间戳
 consult_minute
 时长
 memo
 备注
 nameLists
 参与辅导人员（）
 */

let CONSULT_SAVE = "sl.project.save_consult"


//添加预约辅导可选择项目(暂定自己的项目)
/*
 参数：
 token
 */
let CONSULT_PRO_LIST = "pp.Consult.consult_pro_list"


//绩效完成率 点击去了解
/*
 参数：
 token
 */
let COMPLETION_RATE_MORE = "pp.index.completion_rate_more"

//部门主管查看本年业绩
/*
 参数：
 token
 */
let TARGET_DEP_FIND = "pp.index.target_dep_find"


//显示自己 本年业绩
/*
 参数：
 token
 */
let TARGET_ONESELF_FIND = "pp.index.target_oneself_find"


//部门主管给自己部门设置 本年业绩
/*
 参数：
 planamount
 业绩金额（万）
 token
 */
let TARGET_DEP_SAVE = "pp.index.target_dep_save"

//自己设置自己 本年业绩
/*
 参数：
 planamount
 业绩金额（万）
 token
 */
let TARGET_ONESELF_SAVE = "pp.index.target_oneself_save"







//MARK: - ---------------------语音相关------------------


//保存录音
/*
  参数：
 type
 类型0线索1商机2项目3辅导4其他
 parallelism_id
 对应的id（其他0）
 parallelism_name
 对应的名字
 file
 录音地址
 token
 
 */
let SAVE_RECORDING = "pp.index.storage_record"



//录音第二层选择
/*
 参数：
 type
 类型0线索1商机2项目3辅导
 token
 
 */
let RECORDING_SECOND_SELECT = "pp.index.record_two_tier"


//录音第一层选择
/*
 参数：
 token
 */
let RECORDING_FIRST_SELECT = "pp.index.record_one_tier"



//展示录音接口
/*
 参数：
 token
 */
let RECORDING_LIST = "pp.index.record_list"

//项目下的相关语音
let record_search_pro = "pp.index.record_search_pro"

//删除保存后的录音
/*
 参数：
 id
 类型录音id
 token
 */
let RECORDING_DELETE = "pp.index.record_del"



//保存录音后面的名字和标签
/*
 参数：
 id
 类型
 intitle
 取的名字
 label
 标签
 token
 */
let RECORDING_MARK_ADD = "pp.index.record_add"





//MARK: - ---------------------项目相关------------------
//项目
let PROJECT_H5 = "main.html#/pro/app"
/*
 2 非必填
 group
 分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
 [text]
 无
 3 非必填
 sort_type
 排序类型（asc 正序desc倒序）
 [text]
 无
 4 非必填
 field
 排序字段(edittime更新时间 create_time创建时间 analyse_update_time分析时间 dealtime完成时间 trade_name行业 name名称 amount金额)
 */
let PROJECT_LISTS = "pp.project.lists"

//项目详情
let PROJECT_DETAIL = "pp.project.project_particulars"

//角色详情信息
let LOGIC_PEOPLE_INFO = "pp.project.logic_people_one"

//添加项目
let PROJECT_ADD_PROJECT = "pp.project.add_projects"

//修改项目信息
let PROJECT_SAVE_PROJECT = "pp.project.save_project"

//删除角色信息
let PROJECT_DEL_PEOPLE = "pp.project.del_people"

//修改观察员
let SAVE_OBSERVER = "pp.project.save_observer"
//修改参与者
let SAVE_PARTNERS = "pp.project.save_partners"
//修改其他联系人
let SAVE_CONTACTS = "pp.project.save_contacts"


//复职项目
let COPY_PROJECT = "pp.project.copy_project"

//项目开单关单
let PROJECT_OPEN_CLOSE = "pp.logicAnalyse.do_project_an"

//项目转移
let PROJECT_TRANSFER = "pp.project.transfer_project"

//项目删除
let PROJECT_DELETE = "pp.project.del_project"

//项目相关辅导
let PROJECT_LIST = "pp.consult.get_project_consult_list"
//获取项目对应聊天
let PROJECT_GROUP = "pp.consult.get_project_group"

//第一次项目分析 展示形势与流程数据
let PROJECT_SHOW_PRO_SPBE = "pp.project.show_pro_spbe"

//添加或修改展示形势与流程
let PROJECT_SAVE_SPBE = "pp.project.save_pro_spbe"

//角色缓存信息
let PARAM_PEOPLE = "pp.project.param_people"

//添加角色
let PROJECT_ADD_PEOPLE = "pp.project.add_people"
//修改
let PROJECT_SAVE_PEOPLE = "pp.project.save_people"

//最后一次修改是否有分析
let EXISTS_PROJECTANALYSE = "pp.logicAnalyse.exists_projectAnalyse"

//项目跟进联系人
let PRO_CONTACTS = "pp.followup.contacts"
//项目跟进提醒人
let PRO_REMIND = "pp.followup.remind_user"
//添加跟进
let Pro_DOADD = "pp.followup.do_add"

//跟进修改
let Pro_DOEdit = "pp.followup.do_edit"
//跟进点赞
let PRO_SUPPORT = "pp.followup.support"
//删除评论
let COMMENT_DEL = "pp.followup.comment_del"
//跟进与我相关的消息
let MY_FOLLOW_MESSAGE = "pp.followup.my_follow_message"

//跟进记录新消息
let FOLLOWUP_RED_POINT = "pp.followup.red_point"

//和我有关的消息
let FOLLOWUP_NEW_MESSAGE_NUM = "pp.followup.new_message_num"





// MARK: - *********** 客户相关 **************

//客户跟进记录右上角的小红点
let CLIENT_RED_POINT = "pp.followup.client_red_point"

//客户-跟进记录-我收到的最新消息数量
let CLIENT_NEW_MESSAGE_NUM = "pp.followup.client_new_message_num"

//客户跟进联系人
let CLIENT_FOLLOWUP_CONTACTS = "pp.followup.client_foadd_contacts"

//客户提醒谁看
let CLIENT_REMIND_USER = "pp.followup.client_remind_user"

//客户跟进记录新增
let ClIENT_FOLLOWUP_ADD = "pp.followup.client_followup_add"

//客户 联系人  跟进记录修改
let CLIENT_CONTACT_FOLLOWUP_EDIT = "pp.followup.do_edit"

//客户与我相关的消息
let CLIENT_MY_FOLLOW_MESSAGE = "pp.followup.client_my_follow_message"


//跟进记录添加
let FOLLOWUP_FO_ADD = "pp.followup.fo_add"


// MARK: - *********** 联系人相关 **************

//联系人提醒谁看
let CONTACT_REMIND_USER = "pp.followup.contact_remind_user"


//联系人-与我相关的消息
let QF_contact_followup_message = "pp.followup.contact_my_follow_message";
//联系人-跟进记录-我收到的最新消息数量
let QF_contact_newMessage_num = "pp.followup.contact_new_message_num";
//联系人-跟进按钮右上角的小红点
let QF_contact_red_point = "pp.followup.contact_red_point";
//联系人-跟进记录列表
let QF_contact_followup = "pp.followup.contact_followup";
//联系人-添加跟进记录
let QF_contact_add_followup = "pp.followup.contact_followup_add";

//联系人相关的项目
let QF_contact_projectlist = "pp.clientContact.contact_project"



// MARK: - *********** 跟进统一接口  **************
//跟进记录-添加-项目列表-统一
let FOLLOWUP_CONTACT_LIST = "pp.followup.contact_list"
//跟进记录-添加-提醒谁看列表-统一
let FOLLOWUP_REMIND_USER_LIST = "pp.followup.remind_user_list"
let new_follow_up_remind_user_list = "pp.member.dep_member_all_list"
//跟进记录-添加-联系人列表-统一
let FOLLOWUP_PROJECT_LIST = "pp.followup.project_list"



// MARK: - -----------------------分析------------------------

//本次分析展示
let LOGICANALYSE = "pp.logicAnalyse.index"

//项目下所有角色信息
let LOGIC_PEOPLE_LIST = "pp.project.logic_people_list"

//展示该项目历史所有分析
let LOGICANALYSE_LIST = "pp.logicAnalyse.logicList"
//角色雷达
let LOGICANALYSE_ROLERADAR = "pp.logicAnalyse.roleRadar"
//赢单指数分析
let LOGICANALYSE_WININDEX = "pp.logicAnalyse.winindex"
//项目角色策略建议
let LOGICANALYSE_GETPLANSUGGESTION = "pp.logicAnalyse.get_planSuggestion"

//该角色可以选择的上级
let PEOPLE_PARENT = "pp.project.people_parent"

// MARK: - *********** 行动计划相关 **************
//行动计划列表
let LIST_ACTION_PLAN = "pp.logicAnalyse.list_action_plan"
//添加行动计划
let ADD_ACTION_PLAN = "pp.logicAnalyse.add_action_plan"
//修改行动计划
let SAVE_ACTION_PLAN = "pp.logicAnalyse.save_action_plan"
//删除行动计划
let DEL_ACTION_PLAN = "pp.logicAnalyse.del_action_plan"
//行动计划展示星级
let ACTION_PLAN_STAR = "pp.logicAnalyse.action_plan_star"
//完成行动计划和打开行动计划
let ACHIEVE_ACTION_PLAN = "pp.logicAnalyse.achieve_action_plan"
//行动计划详情
let ACTION_PLAN_ONE = "pp.logicAnalyse.action_plan_one"
//行动计划选择角色
let ACTION_PLAN_PEOPLE = "pp.logicAnalyse.action_plan_people"


//获得线索
let GETCLUELIST = "pp.Clue.getClueList"

//MARK: - ---------------------辅导相关------------------
//项目
let CONSULT_LIST = "pp.consult.consult_list"
//预约结束辅导人给老师打分
let CONSULT_TEACHER_SCORE = "pp.consult.teacher_score"//consult_id 辅导的id, teacher_id 老师的id, fen 分数, value 选择内容(json数组),other_value 其他内容, token
//其他人对导师的评语
let CONSULT_TEACHER_VALUE = "pp.consult.teacher_value" //teacher_id  token

//本部门人员
let MEMBER_LIST = "pp.member.member_list"

//辅导老师
let CONSULT_TEACHER = "pp.member.search_teacher"

//预约辅导
let ADD_CONSULT = "pp.consult.add_consult"
//修改辅导
let SAVE_CONSULT = "pp.consult.save_consult"
//搜索本公司人员
let SEARCH_MEMBER  = "pp.member.search_member"
//-----------------------其他----------------------
//MARK:----------------------群组相关----------------------

let group_Create = "tcp.group.create"   //创建群组
let group_Update = "tcp.group.update"   //修改群组
let group_SetOpen = "tcp.group.set_open" //设置群组是否开放
let group_Quit = "tcp.group.quit"       //退出群组
let group_Dismiss = "tcp.group.dismiss"  //解散群组
let group_UserList = "tcp.group.userList"  //群组成员
let group_DelUser = "tcp.group.del_user"  //删除群组成员
let group_MyGroupList = "tcp.group.myGroupList"  //获取加入的群组信息
let group_GetUserByIds = "tcp.group.getUserByIds"  //访问服务端获取用户信息
let group_Search = "tcp.group.search"  //搜索群组
let group_SetTop = "tcp.group.setTop"  //置顶
let group_Info = "tcp.group.info"  //获取群组信息
//let group_InviteUser = "tcp.group.invite"  //邀请加入群

let group_InviteUser = "tcp.group.cloud_coach_invite"
let group_AcceptInvite = "tcp.group.accept"  //接收邀请加入
let group_RequestJoin = "tcp.group.requestJoin"  //主动加入
let group_JoinByQr = "tcp.group.join_by_qr"  //二维码加入
let group_JoinApply = "tcp.group.join_apply"  //入群申请
let group_JoinApplyAudit = "tcp.group.join_audit"  //批准入群申请
let group_JoinByCode = "tcp.group.join_by_code"  //使用验证码加入群
let group_Qr_code   = "tcp.group.qr_code"  //获取二维码
let group_JoinPublicGroup   = "tcp.group.join_public_group"  //加入公共群组

//项目分析报告信息
let project_analyse_report_info = "tcp.consult.project_analyse_report_info"

//获取导师的辅导列表
let tcp_project_list = "tcp.consult.teacher_doing_consult_project_list"

//MARK:----------------------话题相关----------------------

let group_SubjectList = "tcp.group.subject_list" //话题列表
let group_Create_subject = "tcp.group.create_subject" //创建话题
let group_Quit_subject = "tcp.group.quit_subject" //退出话题
let group_Subject_info = "tcp.group.subject_info" //话题信息
let group_Join_subject = "tcp.group.join_subject" //加入话题
let group_Finish_Online_Consult = "tcp.group.finish_online_consult" //结束辅导
let group_Update_subject = "tcp.group.update_subject" //修改话题
let group_Dismiss_subject = "tcp.group.dismiss_subject" //解散话题
let group_Forward_Subject = "tcp.group.forward_group_msg"//转推组群
let group_Subject_msg_history = "tcp.group.subject_msg_history"//查看话题历史记录

//云教练获取部门人员
let coach_search_user = "tcp.im.cloud_coach_search_user"
//MARK:----------------------用户管理相关----------------------




let im_GetToken = "tcp.im.get_token"  //获取token
let im_InitData = "tcp.im.sync"  //初始化数据
let im_UserInfo = "tcp.im.user_info"  //获取用户信息
let im_UserList = "tcp.im.user_list"  //获取多个用户信息
//let im_Friends = "tcp.im.friends"  //获取好友列表
//云教练替换好友  为 tcp.im.cloud_coach_search_user
let im_Friends = "tcp.im.cloud_coach_search_user"
let im_Search_user = "tcp.im.search_user"  //查找用户
let im_Withdraw_message = "tcp.im.withdraw_message"  //撤回消息

//MARK: ----------------------公海池----------------------
let CUSTOM_POOL_LIST = "pp.client.client_international_waters_list"
let CUSTOM_POOL_LIST_ALLOC_GET = "pp.client.allot_client"
let CUSTOM_POOL_LIST_DELETE = "pp.client.del_client"



// MARK: - *********** 拜访相关 **************

let CUSTOM_POOL_RECYCLE_LIST = "pp.client.recover_client_international_waters_list"
let CUSTOM_POOL_RECYCLE_RESUME = "pp.client.recover_clients"
//拜访列表
let kVisit_list = "pp.visit.getList"

let CUSTOM_POOL_CREATE_CUSTOM = "pp.client.client_international_waters_add"
//客户  联系人  项目的拜访列表
let kotherVisit_list = "pp.visit.getRelList"
let CUSTOM_POOL_CREATE_PRIVATE_CUSTOM = "pp.client.client_private_add"
let CUSTOM_POOL_CREATE_BELONG = "pp.client.get_client_gonghai"
let CUSTOM_POOL_CREATE_UPDATE = "pp.client.client_international_waters_save"
let CUSTOM_POOL_CREATE_PRIVATE_UPDATE = "pp.client.client_private_save"

let CUSTOM_POOL_CUSTOM_DETAIL = "pp.client.client_id_value"
let CUSTOM_POOL_CUSTOM_DETAIL_CONTACT = "pp.contact.client_all_contact"
let CUSTOM_POOL_CUSTOM_DETAIL_PARTICIPANT = "pp.client.client_participant"

let CUSTOM_POOL_CUSTOM_DETAIL_CONTACT_DELETE = "pp.clientContact.del_client_contact_ids"

let CUSTOM_POOL_CUSTOM_DETAIL_SEND_BACK = "pp.client.send_back_client"
let CUSTOM_POOL_CUSTOM_DETAIL_BEFORE_SEND_BACK = "pp.client.send_back_client_before"

let CUSTOM_POOL_PRIVATE_LIST = "pp.clientContact.client"

let CUSTOM_POOL_PAGE_PRIVATE_LIST = "pp.clientContact.sorted_content_client_2019_February_change"

let CUSTOM_POOL_MERGE_LIST = "pp.client.client_principal_list"
let CUSTOM_POOL_MERGE_GET_INFO = "pp.client.merge_client"

let CUSTOM_POOL_MERGE_SEND_MERGE = "pp.client.merge_client_do"

let CUSTOM_POOL_CREATE_CONTACT_ADD = "pp.contact.contact_international_waters_add_judge"
let CUSTOM_POOL_CREATE_CONTACT_ADD_PRIVATE = "pp.contact.contact_private_add_judge"

//项目结转
let PROJECY_PROJECT_SETTING_SAVE = "pp.project.settings_pro_save"
