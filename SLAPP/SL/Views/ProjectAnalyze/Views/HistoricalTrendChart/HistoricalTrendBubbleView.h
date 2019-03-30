//
//  HistoricalTrendBubbleView.h
//  SLAPP
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricalTrendBubbleView : UIView
@property(nonatomic,strong)NSDictionary *dataArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UILabel *labTitle;
@end
