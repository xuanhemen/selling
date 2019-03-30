//
//  HYBoltingCell.h
//  SLAPP
//
//  Created by apple on 2019/1/30.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYBoltingCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *content;

//是否选中
-(void)selectWithStatus:(BOOL)status;
@end

NS_ASSUME_NONNULL_END
