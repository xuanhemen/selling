//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */
#import "TimeLineSpecailView.h"
#import "SDTimeLineCell.h"
#import "MenuLable.h"
#import "SDTimeLineCellModel.h"
#import "UIView+SDAutoLayout.h"

#import "SDTimeLineCellCommentView.h"

#import "SDWeiXinPhotoContainerView.h"

#import "SDTimeLineCellOperationMenu.h"

#import "LEETheme.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SLAPP-Swift.h"
#import "ChatKeyBoardMacroDefine.h"
#import "NSString+AttributedString.h"
#import "HYTagView.h"
const CGFloat contentLabelFontSize = 16;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@interface SDTimeLineCell()

@property (nonatomic,strong) UIView *tagView;

@end

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    MenuLable *_contentLabel;
    
    TimeLineSpecailView *_specailView;
    
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    SDTimeLineCellCommentView *_commentView;
    SDTimeLineCellOperationMenu *_operationMenu;
    
    UIButton *_nameBtn;
    UIButton *_iconBtn;
    
    
    
    
    UIButton *_editBtn;
    UIButton *_deleteBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        //设置主题
        [self configTheme];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    _iconView = [UIImageView new];
    _iconBtn = [UIButton new];
    _nameLable = [UILabel new];
    _nameBtn = [UIButton new];
    _nameLable.font = [UIFont systemFontOfSize:17];
    _nameLable.textColor = UIColorFromRGB(0x25B673);
    
    
    
    [_iconBtn addTarget:self action:@selector(userIdClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_nameBtn addTarget:self action:@selector(userIdClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _contentLabel = [MenuLable new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    //    _contentLabel.textColor = [UIColor redColor];
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    
    _specailView = [TimeLineSpecailView new];
    
    
    
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [SDTimeLineCellCommentView new];
    __weak typeof(self) weakSelf = self;
    
    _commentView.didClickCommentWithModel = ^(SDTimeLineCellCommentItemModel *model) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCommentWithModel:cell:)]) {
            [weakSelf.delegate didClickCommentWithModel:model cell:weakSelf];
        }
        //        //点击了某条评论 自己添加
        //        if (weakSelf.didClickCommentWithModel) {
        //            weakSelf.didClickCommentWithModel(model,weakSelf);
        //        }
    };
    
    _commentView.didClickPerson = ^(NSString *userid) {
        if (weakSelf.didClickPerson) {
            weakSelf.didClickPerson(userid);
        }
    };
    
    _peopleLable = [TTTAttributedLabel new];
    _peopleLable.numberOfLines = 0;
    _peopleLable.textColor = UIColorFromRGB(0x888888);
    _peopleLable.font = [UIFont systemFontOfSize:14];
    
    self.tagView = [[UIView alloc] init];
    self.tagView.clipsToBounds = YES;
    //self.tagView.backgroundColor = [UIColor redColor];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    
    _editBtn = [UIButton new];
    [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [_editBtn setTitleColor:UIColorFromRGB(0x25B673) forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deteteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    _operationMenu = [SDTimeLineCellOperationMenu new];
    
    //    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    
    NSArray *views = @[_iconView,_iconBtn, _nameLable, _nameBtn,_contentLabel,_specailView,_moreButton, _picContainerView,_peopleLable, self.tagView,_timeLabel,_editBtn,_deleteBtn, _operationButton, _operationMenu, _commentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _iconBtn.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _nameBtn.sd_layout
    .leftEqualToView(_nameLable)
    .rightEqualToView(_nameLable)
    .topEqualToView(_nameLable)
    .bottomEqualToView(_nameLable);
    
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _specailView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .rightSpaceToView(contentView, margin);
    //    .autoHeightRatio(0);
    
    _peopleLable.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_specailView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    
    self.tagView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_peopleLable, margin)
    .rightEqualToView(_contentLabel)
    .heightIs(50);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(self.tagView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    
    
    //    _deleteBtn.sd_layout
    //    .leftEqualToView(_contentLabel)
    //    .topSpaceToView(_picContainerView, margin)
    //    .rightSpaceToView(contentView, margin)
    //    .heightIs(20);
    
    _deleteBtn.sd_layout
    .rightSpaceToView(contentView, margin+30)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(50);
    
    _editBtn.sd_layout
    .rightSpaceToView(_deleteBtn,- margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(50);
    
    
    _operationButton.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin+5); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
    _deleteBtn.hidden = NO;
    _editBtn.hidden = NO;
    self.tagView.hidden = YES;
    
    
    _picContainerView.refresh = ^{
        
        
        if (weakSelf.imageFinish) {
            weakSelf.imageFinish(weakSelf.indexPath);
            
        }
    };
    
    _specailView.clickSpecailView = ^(NSString *type, NSDictionary *value) {
        //        if (weakSelf.clickSpecailView) {
        //            weakSelf.clickSpecailView(str);
        //        }
        if (weakSelf.clickSpecailView) {
            weakSelf.clickSpecailView(type, value);
        }
    };
    
    
    
}



- (void)configTheme{
    self.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor]);
    
    
    _contentLabel.lee_theme
    .LeeAddTextColor(DAY , UIColorFromRGB(0x333333));
    
    
    _timeLabel.lee_theme
    .LeeAddTextColor(DAY , UIColorFromRGB(0x999999));
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(SDTimeLineCellModel *)model
{
    
    
    
    _model = model;
    
    
    _operationMenu.model = model;
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    //    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.iconName] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@180x180.jpg",_model.iconName]] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    
    _nameLable.text = model.createname;
    
    //    NSString *transString = [NSString stringWithString:[[model.msgContent stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding]];
    //    NSString *transString = [NSString stringWithFormat:@"%@",[[model.msgContent stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding]];
    
    
    //    NSString *transString = [NSString base64DecodeString:model.msgContent];
    NSString *transString = model.msgContent;
    _contentLabel.text = transString;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    for (UIView *subView in self.tagView.subviews) {
        [subView removeFromSuperview];
    }
    if (model.class_list.count == 0||!model.class_list.isNotEmpty||![model.class_list isKindOfClass:[NSArray class]]) {
        self.tagView.sd_layout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_peopleLable, 10)
        .rightEqualToView(_contentLabel)
        .heightIs(0);
        
        _timeLabel.sd_layout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_peopleLable, 10)
        .heightIs(15);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:250];
        self.tagView.hidden = YES;
    }else{
        self.tagView.hidden = NO;
        self.tagView.sd_layout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_peopleLable, 10)
        .rightEqualToView(_contentLabel)
        .heightIs(50);
        
        _timeLabel.sd_layout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(self.tagView, 10)
        .heightIs(15);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:250];
        
        
        
        CGFloat allWidth = 0;
        for (int i=0; i<model.class_list.count; i++) {
            NSDictionary  *dict = model.class_list[i];
            NSString *idString = [NSString stringWithFormat:@"%@",dict[@"id"]];
            NSInteger type = 4;
            if ([idString isEqualToString:@"1"]) {
                type = 0;
            }else if ([idString isEqualToString:@"2"]) {
                type = 1;
            }else if ([idString isEqualToString:@"3"]) {
                type = 2;
            }else if ([idString isEqualToString:@"4"]) {
                type = 3;
            }
            NSString *nameString = [NSString stringWithFormat:@"%@",dict[@"name"]];
            CGFloat strwidth = [self getWidthWithText:nameString height:20 font:14];
            
            
            
            if (model.class_list.count-i>1) {
                if (allWidth+strwidth+10 > kScreenWidth-70-40) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(allWidth, 10, 30, 30)];
                    label.text = @"...";
                    [self.tagView addSubview:label];
                    break;
                }
            }else{
                if (allWidth+strwidth+10 > kScreenWidth-70) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(allWidth, 10, 30, 30)];
                    label.text = @"...";
                    [self.tagView addSubview:label];
                    break;
                }
            }
            
            
            
            HYTagView *subTagView = [[HYTagView alloc] initWithFrame:CGRectMake(allWidth, 10, strwidth+10, 30)];
            [subTagView configTitle:nameString andType:type andIsEdit:NO];
            [subTagView select:YES];
            subTagView.userInteractionEnabled = NO;
            [self.tagView addSubview:subTagView];
            allWidth = allWidth+subTagView.frame.size.width+10;
            
            
        }
        
    }
    DLog(@"%@-内容-%@",model.msgContent,model.class_list);
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _peopleLable.text = _model.otherPeople;
    
    //    _peopleLable.attributedText = [self lineSpaceString:_model.otherPeople lineSpace:5];
    
    
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd"];
    _timeLabel.text = [self distanceTimeWithBeforeTime:[_model.addTime integerValue]];
    
    UserModel *uModel = [UserModel getUserModel];
    
    
    if ([model.createuserid isEqualToString:uModel.id]) {
        _deleteBtn.hidden = NO;
        _editBtn.hidden = NO;
        
        
        //        //NSLog(@"ooooooooooooo----------%@",model.msgContent);
    }else{
        //        //NSLog(@"1111111111111----------%@",model.msgContent);
        _deleteBtn.hidden = YES;
        _editBtn.hidden = YES;
    }
    
    if (_isOnlyShow){
        _deleteBtn.hidden = YES;
        _editBtn.hidden = YES;
    }
    
    
    if ([_model.special_type isNotEmpty]) {
        _specailView.sd_layout.heightIs(100);
        _specailView.model = _model;
        _specailView.hidden = false;
        
        _deleteBtn.hidden = YES;
        _editBtn.hidden = YES;
        
        
    }else{
        _specailView.sd_layout.heightIs(0);
        _specailView.hidden = true;
        
        //        _deleteBtn.hidden = NO;
        //        _editBtn.hidden = NO;
    }
}


-(void)userIdClicked{
    
    if (self.model) {
        if (self.didClickPerson) {
            self.didClickPerson(self.model.createuserid);
        }
    }
    
}

- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}






- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}


-(void)deteteButtonClicked{
    
    if (self.deleteButtonClickedBlock) {
        self.deleteButtonClickedBlock(self.indexPath);
    }
}

-(void)editButtonClicked{
    if (self.editButtonClickedBlock) {
        self.editButtonClickedBlock(self.indexPath);
    }
}



-(NSAttributedString *)lineSpaceString:(NSString *)str lineSpace:(CGFloat)space{
    
    NSMutableAttributedString * aStr =  [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    
    
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = space;
    [aStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return aStr;
    
}


- (void)addSuperWithUserName:(NSString *)userName andProjectName:(NSString *)projectName{
    NSMutableAttributedString *tempPname = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.tailIndent = 0;
    paragraphStyle.headIndent = 0;
    [tempPname appendAttributedString:[[NSAttributedString alloc] initWithString:self.peopleLable.text attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    
    
    
    
    
    if (projectName != nil&&![projectName isEqualToString:@""]) {
        NSRange proRange = [self.peopleLable.text rangeOfString:@"项目名称："];
        [self.peopleLable addLinkToURL:[NSURL URLWithString:@"http://www.xiangmu.com"] withRange:NSMakeRange(proRange.location+proRange.length,projectName.length)];
        [tempPname addAttribute:NSForegroundColorAttributeName value:kgreenColor range:NSMakeRange(proRange.location+proRange.length,projectName.length)];
    }
    if (userName != nil&&![userName isEqualToString:@""]) {
        NSRange proRange = [self.peopleLable.text rangeOfString:@"客户名称："];
        [self.peopleLable addLinkToURL:[NSURL URLWithString:@"http://www.kehu.com"] withRange:NSMakeRange(proRange.location+proRange.length,userName.length)];
        [tempPname addAttribute:NSForegroundColorAttributeName value:kgreenColor range:NSMakeRange(proRange.location+proRange.length,userName.length)];
    }
    self.peopleLable.attributedText = tempPname;
    self.peopleLable.delegate = self;
    self.peopleLable.linkAttributes = @{NSForegroundColorAttributeName:kgreenColor ,NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    [self.peopleLable sizeToFit];
    
    
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([url.relativeString isEqualToString:@"http://www.kehu.com"]) {
        [self.delegate didClickUserWithModel:self.model];
    }
    if ([url.relativeString isEqualToString:@"http://www.xiangmu.com"]) {
        [self.delegate didClickProjectWithModel:self.model];
    }
    
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}



@end

