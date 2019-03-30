//
//  PublicSize.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ChameleonFramework

let MAIN_SCREEN_WIDTH = UIScreen.main.bounds.size.width  //屏幕宽
let MAIN_SCREEN_HEIGHT = UIScreen.main.bounds.size.height //屏幕高

/*安全高度*/
let SAFE_HEIGHT = CGFloat(MAIN_SCREEN_HEIGHT >= 812 ?34:0)

let ispX:Bool = UIApplication.shared.statusBarFrame.size.height > 20 ? true :false
let NAV_HEIGHT : CGFloat = ispX ? 88 : 64 //导航栏高度
let TAB_HEIGHT : CGFloat = ispX ? 83 : 49 //tab高度
//约束低端距离
let kBottomSpace = 49-TAB_HEIGHT

let kNavBackWidth=21.0               //返回按钮高度
let kNavBackHeight=21.0               //返回按钮高度
let moveRightButton=25.0               //右侧按钮距离调整
let rightButtonFont=16.0               //导航栏右侧按钮字体大小
let LEFT_PADDING : CGFloat = 15.0
let TOP_BOTTOM_PADDING=5.0
let TOP_BOTTOM_BIGPADDING=10.0
let MARGIN=10.0
let BTN_WIDTH=30.0
let SectionView_Height=36.0
let NoDataCell_Height=36.0
let BTNSMARGIN=5.0
let TITLE_LABEL_WIDTH=40.0
let BTN_WIDTH_BIG=80.0
let RIGHT_PADDING=5.0
let kLbLeftPaddingLeft=10
let kLbLeftWidth=100//新增项目中的预计成交时间是6个字，低于90会换行，不解决不能小于90
let kLbTopPadding=10
let KLbLeftAndTfMiddleMargin=5
let kTfHeight=35
let kAddBtnWidth=30
let kImageBtnMargin=20
let kLbLeftTopPadding=10
let kLbMargin=10
let kBtnWidthHeight=40
let kLbDetail_Font=16
let kLbAndBtnMargin=5.0
let kBtnsMargin=0.0
let kLbsMargin=0.0
let kGAP=10 //左右间距
let kBTNSGAP=5 //回复和删除按钮之间的间距
let kAvatar_Size=40 //头像宽高
let kNewVisitAddOneHeight=72.0

/// 行间距
let textLineSpace :CGFloat = 10

//false 在px 上全屏不包含tab最下边的安全区  true 为相反   其他机型还是全屏
let MAIN_SCREEN_HEIGHT_PX = ispX ? MAIN_SCREEN_HEIGHT - TAB_HEIGHT + 49  : MAIN_SCREEN_HEIGHT


func HexColor(_ hexString:String) -> UIColor{
    if hexString.isEmpty {
        return UIColor.gray
    }
    return UIColor.init(hexString:hexString)
}

let kFont_System:(CGFloat)->UIFont = { UIFont.systemFont(ofSize: $0)}//系统字体

let kTfWidth = MAIN_SCREEN_WIDTH - CGFloat(kLbLeftPaddingLeft) * 2.0 - CGFloat(kLbLeftWidth) - CGFloat(KLbLeftAndTfMiddleMargin) - (CGFloat(kAddBtnWidth) + CGFloat(kImageBtnMargin)) * 2.0
let kColorLeft = HexColor("999999")
let KColorRight = HexColor("333333")
let kLbFont = kFont_Big


let kLbColor = HexColor("666666")

let kCommentContentColor = kContentColor



