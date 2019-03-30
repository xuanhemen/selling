//
//  SLScheduleCell.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic)UILabel *title;

@property(nonatomic)UITextField *content;

@property(nonatomic)UITextView *textView;

@property(nonatomic)UILabel *placeHoler;
@end

NS_ASSUME_NONNULL_END
