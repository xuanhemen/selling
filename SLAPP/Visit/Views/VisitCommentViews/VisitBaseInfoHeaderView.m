//
//  VisitBaseInfoHeaderView.m
//  CLApp
//
//  Created by xslp on 16/8/30.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "VisitBaseInfoHeaderView.h"

@interface VisitBaseInfoHeaderView ()

@property (strong, nonatomic)  UILabel *lbProject; //项目标题
@property (strong, nonatomic)  UILabel *lbClient; //拜访客户
@property (strong, nonatomic)  UILabel *lbVisitObject; //拜访对象
@property (strong, nonatomic)  UILabel *lbPhase; //拜访阶段

@end
@implementation VisitBaseInfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        typeof(self)weakSelf = self;
        
        self.backgroundColor = HexColor(@"F1F1F1");
        
        [self addSubview:self.lbPhase];
        
        [self.lbPhase mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(15 + 3);
            
            make.right.mas_equalTo(-15);
            
        }];
        

        [self addSubview:self.lbProject];
        
        [self.lbProject mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.mas_equalTo(15);
            make.right.equalTo(weakSelf.lbPhase).offset(-15 * 3);
            
        }];
        
        [self addSubview:self.lbClient];
        
        [self.lbClient mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            
            make.top.equalTo(weakSelf.lbProject.mas_bottom).offset(15);
            
        }];
        
        [self addSubview:self.lbVisitObject];
        
        [self.lbVisitObject mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            
            make.top.equalTo(weakSelf.lbClient.mas_bottom).offset(15);
            make.height.mas_equalTo(15);
//            make.bottom.mas_equalTo(-15 - 10);
            
        }];
                
        
    }
    return self;
}

- (void)setCommentListModel:(HYCommentListModel *)commentListModel{
    _commentListModel = commentListModel;
    self.lbProject.text = commentListModel.project_name;
    self.lbClient.text = commentListModel.client_name;
    self.lbVisitObject.text = [NSString stringWithFormat:@"拜访%@",commentListModel.contact_name];
    
    self.lbPhase.text = commentListModel.status;
    
    if ([self.lbPhase.text isEqualToString:@"完成"]) {
        [self.lbPhase setTextColor:kgreenColor];

    }else if ([self.lbPhase.text isEqualToString:@"推迟"]){
        [self.lbPhase setTextColor:[UIColor redColor]];
    }
    else{
        [self.lbPhase setTextColor:HexColor(@"F3900F")];
    }
    
    //    if ([model.status isEqualToString:@"1"]) {
    //        self.lbPhase.text = @"已完成";
    //        [self.lbPhase setTextColor:kGreenColor];
    //    }else{
    //        if (model.visit_date < [[NSDate date] timeIntervalSince1970]) {
    //            self.lbPhase.text = @"推迟的";
    //            [self.lbPhase setTextColor:[UIColor redColor]];
    //        }else{
    //            self.lbPhase.text = @"准备中";
    //            [self.lbPhase setTextColor:HexColor(@"F3900F")];
    //        }
    //    }
    
    
}

//- (void)setModel:(VisitModel *)model{
//
//    _model = model;
//
//    self.lbProject.text = [model.projectModel isNotEmpty]?model.projectModel.name:[model.project_name isNotEmpty]?[NSString stringWithFormat:@"%@(已删除)",model.project_name]:@" ";
//
//    self.lbClient.text = [model.clientModel isNotEmpty]?model.clientModel.name:[model.client_name isNotEmpty]?[NSString stringWithFormat:@"%@(已删除)",model.client_name]:@" ";
//
//    self.lbVisitObject.text = [NSString stringWithFormat:@"拜访%@",[model.contactModel isNotEmpty]?model.contactModel.name:[model.contact_name isNotEmpty]?[NSString stringWithFormat:@"%@(已删除)",model.contact_name]:@" "];
//
//    if ([model.status isEqualToString:@"1"]) {
//        self.lbPhase.text = @"已完成";
//        [self.lbPhase setTextColor:kGreenColor];
//    }else{
//        if (model.visit_date < [[NSDate date] timeIntervalSince1970]) {
//            self.lbPhase.text = @"推迟的";
//            [self.lbPhase setTextColor:[UIColor redColor]];
//        }else{
//            self.lbPhase.text = @"准备中";
//            [self.lbPhase setTextColor:HexColor(@"F3900F")];
//        }
//    }
//
//}

-(UILabel *)lbProject{
    if (!_lbProject) {
        _lbProject = [[UILabel alloc] init];
        
        _lbProject.font = kFont(14);
        
        _lbProject.textColor = HexColor(@"333333");
        
    }
    return _lbProject;
}

-(UILabel *)lbClient{
    if (!_lbClient) {
        _lbClient = [[UILabel alloc] init];
        
        _lbClient.font = kFont(12);
        
        _lbClient.textColor = HexColor(@"666666");
        
        
    }
    return _lbClient;
}

-(UILabel *)lbVisitObject{
    if (!_lbVisitObject) {
        _lbVisitObject = [[UILabel alloc] init];
        
        _lbVisitObject.font = kFont(12);
        
        _lbVisitObject.textColor = HexColor(@"666666");
        
        
    }
    return _lbVisitObject;
}

-(UILabel *)lbPhase{
    if (!_lbPhase) {
        _lbPhase = [[UILabel alloc] init];
        
        _lbPhase.font = kFont(12);
        
        _lbPhase.textColor = HexColor(@"F3900F");
        
    }
    return _lbPhase;
}

@end
