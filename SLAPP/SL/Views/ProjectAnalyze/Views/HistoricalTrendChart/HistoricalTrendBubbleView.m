//
//  HistoricalTrendBubbleView.m
//  SLAPP
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HistoricalTrendBubbleView.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/UIColor+Chameleon.h>
@interface HistoricalTrendBubbleView()
@property(nonatomic,strong)UIScrollView *backView;
@end


@implementation HistoricalTrendBubbleView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-20,40)];
        lab.text = @"";
        lab.textColor = [UIColor darkTextColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        _labTitle = lab;
        
        UILabel *topline = [[UILabel alloc]initWithFrame:CGRectMake(10, 39,kScreenWidth-20-20,0.3)];
        topline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:topline];
    }
    return self;
}


-(void)setDataArray:(NSDictionary *)dataArray{
    _dataArray = dataArray;
    [self configUI];
    
}


-(void)configUI{
    
    float width = 50;
    
    
    if (![_titleArray isNotEmpty]) {
        return;
    }
    
    
    
    
    float tnum = _titleArray.count;
    if (tnum * width <= kScreenWidth) {
//        width = (kScreenWidth - 100 )/tnum;
    }
    
    
    float cnum = [_dataArray[@"value"] count];
    
    
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40 + (cnum-1) * 50 + 80 + 50);
    }];
    
    
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+20, kScreenWidth-20, (cnum-1) * 50 + 80 )];
    [self addSubview:_backView];
    self.backView.contentSize = CGSizeMake((tnum-1) * 50 + 100, 0);
    
   
    
    
    
    NSArray *descArray  = [NSArray arrayWithArray:_dataArray[@"desc"]];
    NSArray *valueArray = [NSArray arrayWithArray:_dataArray[@"value"]];
    
    
    
    
    
    float descWidth = (kScreenWidth-20)/descArray.count;
    
    for (int i = 0; i< descArray.count; i++) {
       
            //添加标记色与描述
            NSDictionary *dic = descArray[i];
            UILabel *colorLable = [[UILabel alloc] initWithFrame:CGRectMake(i*descWidth+5,20+40, 10, 10)];
            NSString *color = [NSString stringWithFormat:@"%@",dic[@"color"]];
            colorLable.backgroundColor = [UIColor colorWithHexString:color];
            colorLable.layer.cornerRadius = 5;
            colorLable.clipsToBounds = YES;
            [self addSubview:colorLable];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20+i*descWidth,40, descWidth-20, 50)];
            lable.text = dic[@"caption"];
            lable.textColor = [UIColor lightGrayColor];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:11];
            [self addSubview:lable];
        
    }
    
    
    for (int i = 0; i< tnum; i++) {
        
        //纵坐标线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width+i*width,width, 0.5, (cnum-1)*50)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e5f3f7"];
        [_backView addSubview:line];
        
        //横标记名称
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0+i*width,(cnum-1) * 50+50, width, 50)];
//        lable.center = CGPointMake(width+i*width, (cnum-1) * 50 + 50 + 25);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:10];
        lable.textColor = [UIColor lightGrayColor];
        lable.text = _titleArray[i];
        [_backView addSubview:lable];
    }
    
    
    
    
    for (int i = 0; i< cnum; i++) {
        //横坐标线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width, width+i*width, (tnum-1) * 50, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e5f3f7"];
//        line.center = CGPointMake(width, width+i*width);
        [_backView addSubview:line];
        
        
        
         NSDictionary *dic = valueArray[i];
        //纵坐标标记名称
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,25+i*width, width, 50)];
        //        lable.center = CGPointMake(width+i*width, (cnum-1) * 50 + 50 + 25);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:10];
        lable.textColor = [UIColor lightGrayColor];
        lable.text = dic[@"name"];
        [_backView addSubview:lable];
        
    }
    

    
    
    
    
    //画值
    for (int i = 0; i< cnum; i++) {
        
        NSDictionary *dic = valueArray[i];
//        NSArray *typeArray = dic[@"type"];
        NSArray *subValueArray = dic[@"value"];
        for (int j = 0; j< tnum; j++) {
 
            //横
            int key = [subValueArray[j]  intValue];
            for (NSDictionary *desc in descArray) {
                if ([desc[@"key"] intValue] == key) {
                    UIView *cycle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                    cycle.backgroundColor = [UIColor orangeColor];
                    cycle.layer.cornerRadius = 5;
                    cycle.center = CGPointMake(width+j*width, width+i*width);
                    [_backView addSubview:cycle];
                    NSString *color = [NSString stringWithFormat:@"%@",desc[@"color"]];
                    cycle.backgroundColor = [UIColor colorWithHexString:color];
                    break;
                }
            }
        }
        
    }
    
}


@end
