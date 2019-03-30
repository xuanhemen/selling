//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"
#import "Emoji/Emoji.h"
@implementation FaceSourceManager

//加载表情源
+ (NSArray *)loadFaceSource
{
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"表情_normal",@"小花_normal",@"铃铛_normal",@"car_normal"];
    NSArray *sources_select = @[@"表情_select",@"小花_select",@"铃铛_select",@"car_select"];

    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr addObject:[Emoji allEmoticons]];
    [tempArr addObject:[Emoji allPictographs]];
    [tempArr addObject:[Emoji allMapSymbols]];
    [tempArr addObject:[Emoji allTransport]];
    
    for (int i = 0; i < sources.count; ++i)
    {
        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
        themeM.themeDecribe = sources_select[i];
        themeM.themeIcon = sources[i];
        NSMutableArray *modelsArr = [NSMutableArray array];
        for (int j = 0; j < [tempArr[i] count]; j++) {
            NSString *name = tempArr[i][j];
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = name;
            [modelsArr addObject:fm];
        }

        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    
    return subjectArray;
}


@end
