//
//  HYLookEvaluationSubView.m
//  SLAPP
//
//  Created by apple on 2018/10/18.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookEvaluationSubView.h"

@implementation HYLookEvaluationSubView


-(void)creatcreatImgVsWithCount:(int)count Index:(int)index{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-0.5)*0.5, self.frame.size.width-10*2, 0.5)];
    line.backgroundColor = kgreenColor;
    [self addSubview:line];
    
    for (int i = 1; i <= count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        imageView.image = [UIImage imageNamed:@"evaluate_cicle_hollow"];
        if (index == i) {
            imageView.frame = CGRectMake(0, 0, 19, 19);
            imageView.image = [UIImage imageNamed:@"evaluate_cicle_solid"];
        }
        imageView.center = CGPointMake((i-1)*(self.frame.size.width-10*2)/(count-1)+10, line.center.y);
        [self addSubview:imageView];
    }
    
}


//func creatImgVsWithCountAndIndex(count:Int,index:Int){
//    let singleLineV = UIView.init(frame: CGRect.init(x: 10, y: (self.frame.size.height - 0.5) * 0.5, width: self.frame.size.width - 10 * 2, height: 0.5))
//    singleLineV.backgroundColor = kGreenColor
//    self.addSubview(singleLineV)
//
//    for i in 0..<count {
//        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 14, height: 14))
//        imgV.image = UIImage.init(named: "evaluate_cicle_hollow")
//        if i == index {
//            imgV.frame = CGRect.init(x: 0, y: 0, width: 19, height: 19)
//            imgV.image = UIImage.init(named: "evaluate_cicle_solid")
//        }
//        imgV.center = CGPoint.init(x: CGFloat(i)*(self.frame.size.width - 10 * 2)/(CGFloat(count) - 1) + 10, y: singleLineV.center.y)
//        self.addSubview(imgV)
//    }
//}

@end
