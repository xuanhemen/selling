//
//  HYCarryDownView.m
//  SLAPP
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYCarryDownView.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>
@implementation HYCarryDownView

- (instancetype)init
{
    self = [super init];
    if (self) {
//
        self.backgroundColor = [[UIColor colorWithHexString:@"97C79D"] colorWithAlphaComponent:0.85];
        _des = [[UILabel alloc] init];
        _carrydownBtn = [[UIButton alloc] init];
        [_carrydownBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _deleteBtn = [[UIButton alloc] init];
        [self addSubview:_des];
         [self addSubview:_carrydownBtn];
         [self addSubview:_deleteBtn];
        kWeakS(weakSelf);
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(30);
            make.centerY.equalTo(weakSelf);
             make.height.mas_equalTo(20);
        }];
        
        [_deleteBtn setImage:[UIImage imageNamed:@"carryDelete"] forState:UIControlStateNormal];
         [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_carrydownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50);
            make.centerY.equalTo(weakSelf);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(50);
        }];
        
        [_carrydownBtn setTitle:@"结转" forState:UIControlStateNormal];
        [_carrydownBtn setTitleColor:[UIColor colorWithHexString:@"97C79D"] forState:UIControlStateNormal];
        _carrydownBtn.titleLabel.font = kFont(14);
        _carrydownBtn.backgroundColor = [UIColor whiteColor];
        _carrydownBtn.layer.cornerRadius = 6;
        [_carrydownBtn addTarget:self action:@selector(carryClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(weakSelf);
            make.right.mas_equalTo(-105);
        }];
        _des.textColor = [UIColor whiteColor];
        _des.numberOfLines = 0;
        _des.font = kFont(14);
    }
    return self;
}

-(void)deleteClick{
    [self removeFromSuperview];
}

-(void)carryClick{
    
    if (self.carryDownClick) {
        self.carryDownClick();
    }
//    [self removeFromSuperview];
}

@end
