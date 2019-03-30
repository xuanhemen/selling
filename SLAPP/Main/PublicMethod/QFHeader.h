//
//  QFHeader.h
//  SLAPP
//
//  Created by qwp on 2018/8/3.
//  Copyright © 2018 柴进. All rights reserved.
//

#ifndef QFHeader_h
#define QFHeader_h






#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height



#define kRealHeight(value)  ((value)/1334.0f*kScreenHeight)//6s height

//是否是px
#define kIspX ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 1: 0 )
#define kTab_height    (kIspX?83.0f:49.0f)                                          //tab高度
#define kNav_height  (kIspX?88.0f:64.0f)

#define kMain_screen_height_px (kIspX ? kScreenHeight - kTab_height + 49  : kScreenHeight)



#define QFStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define QFNavBarHeight 44.0
#define QFTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define QFTopHeight (QFStatusBarHeight+QFNavBarHeight)


#undef    AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;
#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}


#endif /* QFHeader_h */
