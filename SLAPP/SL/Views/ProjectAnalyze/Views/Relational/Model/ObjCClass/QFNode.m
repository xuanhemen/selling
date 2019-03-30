//
//  QFNode.m
//  SwiftStudy
//
//  Created by qwp on 2018/4/14.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

#import "QFNode.h"


@interface QFNode(){
    
    
}

@end
@implementation QFNode

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict!=nil) {
            self.name = dict[@"name"];
            self.subDicts = dict[@"node"];
            self.dict = dict[@"dict"];
            [self configNodes:self];
        }
    }
    return self;
}

#pragma mark - 返回值
- (NSString *)nodeId{
    return self.dict[@"id"];
}
- (NSString *)nodeName{
    NSString *name = self.name;
    if (self.dict[@"name"]&&[self.dict[@"id"] integerValue]!=-1) {
        name = self.dict[@"name"];
    }
    return name;
}
- (NSString *)nodeBackgroundColor{
    
    NSString *colorStr = @"#FFFFFF";
    if (self.dict[@"name"]&&[self.dict[@"id"] integerValue]!=-1) {
        colorStr = self.dict[@"circle_color"];
    }
    return colorStr;
}
- (NSString *)nodeColor{
    NSString *colorStr = @"#FFFFFF";
    if (self.dict[@"name"]&&[self.dict[@"id"] integerValue]!=-1) {
        colorStr = self.dict[@"circle_color_val"];
    }
    return colorStr;
}

-(void)configNodes:(QFNode*)fatherNode{
    if (fatherNode.subDicts.count>0) {
        NSMutableArray *nodesArr = [NSMutableArray array];
        for (int i=0; i<fatherNode.subDicts.count; i++) {
            NSDictionary *dict = fatherNode.subDicts[i];
            NSArray *array = dict[@"node"];
            QFNode *node = [[QFNode alloc]init];
            node.fatherNode = fatherNode;
            node.subDicts = array;
            node.name = dict[@"name"];
            node.dict = dict[@"dict"];
            [nodesArr addObject:node];
            [self configNodes:node];
        }
        fatherNode.subNodes = nodesArr;
    }
}



- (id <PSTreeGraphModelNode> ) parentModelNode
{
    return self.fatherNode;
}

- (NSArray *) childModelNodes
{
    if (self.subNodes == nil) {
        self.subNodes = @[];
    }
    return self.subNodes;
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

@end
