//
//  TopGuideView.m
//  CLApp
//
//  Created by 吕海瑞 on 16/8/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "TopGuideView.h"
#import "GuideBtn.h"

@implementation TopGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    [self configUI];
}

-(void)configUI
{
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    line.center = self.center;
    [self addSubview:line];
    
//    NSArray *titleArray = @[@"认知期望",@"行动承诺",@"约见理由",@"未知清单",@"优势清单",@"四季沟通",@"承诺类问题",@"可能的顾虑",];
    
    NSArray *titleArray = @[@"认知期望",@"拜访目标",@"约见理由",@"未知信息与提问清单",@"优势呈现清单"];
    NSInteger count = titleArray.count;
    for(int i = 0;i<count;i++)
    {
        GuideBtn *btn = [[GuideBtn alloc]initWithFrame:CGRectMake(0+(kScreenWidth/count)*i,0 , kScreenWidth/count, 40)];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.remindLable.text = titleArray[i];
        btn.center = CGPointMake((kScreenWidth/count)*i+(kScreenWidth/count)/2.0,self.frame.size.height/2.0);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0)
        {
            [btn configWithTag:1];
            self.currentTag = btn.tag;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
    }
    
   
}

-(void)btnClick:(GuideBtn *)btn
{
    if (btn.tag > self.historyTag) {
        return;
    }
//    [self refreshBtnWith:btn];
    if (_delegate && [_delegate respondsToSelector:@selector(topGuideView:BtnClick:)])
    {
        
        [_delegate topGuideView:self BtnClick:btn];
    }
}

-(void)refreshBtnWith:(GuideBtn *)btn
{
    if (!self.historyTag)
    {
        self.historyTag = btn.tag;
    }
    else
    {
        self.historyTag = btn.tag>=self.historyTag?btn.tag:self.historyTag;
    }
    
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[GuideBtn class]])
        {
            GuideBtn *guide = (GuideBtn *)view;
            if (guide.tag != btn.tag)
            {
                if (guide.tag<=self.historyTag)
                {
                    guide.isClicked = YES;
                     [guide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [guide configWithTag:0];
                
            }
            else
            {
                [guide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               [guide configWithTag:1];
                self.currentTag = guide.tag;
            }
            
        }
    }
}

-(void)changeBtnWithPage:(NSInteger)page
{
    GuideBtn *btn = [[GuideBtn alloc]init];
    btn.tag = 1000+page;
    [self refreshBtnWith:btn];
}

-(void)configWith:(NSInteger)historyTag
{
    _historyTag = historyTag;
    
    _historyTag +=1000;
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[GuideBtn class]])
        {
            GuideBtn *guide = (GuideBtn *)view;
            if (guide.tag != 1000)
            {
                if (guide.tag<=self.historyTag)
                {
                    
                    guide.isClicked = YES;
                    [guide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [guide configWithTag:0];
                
                
            }
            else
            {
                [guide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [guide configWithTag:1];
                self.currentTag = guide.tag;
           }
            
        }
    }

}

-(NSInteger)currentPageTag{
    if (self.currentTag) {
        return self.currentTag-1000;
    }else{
        return 0;
    }
}
@end
