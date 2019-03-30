//
//  HYNewClientVC.h
//  SLAPP
//
//  Created by qwp on 2018/11/23.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYNewClientVC : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faxHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *urlHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fujiaHeight;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareHeight;

@property (weak, nonatomic) IBOutlet UITextField *clientField;
@property (weak, nonatomic) IBOutlet UITextField *tradeField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *belongField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *memberNumField;
@property (weak, nonatomic) IBOutlet UITextField *faxField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;

@end
