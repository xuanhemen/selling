//
//  SLConversion.h
//  SLAPP
//
//  Created by 董建伟 on 2019/1/14.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReleClicked)(int);
@interface SLConversion : NSObject

/** <#annotation#> */
@property(nonatomic,copy)ReleClicked releClick;

-(NSMutableAttributedString *)conversion:(NSString *)string andReleName:(NSString *)name reply:(NSString *)replyName;
@end
