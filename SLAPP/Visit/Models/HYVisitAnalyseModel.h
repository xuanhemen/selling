//
//  HYVisitAnalyseModel.h
//  SLAPP
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYVisitAnalyseModel : NSObject
@property(nonatomic,strong)NSArray *coach;
@property(nonatomic,strong)NSArray *contact_info;
@property(nonatomic,strong)NSArray *engagement;
@property(nonatomic,strong)NSArray *feedback;
@property(nonatomic,strong)NSArray *orgresult;
@property(nonatomic,strong)NSArray *personalwin;
@property(nonatomic,strong)NSArray *support;
@end

//角色
@interface HYVisitAnalyseContactInfoModel : NSObject

@property(nonatomic,copy)NSString *coach;
@property(nonatomic,copy)NSString *coachname;
@property(nonatomic,copy)NSString *contact_id;
@property(nonatomic,copy)NSString *engagement;
@property(nonatomic,copy)NSString *engagementname;
@property(nonatomic,copy)NSString *feedback;
@property(nonatomic,copy)NSString *feedbackname;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *orgresult;
@property(nonatomic,copy)NSString *orgresultname;
@property(nonatomic,copy)NSString *personalwin;
@property(nonatomic,copy)NSString *personalwinname;
@property(nonatomic,copy)NSString *support;
@property(nonatomic,copy)NSString *supportname;
@end


//选项
@interface HYVisitAnalyseSubModel : NSObject
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@end
