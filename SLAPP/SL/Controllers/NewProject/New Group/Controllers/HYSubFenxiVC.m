//
//  HYSubFenxiVC.m
//  SLAPP
//
//  Created by yons on 2018/11/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYSubFenxiVC.h"
#import <Masonry/Masonry.h>
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
@interface HYSubFenxiVC ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat maxValue;


@end

@implementation HYSubFenxiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxValue = 50;
    [self configUI];
    [self configData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    tabVC.tab.hidden = YES;
    tabVC.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)configData{
    UserModel *model = UserModel.getUserModel;
    kWeakS(weakSelf);
    [self showOCProgress];
    NSDictionary *params = @{
                             @"project_id":self.projectId,
                             @"logic_id":self.logic_id,
                             @"token":model.token};

    
    [LoginRequest getPostWithMethodName:self.urlString params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        
        [weakSelf showDismiss];
        
        NSLog(@"%@",a);
        NSArray *drawingArray = a[@"drawing"];
        NSArray *tipsArray = a[@"tips"];
        weakSelf.maxValue = [[a[@"max"] toString] floatValue];
        [weakSelf configChartViewWithArray:drawingArray];
        [weakSelf configLabel:tipsArray];
        
    }];
    
}
- (void)configUI{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = UIColorFromRGB(0xEFEFF3);
    [self.scrollView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"qf_luopanfenxi"];
    [titleView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    UILabel *newlabel = [[UILabel alloc]init];
    newlabel.text = @"罗盘分析";
    newlabel.textColor = UIColorFromRGB(0x666666);
    newlabel.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:newlabel];
    
    [newlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(imageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    
    
}


- (void)configChartViewWithArray:(NSArray *)array{
    UIView *chartbackView = [[UIView alloc] init];
    chartbackView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.scrollView addSubview:chartbackView];
    
    [chartbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(kScreenWidth);
        make.left.right.mas_equalTo(0);
    }];
    
    if (![array isKindOfClass:[NSArray class]]||array==nil) {
        return;
    }
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        [nameArray addObject:[dict[@"name"] toString]];
        [valueArray addObject:@([[dict[@"value"] toString] floatValue])];
    }
    
    QFRadarChartView *radarView = [[QFRadarChartView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, kScreenWidth-20)];
    
    radarView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    radarView.yAxisMaximum = self.maxValue;
    radarView.yAxisTags = nameArray;
    [radarView configUIDontShowTitle];
    
    UIColor *color = [UIColor colorWithRed:231/255.0 green:102/255.0 blue:60/255.0 alpha:1];
    
    RadarChartDataSet *entry = [radarView addChartsDataWithTitle:self.title valueArr:valueArray lineColor:color lineWidth:1 fillColor:color fillAlpha:0.5];
    [radarView setChartDataWithSetArray:@[entry]];
    [chartbackView addSubview:radarView];
}
- (void)configLabel:(NSArray *)array{
    UIView *currentLine;
    
    for (int i=0; i<array.count; i++) {
        UILabel *newlabel = [[UILabel alloc]init];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", array[i]]];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        newlabel.attributedText = string;
        //newlabel.text = [NSString stringWithFormat:@"%@", array[i]];
        newlabel.numberOfLines = 0;
        newlabel.font = [UIFont systemFontOfSize:14];
        newlabel.textColor = UIColorFromRGB(0x333333);
        [self.scrollView addSubview:newlabel];
        
        [newlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (currentLine == nil) {
                make.top.mas_equalTo(kScreenWidth+40+20);
            }else{
                make.top.equalTo(currentLine.mas_bottom).mas_equalTo(20);
            }
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-15);
        }];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.font = [UIFont systemFontOfSize:16];
        numLabel.textColor = UIColorFromRGB(0xFFFFFF);
        numLabel.backgroundColor = UIColorFromRGB(0x6ABD76);
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.text = [NSString stringWithFormat:@"%d",i+1];
        numLabel.layer.cornerRadius = 15;
        numLabel.clipsToBounds = YES;
        [self.scrollView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(newlabel.mas_top);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(30);
        }];
        
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [self.scrollView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.equalTo(newlabel.mas_bottom).mas_offset(15);
            
            if (i==array.count-1) {
                make.bottom.mas_equalTo(0);
            }
        }];
        
        currentLine = line;
        
        
        
    }
    
    
}
//func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//    //QF -- mark -- 调整行间距
//    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineSpacing = 10
//    let setStr = NSMutableAttributedString.init(string: text)
//    setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
//    label.numberOfLines = 0
//    label.lineBreakMode = NSLineBreakMode.byWordWrapping
//    label.font = font
//    label.attributedText = setStr
//    label.sizeToFit()
//    return label.frame.height+label.font.ascender
//}
@end
