//
//  ContactTableViewCell.h
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPerson;

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) LJPerson *model;

@end
