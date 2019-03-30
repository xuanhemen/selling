//
//  SLTimeSelectorView.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///**传递时间*/
//typedef void(^passTime)(NSString *time);

@interface SLTimeSelectorView : UIControl<UIPickerViewDelegate,UIPickerViewDataSource>

/**显示时间*/
@property(nonatomic)UIPickerView *pickView;
/**取消*/
@property(nonatomic)UIButton *cancelBtn;
/**确定*/
@property(nonatomic)UIButton *sureBtn;
/**数据源*/
@property(nonatomic)NSMutableArray *dataArr;
/**标识*/
@property(nonatomic,copy)NSString * style;
/**block回调*/
@property(nonatomic,copy)void(^passTime)(NSString *time,NSString *style);

@end

NS_ASSUME_NONNULL_END
