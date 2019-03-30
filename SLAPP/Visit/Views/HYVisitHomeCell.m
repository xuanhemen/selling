//
//  HYVisitHomeCell.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitHomeCell.h"
#import "NSString+AttributedString.h"
@implementation HYVisitHomeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.textLabel.text = @"asdasd";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
    
}

-(void)configUI{
    
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    line.backgroundColor = kgreenColor;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    
    _visitPerson = [UILabel new];
    [self.contentView addSubview:_visitPerson];
    
    _visitDate = [UILabel new];
    [self.contentView addSubview:_visitDate];
    
    _visitProject = [UILabel new];
    [self.contentView addSubview:_visitProject];
    
    _visitStatus = [UILabel new];
    [self.contentView addSubview:_visitStatus];
    
    _visitMoney = [UILabel new];
    [self.contentView addSubview:_visitMoney];
    
    _visitClient = [UILabel new];
    [self.contentView addSubview:_visitClient];
    
    
    UIFont *font = kFont(14);
    
    _visitPerson.font = font;
    _visitDate.font = font;
    _visitProject.font = font;
    _visitStatus.font = font;
    _visitMoney.font = font;
    _visitClient.font = font;
    
    _visitStatus.textColor = kOrangeColor;
    _visitMoney.textColor = [UIColor lightGrayColor];
    _visitClient.textColor = [UIColor lightGrayColor];
    
    _visitStatus.textAlignment = NSTextAlignmentRight;
    _visitDate.textAlignment = NSTextAlignmentRight;
    _visitClient.textAlignment = NSTextAlignmentRight;
    
    
    
    kWeakS(weakSelf);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(5);
        make.centerY.equalTo(weakSelf.visitPerson);
    }];
    
    
    [_visitPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.right.equalTo(weakSelf.visitDate.mas_left).offset(2);
    }];
    
    
    
    [_visitDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.visitPerson);
        make.width.mas_equalTo(130);
        make.height.equalTo(weakSelf.visitPerson);
    }];
    
    
    
    [_visitProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(weakSelf.visitPerson.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
        make.right.equalTo(weakSelf.visitStatus.mas_left).offset(2);
    }];
    
    
    
    [_visitStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.visitProject);
        make.width.mas_equalTo(50);
        make.height.equalTo(weakSelf.visitProject);
    }];
    
    
    [_visitMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(weakSelf.visitProject.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-60);
    }];
    
    
    
    [_visitClient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.visitMoney);
        make.left.equalTo(weakSelf.visitMoney.mas_right).offset(2);
        make.height.equalTo(weakSelf.visitMoney);
    }];
    
    
    
    UIView *bottomView = [UIView new];
    [self.contentView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSArray *bottomTitleArray = @[@"准备",@"预约",@"查看",@"总结"];
    NSArray *bottomColors = @[kOrangeColor,UIColor.redColor,kBlueColor,kgreenColor];
    CGFloat width = kScreenWidth/bottomTitleArray.count;
    for (int i = 0; i<bottomTitleArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 1000+i;
        [btn setTitle:bottomTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:bottomColors[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont(14);
        
        btn.frame = CGRectMake(width*i, 0, width, 35);
        [bottomView addSubview:btn];
        
        if (i != 0) {
            UIView *yline = [UIView new];
            yline.frame = CGRectMake(width*i-0.5, 0, 0.5, 35);
            yline.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [bottomView addSubview:yline];
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *xline = [UIView new];
    xline.frame = CGRectMake(0, 0, kScreenWidth,0.5);
    xline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:xline];
    
    
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (_bottomClickWithKey) {
        _bottomClickWithKey(btn.titleLabel.text,_model);
    }
}

-(void)setModel:(HYVisitModel *)model{
    _model = model;
    
    
    
    _visitPerson.attributedText = [NSString configAttributedStrAll:[NSString stringWithFormat:@"%@-拜访-%@",[model.realname toString],[model.visit_contacts toString]] subStr:[model.visit_contacts toString] allColor:[UIColor darkTextColor] subColor:kOrangeColor font:kFont(14) lineSpace:0];
    _visitDate.text = [model.visit_date toString];
    _visitProject.text = [model.project_name toString];
    _visitMoney.text = [NSString stringWithFormat:@"金额：%@万",[model.amount toString]];
    if ([model.status intValue] == 0) {
        _visitStatus.text = @"准备中";
        _visitStatus.textColor = kBlueColor;
    }else if ([model.status intValue] == 1){
        _visitStatus.text = @"完成";
        _visitStatus.textColor = kgreenColor;
    }else{
        _visitStatus.text = @"推迟";
        _visitStatus.textColor = [UIColor orangeColor];
    }
    
    _visitClient.text = [model.client_name toString];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
