//
//  CallContact.m
//  TimerNavigation
//
//  Created by qwp on 2017/5/8.
//  Copyright © 2017年 祁伟鹏. All rights reserved.
//

#import "CallContact.h"
#import "ZCAddressBook.h"
#import "PinyinContrast.h"

@implementation CallContact
//获取通讯录列表，返回数组[@{@"fullname":@"张三",@"phone":@"10086"},@{}......]
+ (NSArray *)fetchContact{
    NSDictionary *infoDic= [[ZCAddressBook shareControl]getPersonInfo];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *key in infoDic) {
        NSArray *subArr = [infoDic objectForKey:key];
        [array addObjectsFromArray:subArr];
    }
    NSMutableArray *uploadArr = [NSMutableArray array];
    for (NSDictionary *subDict in array) {
        NSDictionary *uploadDict = @{@"fullname":subDict[@"name"],
                                     @"phone":subDict[@"telphone"]
                                     };
        [uploadArr addObject:uploadDict];
    }
    return uploadArr;
    
}
/** ① **/
//打电话给toSting 已toString为关键词进行索引，入口
+ (NSArray *)callToString:(NSString *)toString{
    //去标点
    if ([toString rangeOfString:@"。"].length>0) {
        toString = [toString stringByReplacingOccurrencesOfString:@"。" withString:@""];
    }
    
    //转拼音
    NSString *pinyinString = [self transform:toString];
    NSArray *contactArr = [self fetchContact];//获取通讯录数组
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (contactArr.isNotEmpty) {
        for (NSDictionary *dict in contactArr) {
            NSString *nameString = [self transform:dict[@"fullname"]];
            if ([dict[@"fullname"] rangeOfString:toString].length>0) {
                [resultArray addObject:@{
                                         @"base":toString,
                                         @"fullname":dict[@"fullname"],
                                         @"phone":dict[@"phone"],
                                         @"pinyin":nameString,
                                         @"searchPinyin":pinyinString,
                                         @"score":[self scoreWithPinyin:nameString andsearchPinyin:pinyinString andFullName:dict[@"fullname"] andToString:toString]
                                         }];
            }else if ([[self abbreviationWithName:nameString] rangeOfString:[self abbreviationWithName:pinyinString]].length>0) {
/** ② **/
                /*遍历数组，取出字典联系人转换为拼音，通过abbreviationWithName方法 将拼音转换为韵母，判段联系人韵母是否包含关键字韵母，如果包含则实例新的 字典 加入数组resultArray*/
                [resultArray addObject:@{
                                        @"base":toString,
                                        @"fullname":dict[@"fullname"],
                                        @"phone":dict[@"phone"],
                                        @"pinyin":nameString,
                                        @"searchPinyin":pinyinString,
                                        @"score":[self scoreWithPinyin:nameString andsearchPinyin:pinyinString andFullName:dict[@"fullname"] andToString:toString]
                                         }];
            }
        }
    }
    
    NSArray *retArray;
    retArray = resultArray;
    if (resultArray.count>0) {
/** ③ **/
//去掉发音不相符的元素
        retArray = [self removeWithContacts:resultArray];
        if (retArray.count>0) {
/** ④ **/
//对剩下的数组按照分值进行排序
            retArray = [self sortWithContacts:retArray];
        }
    }
/** ⑤ **/
//反向搜索加入数组
    NSMutableArray *backArr = [NSMutableArray arrayWithArray:retArray];
    for (NSDictionary *dict in contactArr) {
        if ([toString rangeOfString:dict[@"fullname"]].location>0) {
            [backArr addObject:@{
                                @"base":toString,
                                @"fullname":dict[@"fullname"],
                                @"phone":dict[@"phone"],
                                @"pinyin":[self transform:dict[@"fullname"]],
                                @"searchPinyin":[self transform:toString],
                                @"score":@"10"}];
        }
    }
    
//得到匹配到的联系人列表
    return retArray;

}

+ (NSString *)scoreWithPinyin:(NSString *)pingyin andsearchPinyin:(NSString *)searchPinyin andFullName:(NSString *)fullName andToString:(NSString *)toStr{
    NSInteger score = 0;
    if ([fullName isEqualToString:toStr]) {
        score+=5000;
    }
    if ([fullName rangeOfString:toStr].length>0) {
        score+=500;
    }
    if ([toStr rangeOfString:fullName].length>0) {
        score+=500;
    }
    if ([pingyin isEqualToString:searchPinyin]) {
        score += 5000;
    }
    if (pingyin.length == searchPinyin.length) {
        score += 90;
    }
    NSArray *pinyinArray = [pingyin componentsSeparatedByString:@" "];
    NSArray *searchPinyinArray = [searchPinyin componentsSeparatedByString:@" "];
    if (pinyinArray.count == searchPinyinArray.count) {
        score += 200;
    }else if (pinyinArray.count == searchPinyinArray.count+1){
        score += 100;
    }else if (pinyinArray.count == searchPinyinArray.count+2){
        score += 50;
    }
    
    if ([pingyin rangeOfString:searchPinyin].length>0) {
        score += 200;
    }
    for (int i=0;i<searchPinyinArray.count;i++) {
        NSString *seaStr = searchPinyinArray[i];
        NSString *pyStr = pinyinArray[i];
        if ([pyStr isEqualToString:seaStr]) {
            score+=300;
        }else{
            for (int j=0; j<pinyinArray.count; j++) {
                NSString *pin = pinyinArray[j];
                if ([pin isEqualToString:seaStr]) {
                    score+=180;
                }else{
                    if (([pin rangeOfString:@"ZH"].length>0||[pin rangeOfString:@"CH"].length>0||[pin rangeOfString:@"SH"].length>0)&&([seaStr rangeOfString:@"Z"].length>0||[seaStr rangeOfString:@"C"].length>0||[seaStr rangeOfString:@"S"].length>0)) {
                        score+=80;
                    }
                    if (([pin rangeOfString:@"ANG"].length>0||[pin rangeOfString:@"ENG"].length>0||[pin rangeOfString:@"ING"].length>0)&&([seaStr rangeOfString:@"AN"].length>0||[seaStr rangeOfString:@"EN"].length>0||[seaStr rangeOfString:@"IN"].length>0)) {
                        score+=80;
                    }

                    if (([pin hasPrefix:@"L"]||[pin hasPrefix:@"N"]||[pin hasPrefix:@"R"])&&([seaStr hasPrefix:@"L"]||[seaStr hasPrefix:@"N"]||[seaStr hasPrefix:@"R"])) {
                        score+=100;
                    }
                    
                    if (([pin hasPrefix:@"Q"]||[pin hasPrefix:@"J"]||[pin hasPrefix:@"X"])&&([seaStr hasPrefix:@"Q"]||[seaStr hasPrefix:@"J"]||[seaStr hasPrefix:@"X"])) {
                        score+=50;
                    }
                    
                    if (([pin hasPrefix:@"F"]||[pin hasPrefix:@"H"])&&([seaStr hasPrefix:@"F"]||[seaStr hasPrefix:@"H"])) {
                        score+=90;
                    }
                    if (([pin hasPrefix:@"G"]||[pin hasPrefix:@"K"])&&([seaStr hasPrefix:@"G"]||[seaStr hasPrefix:@"K"])) {
                        score+=30;
                    }
                    if (([pin hasPrefix:@"T"]||[pin hasPrefix:@"D"]||[pin hasPrefix:@"F"]||[pin hasPrefix:@"B"]||[pin hasPrefix:@"P"]||[pin hasPrefix:@"M"])&&([pin hasPrefix:@"T"]||[pin hasPrefix:@"D"]||[pin hasPrefix:@"F"]||[seaStr hasPrefix:@"B"]||[seaStr hasPrefix:@"M"]||[seaStr hasPrefix:@"P"])) {
                        score+=50;
                    }
                    
                }
            }
        }
        
    }
    return [NSString stringWithFormat:@"%ld",score];
}
//删除发音不相符的联系人
+ (NSArray *)removeWithContacts:(NSArray *)array{
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
/* 
 *1、遍历数组，得到关键词的韵母，以及联系人的韵母
 *在得到的韵母前加“|”  如：I|EN| 变为 |I|EN|
 *重新判断包含关系  去除之前因为 EI|EN|包含I|EN|而加入数组的元素
 */
        NSString *pinyStr = [NSString stringWithFormat:@"|%@",[self abbreviationWithName:dict[@"pinyin"]]];
        NSString *searchStr = [NSString stringWithFormat:@"|%@",[self abbreviationWithName:dict[@"searchPinyin"]]];
        if ([pinyStr rangeOfString:searchStr].length>0) {
            
            NSString *newSearchString = [searchStr substringWithRange:NSMakeRange(1, searchStr.length-2)];
            NSArray *searchArray = [newSearchString componentsSeparatedByString:@"|"];
            NSString *newPinyinStr = [pinyStr stringByReplacingOccurrencesOfString:searchStr withString:@"*"];
            
            NSRange range = [pinyStr rangeOfString:searchStr];
/*
*2、判断关键字长度，如果关键字长度为1，则只做汉字包含
*/
            if (searchArray.count == 1) {
                if ([dict[@"fullname"] rangeOfString:dict[@"base"]].length>0) {
                    [retArray addObject:dict];
                }else if ([dict[@"pinyin"] isEqualToString:dict[@"searchPinyin"]]) {
                    [retArray addObject:dict];
                }
            }else{
/*
*2、获取关键字 对应联系人名字中的位置 如  "张三" 在“张山丰”中的位置{0，2}
*  在联系人中 取出关键字对应的字  如：“张山”
*/
                NSArray *arr = [dict[@"pinyin"] componentsSeparatedByString:@" "];
                NSMutableArray *pyArr = [NSMutableArray array];
                if (range.location == 0) {
                    for (int i=0; i<searchArray.count; i++) {
                        [pyArr addObject:arr[i]];
                    }
                }else{
                    newPinyinStr = [newPinyinStr substringWithRange:NSMakeRange(1, newPinyinStr.length-2)];
                    NSString *firstStr = [[newPinyinStr componentsSeparatedByString:@"*"] firstObject];
                    NSInteger firstcount = [firstStr componentsSeparatedByString:@"|"].count;
                    for (int i=0; i<searchArray.count; i++) {
                        [pyArr addObject:arr[i+firstcount]];
                    }
                }
/**
 * 3、判断  “张山” 与 “张三” 是否相似 
 * 使用PinyinContrast类中的contrastWithStringA:andStringB:方法
 */
                BOOL isSame = [PinyinContrast contrastWithStringA:dict[@"searchPinyin"] andStringB:[pyArr componentsJoinedByString:@" "]];
                if (isSame) {
                    [retArray addObject:dict];
                }
            }
        }
    }
    return retArray;
}
//根据分数 冒泡排序
+ (NSArray *)sortWithContacts:(NSArray *)array{
    NSMutableArray *retArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < retArray.count; ++i) {
        for (int j = 0; j < retArray.count-1; ++j) {
            if ([self compareWithA:retArray[j] andB:retArray[j+1]]) {
                [retArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return retArray;
}
+ (BOOL)compareWithA:(id)objectA andB:(id)objectB{
    NSDictionary *dict1 = objectA;
    NSDictionary *dict2 = objectB;
    NSString *pinyin1 = dict1[@"score"];
    NSString *pinyin2 = dict2[@"score"];
    if ([pinyin1 integerValue]<[pinyin2 integerValue]) {
        return YES;
    }else{
        return NO;
    }
}

//去掉拼音声母
+ (NSString *)abbreviationWithName:(NSString *)nameString{
    NSArray *array = [nameString componentsSeparatedByString:@" "];
    NSArray *shenmuArr = @[@"B",@"M",@"F",@"D",@"P",@"T",@"L",@"K",@"J",@"Q",@"X",@"ZH",@"CH",@"SH",@"R",@"Z",@"C",@"S",@"Y",@"W",@"H"];
    NSMutableString *retString = [[NSMutableString alloc] init];
    //第一步：拼音中如果包含 shenmuArr 数组中的字符串 则去掉 不包含“N” “N”单独处理
    for (NSString *string in array) {
        NSString *newString = string;
        for (NSString *shengmuString in shenmuArr) {
            if ([newString rangeOfString:shengmuString].length>0) {
                    newString = [newString stringByReplacingOccurrencesOfString:shengmuString withString:@""];
            }
        }
    //第一步：如果拼音已“N”开头，则去掉字符“N”
        if ([string hasPrefix:@"N"]||[string hasPrefix:@"G"]) {
            newString = [newString substringFromIndex:1];
        }
        [retString appendFormat:@"%@|",newString];
    }
    //NSLog(@"韵母 -- %@",retString);
    return retString;
}

//汉字转拼音  转拼音时对 U Ü 进行特殊处理
+ (NSString *)transform:(NSString *)chinese{
    NSMutableArray *muttArray = [[NSMutableArray alloc] init];
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSString *baseString = [pinyin uppercaseString];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSString *retString = [pinyin uppercaseString];
    if ([retString rangeOfString:@"LU"].length>0||[retString rangeOfString:@"NU"].length>0) {
        NSArray *baseArray = [baseString componentsSeparatedByString:@" "];
        NSArray *retArray = [retString componentsSeparatedByString:@" "];
        for (int i=0; i<retArray.count; i++) {
            NSString *string = retArray[i];
            if ([string isEqualToString:@"LU"]||[string isEqualToString:@"NU"]) {
                [muttArray addObject:baseArray[i]];
            }else{
                [muttArray addObject:string];
            }
        }
        retString = [muttArray componentsJoinedByString:@" "];
    }
    
    if ([retString rangeOfString:@"YOU"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"YOU" withString:@"YIU"];
    }
    if ([retString rangeOfString:@"YE"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"YE" withString:@"YIE"];
    }
    if ([retString rangeOfString:@"YA"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"YA" withString:@"YIA"];
    }

    if ([retString rangeOfString:@"YONG"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"YONG" withString:@"YIONG"];
    }
    
    if ([retString rangeOfString:@"WA"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"WA" withString:@"WUA"];
    }
    if ([retString rangeOfString:@"WEI"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"WEI" withString:@"WUI"];
    }
    if ([retString rangeOfString:@"WEN"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"WEN" withString:@"WUN"];
    }
    
    if ([retString rangeOfString:@"BO"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"BO" withString:@"BUO"];
    }
    if ([retString rangeOfString:@"WO"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"WO" withString:@"WUO"];
    }
    if ([retString rangeOfString:@"PO"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"PO" withString:@"PUO"];
    }
    if ([retString rangeOfString:@"MO"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"MO" withString:@"MUO"];
    }
    if ([retString rangeOfString:@"FO"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"FO" withString:@"FUO"];
    }
    if ([retString rangeOfString:@"NǕ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NǕ" withString:@"NÜ"];
    }
    if ([retString rangeOfString:@"NǗ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NǗ" withString:@"NÜ"];
    }
    if ([retString rangeOfString:@"NǙ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NǙ" withString:@"NÜ"];
    }
    if ([retString rangeOfString:@"NǛ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NǛ" withString:@"NÜ"];
    }

    
    
    if ([retString rangeOfString:@"LǕ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LǕ" withString:@"LÜ"];
    }
    if ([retString rangeOfString:@"LǗ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LǗ" withString:@"LÜ"];
    }
    if ([retString rangeOfString:@"LǙ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LǙ" withString:@"LÜ"];
    }
    if ([retString rangeOfString:@"LǛ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LǛ" withString:@"LÜ"];
    }
    
    if ([retString rangeOfString:@"LŪ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LŪ" withString:@"LU"];
    }
    if ([retString rangeOfString:@"LÚ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LÚ" withString:@"LU"];
    }
    if ([retString rangeOfString:@"LǓ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LǓ" withString:@"LU"];
    }
    if ([retString rangeOfString:@"LÙ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"LÙ" withString:@"LU"];
    }
    if ([retString rangeOfString:@"NŪ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NŪ" withString:@"NU"];
    }
    if ([retString rangeOfString:@"NÚ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NÚ" withString:@"NU"];
    }
    if ([retString rangeOfString:@"NǓ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NǓ" withString:@"NU"];
    }
    if ([retString rangeOfString:@"NÙ"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"NÙ" withString:@"NU"];
    }
    if ([retString rangeOfString:@"QU"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"QU" withString:@"QÜ"];
    }
    if ([retString rangeOfString:@"JU"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"JU" withString:@"JÜ"];
    }
    if ([retString rangeOfString:@"XU"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"XU" withString:@"XÜ"];
    }
    if ([retString rangeOfString:@"YU"].length>0) {
        retString = [retString stringByReplacingOccurrencesOfString:@"YU" withString:@"YÜ"];
    }
    //NSLog(@"%@", pinyin);
    return retString;
}

@end
