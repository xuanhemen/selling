//
//  HYReservationVC.h
//  SLAPP
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseVC.h"

@interface HYReservationVC : HYBaseVC
@property(nonatomic,strong)NSString *visitId;
@property(nonatomic,assign)BOOL isPopToRoot;
//是否是预约
@property(nonatomic,assign)BOOL isReservation;
@end
