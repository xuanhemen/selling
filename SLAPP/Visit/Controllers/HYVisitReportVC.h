//
//  HYVisitReportVC.h
//  SLAPP
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseVC.h"

@interface HYVisitReportVC : HYBaseVC
@property(nonatomic,strong)NSString *visitId;
// 0 装备报告   1总结报告
@property(nonatomic,strong)NSString *type;
@end
