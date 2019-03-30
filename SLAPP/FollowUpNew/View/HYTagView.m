//
//  HYTagView.m
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYTagView.h"
#import <Masonry/Masonry.h>
#import "QFHeader.h"

@interface HYTagView()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView  *backView;

@property (nonatomic,strong)UIButton  *button;

@property (nonatomic,strong)UIColor *selectColor;
@property (nonatomic,assign)BOOL isEdit;



@end

@implementation HYTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    self.isEdit = NO;
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    self.backView.layer.cornerRadius = 4;
    self.backView.clipsToBounds = YES;
    self.backView.layer.borderWidth = 0.8;
    self.backView.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UIColorFromRGB(0x999999);
    self.titleLabel.text = @"+ 自定义标签";
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.right.mas_equalTo(-2);
        make.top.mas_equalTo(2);
        make.bottom.mas_equalTo(-2);
    }];
    
    self.button = [[UIButton alloc] init];
    [self.backView addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    self.editImageView = [[UIImageView alloc] init];
    //self.editImageView.backgroundColor = [UIColor redColor];
    self.editImageView.image = [UIImage imageNamed:@"qf_select_statusdefault"];
    [self.backView addSubview:self.editImageView];
    [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    self.editImageView.hidden = YES;
    
    
}
- (void)configTitle:(NSString *)title andType:(HYTAGTYPE)type andIsEdit:(BOOL)isEdit{
    self.isEdit = isEdit;
    self.titleLabel.text = title;
    self.currentType = type;
    switch (type) {
        case TAGTYPE_SEE:{
            self.selectColor = UIColorFromRGB(0xBDE9D5);
            self.titleLabel.textColor = UIColorFromRGB(0x119659);
        }
            break;
        case TAGTYPE_CONTACT:{
            self.selectColor = UIColorFromRGB(0xFFD8B3);
            self.titleLabel.textColor = UIColorFromRGB(0xCD6706);
        }
            break;
        case TAGTYPE_BUSINESS:{
            self.selectColor = UIColorFromRGB(0xC0DDFC);
            self.titleLabel.textColor = UIColorFromRGB(0x2662E8);
        }
            break;
        case TAGTYPE_SCHEME:{
            self.selectColor = UIColorFromRGB(0xFFDDDD);
            self.titleLabel.textColor = UIColorFromRGB(0xBB5454);
        }
            break;
        case TAGTYPE_CUSTOM:{
            self.selectColor = UIColorFromRGB(0xDBF2D6);
            self.titleLabel.textColor = UIColorFromRGB(0x457C63);
            if (isEdit) {
                self.editImageView.hidden = NO;
            }else{
                self.editImageView.hidden = YES;
            }
        }
            break;
        case TAGTYPE_ADD:{
            self.selectColor = UIColorFromRGB(0xFFFFFF);
            self.titleLabel.textColor = UIColorFromRGB(0x999999);
        }
            break;
        default:
            break;
    }
    
}

- (void)buttonClick:(UIButton *)sender{
    if (self.currentType == TAGTYPE_ADD) {
        if ([self.delegate respondsToSelector:@selector(addTagView:)]) {
            [self.delegate performSelector:@selector(addTagView:) withObject:self];
        }
    }else{
        if (self.isEdit == NO) {
            if ([self.delegate respondsToSelector:@selector(tagViewSelect:)]) {
                [self.delegate performSelector:@selector(tagViewSelect:) withObject:self];
            }
            //sender.selected = !sender.selected;
           // [self select:sender.selected];
        }else{
            if (self.editImageView.hidden == NO) {
                if ([self.delegate respondsToSelector:@selector(tagViewEditSelect:)]) {
                    [self.delegate performSelector:@selector(tagViewEditSelect:) withObject:self];
                }
            }else{
                return;
            }
        }
    }
}
- (void)select:(BOOL)select{
    if (select) {
        self.backView.backgroundColor = self.selectColor;
        self.backView.layer.borderWidth = 0;
    }else{
        self.backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.backView.layer.borderWidth = 0.8;
        
    }
}
@end
