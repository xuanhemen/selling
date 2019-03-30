//
//  QFPopupView.m
//  SLAPP
//
//  Created by qwp on 2018/8/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFPopupView.h"
#import "QFHeader.h"

@implementation QFPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configUI{
    
    if (_isCarryDown) {
        [self sortViewConfigCarryDown];
        [self segmentViewConfigCarryDown];
        [self configCarryDownView];
        
    }else{
        [self sortViewConfig];
        [self segmentViewConfig];
    }
    
    
    
}

- (void)sortViewConfigCarryDown{
    self.sortView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, (kScreenWidth-20)/3, 40)];
    self.sortView.backgroundColor = UIColorFromRGB(0xFFFFFF);
//    self.sortView.layer.cornerRadius = 2;
//    self.sortView.clipsToBounds = YES;
    [self addSubview:self.sortView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.sortView.frame.size.width, self.sortView.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"p_menu_button"];
    [self.sortView addSubview:backImageView];
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    //    imageView.contentMode = UIViewContentModeCenter;
    //    imageView.image = [UIImage imageNamed:@"p_menu_sort_img"];
    //    [self.sortView addSubview:imageView];
    
    self.sortDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sortView.frame.size.width-30, 10, 5, 20)];
    self.sortDownImageView.contentMode = UIViewContentModeCenter;
    self.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
    [self.sortView addSubview:self.sortDownImageView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sortView.frame.size.width-25, 10, 20, 20)];
    moreImageView.contentMode = UIViewContentModeCenter;
    moreImageView.image = [UIImage imageNamed:@"p_menu_show_img"];
    [self.sortView addSubview:moreImageView];
    
    self.sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5 , self.sortView.frame.size.width-40, self.sortView.frame.size.height-10)];
    self.sortLabel.text = @"更新时间";
    self.sortLabel.font = [UIFont systemFontOfSize:14];
    self.sortLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [self.sortView addSubview:self.sortLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.sortView.frame.size.width, self.sortView.frame.size.height)];
    [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortView addSubview:button];
    
}

- (void)segmentViewConfigCarryDown{
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-20)/3+10, 0, (kScreenWidth)/3, 40)];
    _segmentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
//    _segmentView.layer.cornerRadius = 2;
//    _segmentView.clipsToBounds = YES;
    [self addSubview:_segmentView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _segmentView.frame.size.width, _segmentView.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"p_menu_button"];
    [_segmentView addSubview:backImageView];
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    //    imageView.contentMode = UIViewContentModeCenter;
    //    imageView.image = [UIImage imageNamed:@"p_menu_stage_img"];
    //    [_segmentView addSubview:imageView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_segmentView.frame.size.width-25, 10, 20, 20)];
    moreImageView.contentMode = UIViewContentModeCenter;
    moreImageView.image = [UIImage imageNamed:@"p_menu_show_img"];
    [_segmentView addSubview:moreImageView];
    
    self.segLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5 , _segmentView.frame.size.width-20, _segmentView.frame.size.height-10)];
    self.segLabel.text = @"阶段分组";
    self.segLabel.font = [UIFont systemFontOfSize:14];
    self.segLabel.textColor = UIColorFromRGB(0xFFFFFF);
    self.segLabel.textAlignment = NSTextAlignmentCenter;
    [_segmentView addSubview:self.segLabel];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _segmentView.frame.size.width, _segmentView.frame.size.height)];
    [button addTarget:self action:@selector(segButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:button];
    
}


-(void)configCarryDownView{
    _carryDownView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - (kScreenWidth-20)/3-3, 0, (kScreenWidth)/3, 40)];
    _carryDownView.backgroundColor = UIColorFromRGB(0x393A47);
//    _carryDownView.layer.cornerRadius = 2;
//    _carryDownView.clipsToBounds = YES;
   
    [self addSubview:_carryDownView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _carryDownView.frame.size.width, _carryDownView.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"p_menu_button"];
    [_carryDownView addSubview:backImageView];
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    //    imageView.contentMode = UIViewContentModeCenter;
    //    imageView.image = [UIImage imageNamed:@"p_menu_stage_img"];
    //    [_segmentView addSubview:imageView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_segmentView.frame.size.width-25, 10, 20, 20)];
    moreImageView.contentMode = UIViewContentModeCenter;
    moreImageView.image = [UIImage imageNamed:@"p_menu_show_img"];
    [_carryDownView addSubview:moreImageView];
    
    self.carryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5 , _carryDownView.frame.size.width-60, _carryDownView.frame.size.height-10)];
    self.carryLabel.text = @"结转";
    self.carryLabel.font = [UIFont systemFontOfSize:14];
    self.carryLabel.textColor = UIColorFromRGB(0xFFFFFF);
    self.carryLabel.textAlignment = NSTextAlignmentCenter;
    [_carryDownView addSubview:self.carryLabel];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _carryDownView.frame.size.width, _carryDownView.frame.size.height)];
    [button addTarget:self action:@selector(carryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_carryDownView addSubview:button];
    
}





- (void)sortViewConfig{
    self.sortView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, (kScreenWidth-30-10)/2, 40)];
    self.sortView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.sortView.layer.cornerRadius = 2;
    self.sortView.clipsToBounds = YES;
    [self addSubview:self.sortView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.sortView.frame.size.width, self.sortView.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"p_menu_button"];
    [self.sortView addSubview:backImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"p_menu_sort_img"];
    [self.sortView addSubview:imageView];
    
    self.sortDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sortView.frame.size.width-30, 10, 5, 20)];
    self.sortDownImageView.contentMode = UIViewContentModeCenter;
    self.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
    [self.sortView addSubview:self.sortDownImageView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sortView.frame.size.width-25, 10, 20, 20)];
    moreImageView.contentMode = UIViewContentModeCenter;
    moreImageView.image = [UIImage imageNamed:@"p_menu_show_img"];
    [self.sortView addSubview:moreImageView];
    
    self.sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,5 , self.sortView.frame.size.width-70, self.sortView.frame.size.height-10)];
    self.sortLabel.text = @"按更新时间";
    self.sortLabel.font = [UIFont systemFontOfSize:14];
    self.sortLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [self.sortView addSubview:self.sortLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.sortView.frame.size.width, self.sortView.frame.size.height)];
    [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortView addSubview:button];
}
- (void)segmentViewConfig{
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreenWidth-30-10)/2+10, 0, (kScreenWidth-30-10)/2, 40)];
    _segmentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _segmentView.layer.cornerRadius = 2;
    _segmentView.clipsToBounds = YES;
    [self addSubview:_segmentView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _segmentView.frame.size.width, _segmentView.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"p_menu_button"];
    [_segmentView addSubview:backImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"p_menu_stage_img"];
    [_segmentView addSubview:imageView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_segmentView.frame.size.width-25, 10, 20, 20)];
    moreImageView.contentMode = UIViewContentModeCenter;
    moreImageView.image = [UIImage imageNamed:@"p_menu_show_img"];
    [_segmentView addSubview:moreImageView];
    
    self.segLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,5 , _segmentView.frame.size.width-60, _segmentView.frame.size.height-10)];
    self.segLabel.text = @"按阶段分组";
    self.segLabel.font = [UIFont systemFontOfSize:14];
    self.segLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [_segmentView addSubview:self.segLabel];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _segmentView.frame.size.width, _segmentView.frame.size.height)];
    [button addTarget:self action:@selector(segButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:button];
}
- (void)sortButtonClick:(UIButton *)sender{
    
    if([_delegate respondsToSelector:@selector(qf_sortButtonClick)]){
        [_delegate qf_sortButtonClick];
    }
    
    if([_delegate respondsToSelector:@selector(qf_sortButtonClick:)]){
        [_delegate qf_sortButtonClick:self];
    }
    
    
}
- (void)segButtonClick:(UIButton *)sender{
    
    if([_delegate respondsToSelector:@selector(qf_segButtonClick)]){
        [_delegate qf_segButtonClick];
    }
    
    if([_delegate respondsToSelector:@selector(qf_segButtonClick:)]){
        [_delegate qf_segButtonClick:self];
    }
    
}

-(void)carryButtonClick:(UIButton *)btn{
    
    if([_delegate respondsToSelector:@selector(qf_carryButtonClick:)]){
        [_delegate qf_carryButtonClick:self];
    }
}
@end

