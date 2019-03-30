//
//  Macrol.h
//  FaceKeyboard
//
//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#ifndef ChatKeyBoardMacroDefine_h
#define ChatKeyBoardMacroDefine_h

//#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
//#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define MAIN_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width  //屏幕宽
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //屏幕高
//#define kRealHeight(value)  ((value)/1334.0f*MAIN_SCREEN_HEIGHT)//6s height
#define NAV_HEIGHT  (ispX?88.0f:64.0f)
//是否是px
#define ispX (MAIN_SCREEN_HEIGHT == 812 ? 1: 0 )
#define TAB_HEIGHT    (ispX?83.0f:49.0f)                                          //tab高度


#define MAIN_SCREEN_HEIGHT_PX (ispX ? false ? MAIN_SCREEN_HEIGHT : MAIN_SCREEN_HEIGHT - TAB_HEIGHT + 49  : MAIN_SCREEN_HEIGHT)



#define kFont_Big ([UIFont systemFontOfSize:15])
#define kGreenColor ([UIColor greenColor])

#define kWeakS(weakSelf)  __weak __typeof(&*self)weakSelf = self
/**  判断文字中是否包含表情 */
#define IsTextContainFace(text) [text containsString:@"["] &&  [text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]

/** 判断emoji下标 */
#define emojiText(text)  (text.length >= 2) ? [text substringFromIndex:text.length - 2] : [text substringFromIndex:0]

//ChatKeyBoard背景颜色
#define kChatKeyBoardColor              [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f]




#define kDarkTextColor ([[UIColor darkTextColor] colorWithAlphaComponent:0.6])


//键盘上面的工具条
#define kChatToolBarHeight              100
//picView高度
#define kPicViewHeight                  kRealHeight(200)


//表情模块高度
#define kFacePanelHeight                (ispX ? 256 : 216)
#define kFacePanelBottomToolBarHeight   (ispX ? 80 : 40)
#define kUIPageControllerHeight         25

//拍照、发视频等更多功能模块的面板的高度
#define kMorePanelHeight                (ispX ? 256 : 216)
#define kMoreItemH                      80
#define kMoreItemIconSize               60


//整个聊天工具的高度
#define kChatKeyBoardHeight     kScreenHeight

#define isIPhone4_5                (kScreenWidth == 320)
#define isIPhone6_6s               (kScreenWidth == 375)
#define isIPhone6p_6sp             (kScreenWidth == 414)

#endif /* ChatKeyBoardMacroDefine_h */
