//
//  HYRaderCell.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYRaderCell.h"

@implementation HYRaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _radar = [[RadarChartHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        [self.contentView addSubview:_radar];
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    _radar.type = _type;
    _radar.dataArray = dataArray;
    
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
