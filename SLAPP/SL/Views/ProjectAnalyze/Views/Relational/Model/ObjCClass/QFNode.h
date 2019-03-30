//
//  QFNode.h
//  SwiftStudy
//
//  Created by qwp on 2018/4/14.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSTreeGraphModelNode.h"

@interface QFNode : NSObject<PSTreeGraphModelNode, NSCopying>

@property (nonatomic,strong) QFNode  *fatherNode;
@property (nonatomic,strong) NSArray *subNodes;
@property (nonatomic,strong) NSArray *subDicts;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSDictionary *dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

- (NSString *)nodeId;
- (NSString *)nodeName;
- (NSString *)nodeBackgroundColor;
- (NSString *)nodeColor;
@end
