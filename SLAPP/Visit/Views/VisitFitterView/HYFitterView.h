//
//  HYFitterView.h
//  SLAPP
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYFitterView;

@protocol HYFitterViewDelegate<NSObject>

/**
 筛选操作

 @param fitter <#fitter description#>
 @param result <#result description#>
 */
- (void)fitter:(HYFitterView *)fitter AndResultArray:(NSArray *)result isCancel:(BOOL)isCancel;



@end
@interface HYFitterView : UIView
@property(nonatomic,strong)NSArray *allData;
@property(nonatomic,assign)id<HYFitterViewDelegate> delegate;
/**
 配置已经选择的项
 
 @param array <#array description#>
 */
-(void)configAlready:(NSArray *)array;
@end
