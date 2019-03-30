//
//  MessageCell.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+AttributedString.h"
#import "SLAPP-Swift.h"
#import "CommentCell.h"
#import "NSDate+Extension.h"
#import "HYCommentModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#define showNum 5
@interface CommentCell () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) HYCommentModel *commentModel;
//@property (nonatomic, strong) RLMResults *replyModels;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        kWeakS(weakSelf);
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = kAvatar_Size/2;
        //likeBtn
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.likeBtn setImage:[UIImage imageNamed:@"praise_ico"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"praise_green_ico"] forState:UIControlStateSelected];
        [self.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.likeBtn];
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kGAP);
            make.top.mas_equalTo(weakSelf.headImageView);
            make.width.mas_equalTo(40);
        }];

        // nameLabel
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = kgreenColor;
        self.nameLabel.preferredMaxLayoutWidth = kScreenWidth - kGAP-kAvatar_Size - 2*kGAP-kGAP - 40;
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = kFont(15);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(kGAP);
            make.top.mas_equalTo(weakSelf.headImageView);
            make.right.mas_equalTo(weakSelf.likeBtn.mas_left).offset(-kGAP);
        }];
        // desc
        self.descLabel = [UILabel new];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.preferredMaxLayoutWidth =kScreenWidth - 2*kGAP- kGAP-kAvatar_Size ;
        self.descLabel.numberOfLines = 0;
        self.descLabel.font = kFont(15);
//        self.descLabel.textColor = kCommentContentColor;
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.nameLabel);
            make.right.mas_equalTo(-kGAP);
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(kGAP);
        }];
        
        self.jggView = [JGGView new];
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.descLabel);
            make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(kGAP);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.jggView);
            make.top.mas_equalTo(weakSelf.jggView.mas_bottom).offset(kGAP);
            make.height.mas_equalTo(24);

        }];
        //replyDetailBtn
        self.replyDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyDetailBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        self.replyDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.replyDetailBtn addTarget:self action:@selector(replyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.replyDetailBtn];
        [self.replyDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.timeLabel.mas_right).offset(kGAP);
//            make.top.mas_equalTo(weakSelf.jggView.mas_bottom).offset(kGAP);
            make.centerY.mas_equalTo(weakSelf.timeLabel);
        }];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateSelected];
        [self.deleteBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kGAP);
            make.top.mas_equalTo(weakSelf.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(40);
            make.centerY.mas_equalTo(weakSelf.timeLabel);
            
        }];
        
        
        self.replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        self.replyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.replyBtn];
        [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-(kGAP+kBTNSGAP+40));
            make.top.mas_equalTo(weakSelf.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(40);
            make.centerY.mas_equalTo(weakSelf.timeLabel);
        }];
    
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
        [self.tableView registerClass:[ReplyCell class] forCellReuseIdentifier:@"ReplyCell"];
        [self.contentView addSubview:self.tableView];
        self.tableView.bounces = NO;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.jggView);
            make.top.mas_equalTo(weakSelf.replyBtn.mas_bottom).offset(kGAP);
            make.right.mas_equalTo(-kGAP);
//            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hyb_lastViewInCell = self.tableView;
        self.hyb_bottomOffsetToCell = 0.0;
    }
    
    return self;
}

-(void)deleteAction:(UIButton *)sender{
    if (self.DeleteBtnClickBlock) {
        self.DeleteBtnClickBlock(self.indexPath);
    }
}
-(void)replyAction:(UIButton *)sender{
    if (self.ReplyBtnClickBlock) {
        self.ReplyBtnClickBlock(sender,self.indexPath);
    }
}
-(void)replyDetailAction:(UIButton *)sender{
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(self.indexPath);
    }
}

-(void)likeAction:(UIButton *)sender{
    if (self.LikeBtnClickBlock) {
        self.LikeBtnClickBlock(self.indexPath);
    }

}
- (void)configCellWithModel:(HYCommentModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
//    self.replyModels = [[HYReplyModel objectsWhere:@"comment_id == %@",model.id] sortedResultsUsingKeyPath:@"addtime" ascending:NO];
//    kWeakS(weakSelf);
    
    if (![model.userid isEqualToString:[UserModel getUserModel].id]) {
        self.deleteBtn.hidden = YES;
        [self.replyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kGAP);
        }];
    }else{
        self.deleteBtn.hidden = NO;
        [self.replyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-(kGAP+kBTNSGAP+40));
        }];
    }
    self.nameLabel.text = model.realname;
//    MemberModel *memberModel = [MemberModel objectsWhere:@"userid == %@",model.userid].firstObject;
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@90x90.jpg",BASE_REQUEST_HEAD_URL,memberModel.head]] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    
    
    self.commentModel = model;
//
//    NSString *transString = [NSString stringWithString:[[model.content stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding]];
    NSString *transString = [NSString base64DecodeString:[model.code_content toString]];
//
    self.descLabel.text = transString;
    self.timeLabel.text = [self created_at:[model.addtime toString]];
//
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width = 0.0;
//    RLMResults *fileModels = [Comment_filesModel objectsWhere:@"comment_id == %@ AND tablename == 'cl_comment'",model.id];
    
    
    
    if (model.files.count>0&&model.files.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (model.files.count)*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else if (model.files.count>3&&model.files.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else  if (model.files.count>6&&model.files.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ///布局九宫格
    NSMutableArray *imgArr = [NSMutableArray array];
     NSMutableArray *imgArrBig = [NSMutableArray array];
    kWeakS(weakSelf);
    for (NSDictionary *fileModel in model.files) {
        DLog(@"%@",fileModel);
        NSString *str = [fileModel[@"preview_url_small"] toString];
//        NSString *str = fileModel.filenewname;//[NSString stringWithFormat:@"%@/Application/uploads/%@/%@",BASE_REQUEST__FILE_URL,fileModel.corpid,fileModel.filenewname];
//        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imgArr addObject:str];
        NSString *strBig = [fileModel[@"preview_url"] toString];
        [imgArrBig addObject:strBig] ;
    }
    self.jggView.dataSourceBig = imgArrBig;
    [self.jggView JGGView:self.jggView DataSource:imgArr completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        weakSelf.tapImageBlock(index,dataSource,weakSelf.indexPath);
    }];
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.descLabel);
        make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    [self.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyBtn setTitle:@"回复" forState:UIControlStateHighlighted];
    if (model.replys.count == 0) {
        self.replyDetailBtn.hidden = YES;
    }else{
        self.replyDetailBtn.hidden = NO;
    }
    [self.replyDetailBtn setTitle:[NSString stringWithFormat:@"%ld条回复 >",model.replys.count] forState:UIControlStateNormal];
    [self.replyDetailBtn setTitle:[NSString stringWithFormat:@"%ld条回复 >",model.replys.count] forState:UIControlStateHighlighted];
    NSInteger likeCount = [model.commendernum intValue];
    self.likeBtn.selected = [model.praise intValue];
//    if ([model.commenders isNotEmpty]) {
//        if ([model.commenders containsString:@","]) {
//            likeCount = [model.commenders componentsSeparatedByString:@","].count;
//        }else{
//            likeCount = 1;
//        }
//        if ([model.commenders containsString:[UserModel getUserModel].id]) {
//            self.likeBtn.selected = YES;
//        }else{
//            self.likeBtn.selected = NO;
//        }
//    }else{
//        self.likeBtn.selected = NO;
//    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@" %ld",likeCount] forState:UIControlStateHighlighted];
    if (self.tableView.hidden) {
        return;
    }
    if (model.replys.count == 0 || model.replys.count > showNum) {

//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(weakSelf.contentView).offset(0);
//        }];
        self.hyb_bottomOffsetToCell = 0.0;
    }else{
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(weakSelf.contentView).offset(-kGAP);
//        }];
       self.hyb_bottomOffsetToCell = kGAP;
    }
    CGFloat tableViewHeight = 0;
    if (model.replys.count <= showNum) {

        for (HYReplyModel *replyModel in model.replys) {
            CGFloat cellHeight = [ReplyCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                ReplyCell *cell = (ReplyCell *)sourceCell;
                [cell configCellWithModel:replyModel];
            } cache:^NSDictionary *{
                return @{kHYBCacheUniqueKey : replyModel.id,
                         kHYBCacheStateKey : @"",
                         kHYBRecalculateForStateKey : @(YES)};
            }];
            
//            CGFloat cellHeight = [self.tableView fd_heightForCellWithIdentifier:@"ReplyCell" configuration:^(ReplyCell * cell) {
//                [cell configCellWithModel:replyModel];
//            }];
            tableViewHeight += cellHeight;
        }
    }else{
        for (int i = 0; i < showNum; i++) {
            HYReplyModel *replyModel = self.commentModel.replys[i];
            CGFloat cellHeight = [ReplyCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                ReplyCell *cell = (ReplyCell *)sourceCell;
                [cell configCellWithModel:replyModel];
            } cache:^NSDictionary *{
                return @{kHYBCacheUniqueKey : replyModel.id,
                         kHYBCacheStateKey : @"",
                         kHYBRecalculateForStateKey : @(YES)};
            }];
            tableViewHeight += cellHeight;
            
//             HYReplyModel *replyModel = self.commentModel.replys[i];
//            CGFloat cellHeight = [self.tableView fd_heightForCellWithIdentifier:@"ReplyCell" configuration:^(ReplyCell * cell) {
//                [cell configCellWithModel:replyModel];
//            }];
//            tableViewHeight += cellHeight;
        }
        tableViewHeight += 44;
    }

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
        
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < showNum) {
        
        ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell"];
        if (!cell) {
            cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReplyCell"];
        }
        
        HYReplyModel *model = [self.commentModel.replys objectAtIndex:indexPath.row];

        [cell configCellWithModel:model];
        return cell;
    }else{
    
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"查看全部%ld条回复",self.commentModel.replys.count];
        cell.textLabel.textColor = kgreenColor;
        cell.textLabel.font = kFont(15);
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!self.commentModel || !self.commentModel.replys) {
        return 0;
    }
    
    return self.commentModel.replys.count >= showNum?showNum+1:self.commentModel.replys.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < showNum) {
    HYReplyModel *model = [self.commentModel.replys objectAtIndex:indexPath.row];
//        CGFloat cell_height = [tableView fd_heightForCellWithIdentifier:@"ReplyCell" configuration:^(ReplyCell * cell) {
//            [cell configCellWithModel:model];
//        }];
//        return cell_height;
        CGFloat cell_height = [ReplyCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            ReplyCell *cell = (ReplyCell *)sourceCell;
            [cell configCellWithModel:model];
        } cache:^NSDictionary *{
            NSDictionary *cache = @{kHYBCacheUniqueKey : model.id,
                                    kHYBCacheStateKey : @"",
                                    kHYBRecalculateForStateKey : @(NO)};
            return cache;
        }];
        return cell_height;
       
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < showNum) {
        
        HYReplyModel *replyModel = [self.commentModel.replys objectAtIndex:indexPath.row];
        CGFloat cell_height = 0.0;
//        if (![replyModel.userid isEqualToString:[UserModel getUserModel].id]) {
//
//            cell_height = [ReplyCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
//                ReplyCell *cell = (ReplyCell *)sourceCell;
//                [cell configCellWithModel:replyModel];
//            } cache:^NSDictionary *{
//                NSDictionary *cache = @{kHYBCacheUniqueKey : replyModel.id,
//                                        kHYBCacheStateKey : @"",
//                                        kHYBRecalculateForStateKey : @(NO)};
//                return cache;
//            }];
//        }

        if ([self.delegate respondsToSelector:@selector(passCellHeightWithCommentModel:replyModel:atCommentIndexPath:cellHeight:replyCell:commentCell:)]) {
            ReplyCell *replyCell =  (ReplyCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self.delegate passCellHeightWithCommentModel:self.commentModel replyModel:replyModel atCommentIndexPath:indexPath cellHeight:cell_height replyCell:replyCell commentCell:self];
        }
    }else{
    
        if (self.MoreBtnClickBlock) {
            self.MoreBtnClickBlock(indexPath);
        }
    }
}
- (NSString *)created_at:(NSString *)create_at{
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //代表怎么去解析读取这个时间
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    //指定格式化的一个附加
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSTimeInterval time = [create_at doubleValue];
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *createDate = [formatter dateFromString:[tempDate description]];
    //取出当前时间,进行对比
    NSDate *currentDate = [NSDate date];
    
    //判断是否是今年
    if ([NSDate isThisYearWithTarget:createDate]) {
        //如果是今年,判断是否是今天
        //        if ([self isTodayWithTarget:createDate]) {
        if ([NSDate isTodayWithTarget:createDate]) {
            //是今天
            //怎么判断是否是1分钟之内?
            //            2015-10-10 10:10:00 + 60
            //            2015-10-10 10:10:45
            NSDate *result = [createDate dateByAddingTimeInterval:60];
            
            //判断是否是1分钟之内
            if ([result compare:currentDate] == NSOrderedDescending) {
                return @"刚刚";
            }else{
                //不是分钟之内-->再判断是否是1小时之内
                result = [createDate dateByAddingTimeInterval:3600];
                
                //求出两个时间的差值-->秒数
                NSTimeInterval interval = [currentDate timeIntervalSinceDate:createDate];
                if ([result compare:currentDate] == NSOrderedDescending) {
                    //1小时之内
                    //与现在相差多少分钟
                    NSInteger result = interval / 60;
                    return [NSString stringWithFormat:@"%zd分钟前",result];
                }else{
                    NSInteger result = interval / 3600;
                    return [NSString stringWithFormat:@"%zd小时前",result];
                }
            }
        }else{
            //判断是否是昨天
            if([NSDate isYesterdayWithTarget2:createDate]){
                //就是昨天
                formatter.dateFormat = @"昨天 HH:mm";
                return [formatter stringFromDate:createDate];
            }else{
                formatter.dateFormat = @"MM-dd HH:mm";
                return [formatter stringFromDate:createDate];
            }
            
        }
    }else{
        //不是今年
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [formatter stringFromDate:createDate];
    }
    
    return create_at;
}

@end
