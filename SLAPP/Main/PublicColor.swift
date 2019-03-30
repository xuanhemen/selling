//
//  PublicColor.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit


let kNavBarBGColor =  HexColor("43be5f")//nav背景颜色
let kTabBarBGColor =  HexColor("fdfdfd")//tab 背景颜色
let kColor_NavBarTitle = UIColor.white        //nav bar 颜色设置 文字

let kNavAddImage = UIImage(named: "nav_add")//[UIImage imageNamed:@"nav_add"]//添加
let kNavBackImage = UIImage(named: "icon-arrow-left")//[UIImage imageNamed:@"nav_back"]//返回
let kNavCustomerImage = UIImage(named: "nav_customer")//[UIImage imageNamed:@"nav_customer"]//添加用户
let kNavMoreImage = UIImage(named: "nav_more")//[UIImage imageNamed:@"nav_more"]//更多

func kColorRGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor { return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
func kColorRGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor { return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1) }

let kTitleColor = HexColor("666666")
let kContentColor = HexColor("333333")

let kGreenColor = HexColor("43be5f")
let kOrangeColor = HexColor("FF8D3A")
let kBlueColor = HexColor("3FAFEF")

let kTextGrayColor = UIColor.lightGray

let kGrayColor = HexColor("F4F4F4")
let kSepLineColor = HexColor("D2D2D2")
//tableview的section背景灰色
let kGrayColor_sectionBg = HexColor("E6E5E7")
//云教练灰颜色
let kGrayColor_Slapp = HexColor("323542")//首页背景图颜色
let kGrayColor_Slapp2 = HexColor("434652")//半透颜色

//new
let kNavBarBGColor_Black = HexColor("333333")
let kVisitNewTopBig = HexColor("F77E11")//orange
let kVisitNewTopSmall = HexColor("AFBEC6")//yin
let kBtnBackGray = HexColor("AAAAAA")//按钮灰
let kVisitNewNameOrange = HexColor("F8832E")//orange
let kVisitInputTextBackColor = HexColor("F4F6F7")//莫名灰
let kVisitBoundColor = HexColor("CCCCCC")//边框灰
let kCardNoSelectColor = HexColor("84879D")//card未选中灰

//projectList
let kProjectGreen = HexColor("23B675")
let kProjectGray = HexColor("8C8C8C")

let kBackGreen = HexColor("49BE8C")


//字体颜色
let kTextColor_Black = UIColor.black     //黑色
let kTextColor_Gray  = UIColor.lightGray //灰色

//全局字体  界面中都统一用三种字号来处理   大 中 小
let kFont_Big = UIFont.systemFont(ofSize: 16)
let kFont_Middle = UIFont.systemFont(ofSize: 14)
let kFont_Small = UIFont.systemFont(ofSize: 12)


//边距
let kSpace_Left = 15.0  //普通 一级  左边距  cell  section
let kSpace_Left_Level = 25.0 //拜访界面的二级 缩进
let kSpace_Right = 15.0  //普通 一级  右边距  cell  section
let kSpace_Certical = 10.0 //竖方向的间距
let kSpace_Cell = 10.0  //相邻cell 上下的间距

//高度
let kHeight_Section_HeaderView:CGFloat =  40.0

let kHeight_Greenline = 15.0 //绿线高度  sectionHeaderView  上的绿线
let kWidth_Greenline = 2.0   //绿线宽度

let AutoScale = MAIN_SCREEN_WIDTH/750.0

/*颜色RGBA*/
func RGBA(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) -> UIColor {
    let color:UIColor = UIColor.init(red: R/255, green: G/255, blue: B/255, alpha: A)
    return color
}
let colorNormal = RGBA(R: 50, G: 50, B: 50, A: 1)
let colorLight = RGBA(R: 100, G: 100, B: 100, A: 1)

let SLGreenColor = RGBA(R: 37, G: 171, B: 96, A: 1)
