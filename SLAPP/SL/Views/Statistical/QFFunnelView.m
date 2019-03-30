//
//  QFFunnelView.m
//  SLAPP
//
//  Created by qwp on 2018/8/9.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFFunnelView.h"
#import "QFHeader.h"
#import "QFCheckView.h"
@interface QFFunnelView() {
    
}
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,assign) NSInteger cnt;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UILabel *amountLabel;
@property (nonatomic,strong)UILabel *hopeAmountLabel;

@property (nonatomic,strong)UILabel *baseLastLabel;
@property (nonatomic,strong)UILabel *qfnewAmountLabel;
@property (nonatomic,strong)UILabel *qfnewHopeAmountLabel;

@end

@implementation QFFunnelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorArray = @[UIColorFromRGB(0x3E8ED1),UIColorFromRGB(0x4CA7DA),UIColorFromRGB(0xE4A84E),UIColorFromRGB(0xE27E4A),UIColorFromRGB(0xD54F50),UIColorFromRGB(0x3E8ED1),UIColorFromRGB(0x4CA7DA),UIColorFromRGB(0xE4A84E),UIColorFromRGB(0xE27E4A),UIColorFromRGB(0xD54F50)];
        self.cnt = 5;
        self.project_ids = @"";
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    
    [self drawFunnelView];
    
    
}

- (void)drawFunnelView{
    UIView *funnelView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.frame.size.width-75, self.frame.size.height-30-30)];
    [self addSubview:funnelView];
    
    
    CGFloat space = (funnelView.frame.size.height-(self.cnt-1)*3)/self.cnt;
    CGFloat triangleLine = space/sqrt(3);
    
    NSArray *textArray = @[@"意向 89.9万",@"方案 286.9万",@"商务 14万",@"即将成交\n21.9万",@"赢单",@"49.37万"];
    
    
    for (int i=0; i<self.cnt; i++) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, (space+3)*i, funnelView.frame.size.width, space)];
        colorView.backgroundColor = self.colorArray[i];
        [funnelView addSubview:colorView];
        
        CGFloat labelHeight = space;
        if (i == self.cnt-1) {
            labelHeight = space/2;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(triangleLine*i, 0, colorView.frame.size.width-triangleLine*i*2, labelHeight)];
        label.textColor = UIColorFromRGB(0xFFFFFF);
        label.text = textArray[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.tag = i+100;
        label.adjustsFontSizeToFitWidth = YES;
        [colorView addSubview:label];
        
        __weak QFFunnelView *weakSelf = self;
        QFCheckView *check = [[QFCheckView alloc] initWithFrame:CGRectMake(self.frame.size.width-45, 15+colorView.frame.origin.y+(colorView.frame.size.height-30)/2, 30, 30)];
        [check check];
        check.tag = i+200;
        check.checkBlock = ^(BOOL isCheck, QFCheckView *sender) {
            [weakSelf checkNumChange];
        };
        [self addSubview:check];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, funnelView.frame.size.width, funnelView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"qf_triangle_image"];
    [funnelView addSubview:imageView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(triangleLine*(self.cnt+1)   , funnelView.frame.size.height-space, funnelView.frame.size.width-triangleLine*(self.cnt+1)-60, space)];
    moneyLabel.textColor = UIColorFromRGB(0xD54F50);
    moneyLabel.text = @"49.37万";
    moneyLabel.tag = self.cnt+100;
    moneyLabel.font = [UIFont systemFontOfSize:13];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.numberOfLines = 0;
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    [funnelView addSubview:moneyLabel];
    
    UILabel *hejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, funnelView.frame.size.height-90, kScreenWidth/3, 30)];
    hejiLabel.text = @"合计";
    hejiLabel.font = [UIFont systemFontOfSize:12];
    hejiLabel.textColor = [UIColor redColor];
    [funnelView addSubview:hejiLabel];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, funnelView.frame.size.height-70, kScreenWidth/3, 30)];
    self.numLabel.text = @"项目数：35";
    self.numLabel.font = [UIFont systemFontOfSize:12];
    self.numLabel.textColor = [UIColor redColor];
    [funnelView addSubview:self.numLabel];
    
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, funnelView.frame.size.height-50, kScreenWidth/3, 30)];
    self.amountLabel.text = @"合同额：35万";
    self.amountLabel.font = [UIFont systemFontOfSize:12];
    self.amountLabel.textColor = [UIColor redColor];
    [funnelView addSubview:self.amountLabel];
    
    self.hopeAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, funnelView.frame.size.height-30, kScreenWidth/3, 30)];
    self.hopeAmountLabel.text = @"回款额：35";
    self.hopeAmountLabel.font = [UIFont systemFontOfSize:12];
    self.hopeAmountLabel.textColor = [UIColor redColor];
    [funnelView addSubview:self.hopeAmountLabel];
    
    
    
    UILabel *yujiLabel = [[UILabel alloc] initWithFrame:CGRectMake(funnelView.frame.size.width-kScreenWidth/3+10, funnelView.frame.size.height-70, kScreenWidth/3, 30)];
    yujiLabel.text = @"预计";
    yujiLabel.textAlignment = NSTextAlignmentRight;
    yujiLabel.font = [UIFont systemFontOfSize:12];
    yujiLabel.textColor = [UIColor redColor];
    [funnelView addSubview:yujiLabel];
    
    self.qfnewAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(funnelView.frame.size.width-kScreenWidth/3+10, funnelView.frame.size.height-50, kScreenWidth/3, 30)];
    self.qfnewAmountLabel.text = @"合同额：0万";
    self.qfnewAmountLabel.font = [UIFont systemFontOfSize:12];
    self.qfnewAmountLabel.textAlignment = NSTextAlignmentRight;
    self.qfnewAmountLabel.textColor = [UIColor redColor];
    [funnelView addSubview:self.qfnewAmountLabel];
    
    self.qfnewHopeAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(funnelView.frame.size.width-kScreenWidth/3+10, funnelView.frame.size.height-30, kScreenWidth/3, 30)];
    self.qfnewHopeAmountLabel.text = @"回款额：0万";
    self.qfnewHopeAmountLabel.font = [UIFont systemFontOfSize:12];
    self.qfnewHopeAmountLabel.textAlignment = NSTextAlignmentRight;
    self.qfnewHopeAmountLabel.textColor = [UIColor redColor];
    [funnelView addSubview:self.qfnewHopeAmountLabel];
    
    self.baseLastLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,funnelView.frame.size.height+10, funnelView.frame.size.width-20, 30)];
    self.baseLastLabel.text = @"已签单：0万  已回款：0万";
    self.baseLastLabel.font = [UIFont systemFontOfSize:12];
    self.baseLastLabel.textAlignment = NSTextAlignmentCenter;
    self.baseLastLabel.textColor = UIColorFromRGB(0x333333);
    [funnelView addSubview:self.baseLastLabel];
    
    
}
- (void)funnelDataArray:(NSArray *)array{
    self.dataArray = array;
    
    for (int i=0; i<array.count-1; i++) {
        NSDictionary *dict = array[i];
        UILabel *label = (UILabel *)[self viewWithTag:100+i];
        label.text = [NSString stringWithFormat:@"%@ %@万",dict[@"name"],dict[@"amount"]];
    }
    
    NSDictionary *otherDict = array[array.count-2];
    UILabel *otherLabel = (UILabel *)[self viewWithTag:100+array.count-2];
    otherLabel.text = [NSString stringWithFormat:@"%@\n%@万",otherDict[@"name"],otherDict[@"amount"]];
    
    
    NSDictionary *lastDict = [array lastObject];

    UILabel *nameLabel = (UILabel *)[self viewWithTag:100+array.count-1];
    nameLabel.text = [NSString stringWithFormat:@"%@",lastDict[@"name"]];
    UILabel *amountLabel = (UILabel *)[self viewWithTag:100+array.count];
    amountLabel.text = [NSString stringWithFormat:@"%@万",lastDict[@"amount"]];
    nameLabel.text = @"";
    amountLabel.text = @"";
    self.baseLastLabel.text = [NSString stringWithFormat:@"已签单：%@万  已回款：%@万",lastDict[@"down_payment"],lastDict[@"down_payment_closerate"]];
    [self checkNumChange];
}
- (void)checkNumChange{
    NSInteger amount = 0;
    NSInteger num = 0;
    NSInteger downpay = 0;
    
    NSInteger rightAmount = 0;
    NSInteger rightDownpay = 0;
    self.project_ids = @"";
    
    NSMutableArray *select = [NSMutableArray array];
    [select removeAllObjects];
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        QFCheckView *check = (QFCheckView *)[self viewWithTag:200+i];
        if (check.isCheck == YES) {
            amount = amount + [[NSString stringWithFormat:@"%@",dict[@"amount"]] integerValue];
            num = num + [[NSString stringWithFormat:@"%@",dict[@"pro_num"]] integerValue];
            downpay = downpay + [[NSString stringWithFormat:@"%@",dict[@"down_payment"]] integerValue];
            rightAmount = rightAmount + [[NSString stringWithFormat:@"%@",dict[@"amount_closerate"]] integerValue];
            rightDownpay = rightDownpay + [[NSString stringWithFormat:@"%@",dict[@"down_payment_closerate"]] integerValue];
            self.project_ids = [NSString stringWithFormat:@"%@,%@",dict[@"list"],self.project_ids];
            if ([dict[@"list"] isNotEmpty]&&[dict[@"list"] isKindOfClass:[NSArray class]]) {
                
                 [select addObjectsFromArray:dict[@"list"]];
            }
           
        }
    }
    self.selectArray = select;
    self.project_num = [NSString stringWithFormat:@"%ld",num];
    self.amount = [NSString stringWithFormat:@"%ld",amount];
    self.down_payment = [NSString stringWithFormat:@"%ld",downpay];
    self.rightAmount = [NSString stringWithFormat:@"%ld",rightAmount];
    self.rightDown_payment = [NSString stringWithFormat:@"%ld",rightDownpay];
    
    self.amountLabel.text = [NSString stringWithFormat:@"合同额:%ld万",amount];
    self.numLabel.text = [NSString stringWithFormat:@"项目数:%ld",num];
    self.hopeAmountLabel.text = [NSString stringWithFormat:@"回款额:%ld万",downpay];
    self.qfnewAmountLabel.text = [NSString stringWithFormat:@"合同额:%ld万",rightAmount];
    self.qfnewHopeAmountLabel.text = [NSString stringWithFormat:@"回款额:%ld万",rightDownpay];
    

    
    
    NSArray *array = [self.project_ids componentsSeparatedByString:@","];
    NSMutableArray *idsArray = [NSMutableArray array];
    for (NSString *string  in array) {
        if (string.length>0) {
            [idsArray addObject:string];
        }
    }
    self.project_ids = [idsArray componentsJoinedByString:@","];
    
    if ([self.delegate respondsToSelector:@selector(qf_funnelViewDataChange)]) {
        [self.delegate performSelector:@selector(qf_funnelViewDataChange)];
    }
}

@end
