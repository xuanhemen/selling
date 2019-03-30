//
//  HYVisitNumView.m
//  SLAPP
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitNumView.h"
#import "NSString+AttributedString.h"
@implementation HYVisitNumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)configUI{
   
    float width = kScreenWidth/3.0;
    NSArray *tArray = @[@"准备中",@"完成",@"推迟"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(width*i, 0, width, 40);
        [btn setTitle:tArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont(14);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1000+i;
        if (i == 0) {
            self.left  = btn;
        }else if (i == 1){
            self.middle = btn;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, 0, 0.3, 40)];
            line.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self addSubview:line];
        }else{
            self.right = btn;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, 0, 0.3, 40)];
            line.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self addSubview:line];
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,40,kScreenWidth, 5)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line];
    
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(width, self.frame.size.height-3, width, 3)];
    _statusView.backgroundColor = kgreenColor;
    [self addSubview:_statusView];
    _statusView.hidden = YES;
}

-(void)refreshWithResult:(NSDictionary *)result{
    
//    if (![result isNotEmpty]) {
//
//    }else{
    
    
        NSString *left = [result[@"zb"] toString];
        NSString *middle = [result[@"wc"] toString];
        NSString *right = [result[@"tc"] toString];
    if (![left isNotEmpty]) {
        left = @"0";
    }
    
    if (![middle isNotEmpty]) {
        middle = @"0";
    }
    
    if (![right isNotEmpty]) {
        right = @"0";
    }
    
        [self.left setAttributedTitle:[NSString configAttributedStrAll:[@"准备中" stringByAppendingString:left] subStr:left allColor:[UIColor blackColor] subColor:kBlueColor font:kFont(14) lineSpace:0] forState:UIControlStateNormal];
        [self.middle setAttributedTitle:[NSString configAttributedStrAll:[@"完成" stringByAppendingString:middle] subStr:middle allColor:[UIColor blackColor] subColor:kgreenColor font:kFont(14) lineSpace:0] forState:UIControlStateNormal];
        [self.right setAttributedTitle:[NSString configAttributedStrAll:[@"推迟" stringByAppendingString:right] subStr:right allColor:[UIColor blackColor] subColor:[UIColor orangeColor] font:kFont(14) lineSpace:0] forState:UIControlStateNormal];
        
        
        
//    }
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.isVisitHome){
        return;
    }
    
    kWeakS(weakSelf);
    _temp = btn;
    
    if (self.statusClick)
    {
        self.statusClick([NSString stringWithFormat:@"%ld",btn.tag-1000]);
        
    }
    
    
    float width = kScreenWidth/3.0;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.statusView.frame = CGRectMake(width*(btn.tag-1000), weakSelf.frame.size.height-3, width, 3);
    }];
    self.statusView.hidden = NO;
}

//返回当前的状态key
-(NSString *)currentStatusKey{
    
    if (!_temp) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%ld",_temp.tag-1000];
    }
    
    
}

@end
