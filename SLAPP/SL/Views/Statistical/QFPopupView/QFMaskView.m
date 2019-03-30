//
//  QFMaskView.m
//  SLAPP
//
//  Created by qwp on 2018/8/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFMaskView.h"
#import "QFHeader.h"
#import "QFMaskSortCell.h"

@interface QFMaskView()<UITableViewDelegate,UITableViewDataSource> {
    
}

@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;



@property (nonatomic,assign)CGFloat currentHeight;

@property(nonatomic,strong)NSMutableArray *carryArray;
@end

@implementation QFMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame andType:0];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.isLeftTable = YES;
        self.leftSelectIndex = 0;
        self.rightSelectIndex = 0;
        self.isLeftSelectDown = YES;
        self.currentHeight = 0;
        [self configUI];
        [self configDataWithType:type];
    }
    return self;
}


-(void)configCarryDown{
    
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width-20)/3, 40)];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3+10, 0, (self.frame.size.width-20)/3, 40)];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
    
    
    self.carryDown = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.width/3, 0, (self.frame.size.width-20)/3, 40)];
    [self.carryDown addTarget:self action:@selector(carryDownButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.carryDown];
}


- (void)configUI{
    [self backViewConfig];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-40)/2, self.frame.size.height/2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
}
- (void)configDataWithType:(NSInteger)type{
    _leftArray = [[NSMutableArray alloc] initWithArray:
                  @[
                    @[@"edittime",@"按更新时间",@"down",@"NO"],
                    @[@"create_time",@"按创建时间",@"down",@"NO"],
                    @[@"analyse_update_time",@"按分析时间",@"down",@"NO"],
                    @[@"dealtime",@"按完成时间",@"down",@"NO"],
                    @[@"trade_name",@"按行业排序",@"down",@"NO"],
                    @[@"name",@"按名称排序",@"down",@"NO"],
                    @[@"amount",@"按金额排序",@"down",@"NO"]
                    ]
                  ];
    if (type == 0) {
        _rightArray = [[NSMutableArray alloc] initWithArray:
                       @[
                         @[@"stage",@"按阶段分组",@"null",@"NO"],
                         @[@"trade",@"按行业分组",@"null",@"NO"],
                         @[@"dep",@"按部门分组",@"null",@"NO"],
                         @[@"user",@"按人分组",@"null",@"NO"],
                         @[@"relation",@"按我与项目的关系",@"null",@"NO"]
                         ]
                       ];
    }else{
        _rightArray = [[NSMutableArray alloc] initWithArray:
                       @[
                         @[@"0",@"全部",@"null",@"NO"],
                         @[@"1",@"我负责的",@"null",@"NO"],
                         @[@"2",@"我参与的",@"null",@"NO"],
                         ]
                       ];
    }
    
    
    
    
}

- (void)backViewConfig{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, kScreenHeight-QFTopHeight)];
    [self addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-5, 0, 10, kScreenHeight-QFTopHeight)];
    [self addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-15, 0, 15, kScreenHeight-QFTopHeight)];
    [self addSubview:view3];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight-QFTopHeight)/2-20)];
    [self addSubview:self.topView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-QFTopHeight)/2+20, kScreenWidth, (kScreenHeight-QFTopHeight)/2-20)];
    [self addSubview:self.bottomView];
    
    NSArray *viewArray = @[view1,view2,view3,self.topView,self.bottomView];
    for (UIView *subView in viewArray) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewToHidden)];
        [subView addGestureRecognizer:tap];
    }
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, (self.frame.size.width-40)/2, 40)];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2+5, 0, (self.frame.size.width-40)/2, 40)];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
}



- (void)qf_showMaskViewWithHeight:(CGFloat)height andTag:(NSInteger)isLeft{
    
    self.carryDownType = isLeft;
    if (isLeft != 2 ) {
        [self configDataWithType:0];
    }else{
        _carryArray = _rightArray;
    }
    
    self.currentHeight = height;
    self.hidden = NO;
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.bottomView.frame = CGRectMake(0, height+40, kScreenWidth, self.frame.size.height-40-height);
    CGFloat topHeight = self.topView.frame.size.height;
    CGFloat bottomHeight = self.bottomView.frame.size.height;
    CGFloat tableHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = (kScreenWidth-20)/3;
    if (isLeft == 0) {
        tableHeight = 40*7;
        x = 0;
    }else if (isLeft == 1){
        tableHeight = 40*5;
        x = (kScreenWidth-20)/3+10;
    }else{
        tableHeight = 40*5;
        x = kScreenWidth - (kScreenWidth-20)/3;
    }
    if (topHeight>bottomHeight) {
        y = tableHeight>topHeight?0:topHeight-tableHeight;
        tableHeight = tableHeight>topHeight?topHeight:tableHeight;
    }else{
        y = self.frame.size.height-bottomHeight;
        tableHeight = tableHeight>bottomHeight?bottomHeight:tableHeight;
    }
    
    CGRect leftButtonFrame = self.leftButton.frame;
    CGRect rightButtonFrame = self.rightButton.frame;
    leftButtonFrame.origin.y = rightButtonFrame.origin.y = height;
    self.leftButton.frame = leftButtonFrame;
    self.rightButton.frame = rightButtonFrame;
    if (isLeft == 0) {
        width =  width < 140 ? 140 : width;
    }else if (isLeft == 1){
        width =  width < 180 ? 180 : width;
        x = (kScreenWidth-width)/2;
    }
    self.tableView.frame = CGRectMake(x, y, width, tableHeight);
    
    _isLeftTable = !isLeft;
    [self.tableView reloadData];
    
}


- (void)qf_showMaskViewWithHeight:(CGFloat)height andIsLeft:(BOOL)isLeft{
    self.currentHeight = height;
    self.hidden = NO;
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, height);
    self.bottomView.frame = CGRectMake(0, height+40, kScreenWidth, self.frame.size.height-40-height);
    CGFloat topHeight = self.topView.frame.size.height;
    CGFloat bottomHeight = self.bottomView.frame.size.height;
    CGFloat tableHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = kScreenWidth/2-20;
    if (isLeft == YES) {
        tableHeight = 40*7;
        x = 15;
    }else{
        tableHeight = 40*5;
        x = kScreenWidth/2+5;
    }
    if (topHeight>bottomHeight) {
        y = tableHeight>topHeight?0:topHeight-tableHeight;
        tableHeight = tableHeight>topHeight?topHeight:tableHeight;
    }else{
        y = self.frame.size.height-bottomHeight;
        tableHeight = tableHeight>bottomHeight?bottomHeight:tableHeight;
    }
    
    CGRect leftButtonFrame = self.leftButton.frame;
    CGRect rightButtonFrame = self.rightButton.frame;
    leftButtonFrame.origin.y = rightButtonFrame.origin.y = height;
    self.leftButton.frame = leftButtonFrame;
    self.rightButton.frame = rightButtonFrame;
    
    self.tableView.frame = CGRectMake(x, y, width, tableHeight);
    _isLeftTable = isLeft;
    [self.tableView reloadData];
}
- (void)tapViewToHidden{
    self.hidden = YES;
}

- (void)leftButtonClick{
    if (self.carryDown) {
        //加了结转
        if (self.carryDownType == 0) {
            self.hidden = YES;
        }else{
            
            [self qf_showMaskViewWithHeight:self.currentHeight andTag:0];
        }
    }else{
        if (_isLeftTable) {
            self.hidden = YES;
        }else{
            [self qf_showMaskViewWithHeight:self.currentHeight andIsLeft:YES];
        }
    }
    
    
    
}
- (void)rightButtonClick{
    
    if (self.carryDown) {
        //加了结转
        if (self.carryDownType == 1) {
            self.hidden = YES;
        }else{
            
            [self qf_showMaskViewWithHeight:self.currentHeight andTag:1];
        }
    }else{
        if (!_isLeftTable) {
            self.hidden = YES;
        }else{
            [self qf_showMaskViewWithHeight:self.currentHeight andIsLeft:NO];
        }
    }
    
    
}

-(void)carryDownButtonClick{
    _rightArray = _carryArray;
    if (self.carryDownType == 2) {
        self.hidden = YES;
    }else{
        
        [self qf_showMaskViewWithHeight:self.currentHeight andTag:2];
    }
}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isLeftTable) {
        return _leftArray.count;
    }else{
        return _rightArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"QFMaskSortCell";
    QFMaskSortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QFMaskSortCell" owner:nil options:nil] lastObject];
    }
    NSArray *array;
    if (_isLeftTable) {
        cell.statusImageView.hidden = NO;
        array = _leftArray[indexPath.row];
        if (_leftSelectIndex == indexPath.row) {
            if (_isLeftSelectDown) {
                cell.statusImageView.image = [UIImage imageNamed:@"p_menu_down"];
            }else{
                cell.statusImageView.image = [UIImage imageNamed:@"p_menu_up"];
            }
        }else{
            cell.statusImageView.image = [UIImage imageNamed:@"p_menu_down"];
        }
    }else{
        cell.statusImageView.hidden = YES;
        array = _rightArray[indexPath.row];
    }
    cell.tyoeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"p_m_s_%@",array[0]]];
    cell.titleLabel.text = array[1];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.carryDown) {
        _carrySelectIndex = indexPath.row;
        
    }else{
        if (_isLeftTable) {
            if (_leftSelectIndex == indexPath.row) {
                _isLeftSelectDown = !_isLeftSelectDown;
            }else{
                _isLeftSelectDown = YES;
            }
            _leftSelectIndex = indexPath.row;
            
        }else{
            _rightSelectIndex = indexPath.row;
        }
        
    }
    
    
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(qf_selectInView:)]) {
        [self.delegate performSelector:@selector(qf_selectInView:) withObject:self];
    }
}
@end

