//
//  SLUrlHeader.h
//  SLAPP
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#ifndef SLUrlHeader_h
#define SLUrlHeader_h


#pragma mark- 📚 ***********  **************

#pragma mark- 📚 *********** 日程 **************
//日程的部门与人员
#define kScheduleDepMember @"pp.schedule.schedule_dep_member"

//日程——通过部门或人员id或标题 查询该部门或人员或标题的数据
#define kScheduleDepMemberList   @"pp.schedule.schedule_dep_member_list"

//获取  日程 部门及人员
#define kScheduleDepMember @"pp.schedule.schedule_dep_member"

//搜索日程的列表接口
#define kSearchScheduleList @"pp.schedule.schedule_query_list"
//客户私海
#define kMyClientPoolList  @"pp.clientContact.client"

//根据标题搜索日程
#define kSearchSchedule @"pp.schedule.schedule_dep_member_list"


#pragma mark- 📚 *********** 拜访相关  **************

//根据拜访id获取拜访列表
#define kGetIdsList @"pp.visit.getIdsList"

//目标制定
#define kSaveVisitRoleSituation @"pp.visit.saveVisitRoleSituation"

//现状分析与目标制定
#define kVisitRoleSituation @"pp.visit.visitRoleSituation"


//获取拜访基本信息--修改用
#define kGetVisitBase @"pp.visit.getVisitBase"

//拜访评论回复记录删除
#define kVisitDelegateReply @"pp.visit.deleteVisitReply"

//拜访评论记录删除
#define kVisitDelegateComment @"pp.visit.deleteVisitComment"

//拜访评论点赞列表
#define kVisitCommentPraiseList @"pp.visit.visitCommentPraiseList"

//拜访评论点赞或取消点赞
#define kPraiseVisitComment @"pp.visit.praiseVisitComment"

//拜访评论回复点赞或取消点赞
#define kPraiseVisitReply @"pp.visit.praiseVisitReply"

//新增拜访评论回复
#define kAddCommentReply @"pp.visit.addCommentReply"

//拜访评论详情
#define kVisitCommentDetail  @"pp.visit.visitCommentDetail"

//评论列表相关
#define kVisitCommentList @"pp.visit.visitCommentList"

//新增拜访评论
#define kAddVisitComment @"pp.visit.addVisitComment"

//拜访筛选
#define kQueryConditon  @"pp.visit.getQueryConditon"

//更新个人邮箱设置
#define kVisit_UpdateUserMail @"pp.visit.updateUserMail"

//发送邮件
#define kVisit_SendMail  @"pp.visit.sendMail"

//发送邮箱设置
#define kVisit_SendType @"pp.visit.sendType"


#define kVisit_Template @"pp.visit.getTemplate"

//删除拜访
#define kVisit_delete @"pp.visit.delete"
//重新打开
#define kVisit_reOpen @"pp.visit.reOpenVisit"

//删除拜访报告
#define kDel_VisitReport  @"pp.visit.delVisitReport"

//生成拜访报告
#define kCreat_VisitReport  @"pp.visit.createVisitReport"

//获取报告
#define kGet_visitReport  @"pp.visit.getVisitReport"

//新增 修改 拜访准备信息
#define kUpdate_visitReady @"pp.visit.updateVisitReady"


//修改拜访基本信息
#define kUpdate_visitBase @"pp.visit.updateVistBase"

//新增拜访基本信息
#define kAdd_visitBase @"pp.visit.addVisitBase"

//拜访列表
#define kVisit_list @"pp.visit.getList"
//拜访准备信息
#define kLook_visit_ready @"pp.visit.lookVisitReady"

//拜访基本信息
#define kgetVisitReadyBase  @"pp.visit.getVisitReadyBase"

//获取拜访总结
#define kGetVisitSummary @"pp.visit.getVisitSummary"
//获取拜访评估题
#define kGetEvaluation @"pp.visit.visitCompleteEvaluation"

//获取答题详情
#define kGetEvaluationSelect @"pp.visit.visitRadar"

//提交问卷
#define kAddEvaluate @"pp.visit.AddUpdateVisitEvaluate"
//提交拜访总结
#define kUpdateSummary @"pp.visit.updateVisitSummary"


// MARK: - *********** 新首页 **************

//新首页
#define kurl_home_new   @"pp.index.type_quantity"

//是否显示结转
#define kIsShowWhether_Carrpy_down @"pp.project.whether_carry_down"

//项目列表
#define kPro_lists @"pp.project.pro_lists"

// MARK: - *********** 工作台 **************

//能结转的项目
#define kProjectSetting  @"pp.project.settings_pro_list"

//批量结转项目或结转有权限的全部项目
#define kProjectSettingSave @"pp.project.settings_pro_save"





// MARK: - ***********商机统计与分析**************
//商机统计
#define p_business_statistics @"pp.projectStatistics.business_statistics"
//瓶颈分析
#define p_bottleneck_analysis @"pp.projectStatistics.bottleneck_analysis"
//传项目数据反排序后的内容
#define p_sorted_content  @"pp.projectStatistics.sorted_content"
//风险分析
#define p_risk_analysis @"pp.projectStatistics.risk_analysis"
//项目销售漏斗
#define p_project_funnel  @"pp.projectStatistics.project_funnel"
//商机排行
#define p_business_ranking  @"pp.projectStatistics.business_ranking"


//历史分析趋势图
#define p_historical @"pp.logicAnalyse.historical_trend_map"

// MARK: - ***********  **************


//static NSString *aa = @"pp.projectStatistics.business_statistics";
//static NSString *aa = @"pp.projectStatistics.business_statistics";
//static NSString *aa = @"pp.projectStatistics.business_statistics";
//static NSString *aa = @"pp.projectStatistics.business_statistics";
//static NSString *aa = @"pp.projectStatistics.business_statistics";

#endif /* SLUrlHeader_h */
