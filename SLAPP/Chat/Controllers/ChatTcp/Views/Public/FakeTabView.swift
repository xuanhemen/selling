//
//  FakeTabView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/4/24.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

enum fakeType {
    case friend
    case group
    case finding
    case course
    case mine
}

class FakeTabView: UIView {
    
    typealias myBlcok = (_ type:fakeType)->()
    var clickType:myBlcok?
    
    var myRedCount = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        congigUI(menuList: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func congigUI(menuList:Array<String>?){
        //        self.backgroundColor = UIColor.hexString(hexString: "272727")
        
        if self.subviews.count != 0  {
            self.removeAllSubview()
        }
        var newMenuList = Array<String>()
        
        
        if menuList == nil {
            newMenuList = ["friends","group","find","classes","center"]
        }
        else{
            newMenuList = menuList!
        }
        
        DLog(newMenuList)
        DLog(self)
        
        let btnW = kScreenW/CGFloat(newMenuList.count)
        //        let btnW:CGFloat = 100
        //        var titleArray = ["朋友圈","群组","发现","课程","我的"]
        //        var imageArray = ["friend","groups","find","class","my"]
        var titleArray = Array<String>()
        var imageArray = Array<String>()
        for menu in newMenuList {
            switch menu {
            case "friends":
                titleArray.append("朋友圈")
                imageArray.append("friend")
            case "group":
                titleArray.append("群组")
                imageArray.append("groups")
            case "find":
                titleArray.append("发现")
                imageArray.append("find")
            case "classes":
                titleArray.append("课程")
                imageArray.append("class")
            case "center":
                titleArray.append("我的")
                imageArray.append("my")
            default:
                titleArray.append("我的")
                imageArray.append("my")
            }
        }
        
        DLog(titleArray)
        
        for i in 0...titleArray.count-1 {
            
            let btn = CustomBtn.init(type: .custom)
            btn.frame = CGRect(x: 0 + CGFloat(i) * btnW , y: 0, width: btnW, height: 56)
            
            btn.setImage(UIImage.init(named: imageArray[i]), for: .normal)
            btn.setImage(UIImage.init(named: imageArray[i]), for: .selected)
            btn.setTitle(titleArray[i], for: .normal)
            btn.setImage(UIImage.init(named: imageArray[i]), for: .selected)
            btn.setTitle(titleArray[i], for: .disabled)
            
            let btnName = btn.title(for: .normal)!
            
            switch btnName {
            case "朋友圈":
                btn.tag = 1000
                break
            case "群组":
                btn.tag = 1001
                break
            case "发现":
                btn.tag = 1002
                break
            case "课程":
                btn.tag = 1003
                break
            case "我的":
                btn.tag = 1004
                break
            default:
                break
            }
            
            self.addSubview(btn)
            btn.addTarget(self, action: #selector(btnClick(btn: )), for: .touchUpInside)
            if i == 1 {
                //                btn.isEnabled = false
                btn.backgroundColor = UIColor.hexString(hexString: "1782D2")
            }
            else{
                btn.backgroundColor = UIColor.hexString(hexString: "272727")
            }
        }
        if myRedCount != 0 {
            self.showBage(type: .mine, bage: myRedCount)
        }
        self.showBage(type: .group, bage: Int(RCIMClient.shared().getTotalUnreadCount()))
    }
    
    func removeAllSubview(){
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    
    
    @objc func btnClick(btn:CustomBtn){
        let name = btn.title(for: UIControlState.normal)!
        
        switch name {
        case "朋友圈":
            clickType?(.friend)
            break
        case "群组":
            clickType?(.group)
            break
        case "发现":
            clickType?(.finding)
            break
        case "课程":
            clickType?(.course)
            break
        case "我的":
            clickType?(.mine)
            break
        default:
            break
        }
        
        
        
    }
    
    
    
    /// 点击tab按钮的响应
    ///
    /// - Parameter type: 会传入具体的类型
    func fakeType(type:@escaping myBlcok){
        clickType = type
    }
    
    
    /// 显示提示个数的小红点
    ///
    /// - Parameters:
    ///   - type: 显示到哪个按钮
    ///   - bage: 红点个数
    func showBage(type:fakeType,bage:Int){
        
        var btn : CustomBtn?
        switch type {
        case .friend:
            btn = self.viewWithTag(1000) as? CustomBtn
            break
        case .group:
            btn = self.viewWithTag(1001) as? CustomBtn
            
            break
        case .finding:
            btn = self.viewWithTag(1002) as? CustomBtn
            
            break
        case .course:
            btn = self.viewWithTag(1003) as? CustomBtn
            
            break
        case .mine:
            btn = self.viewWithTag(1004) as? CustomBtn
            myRedCount = bage
            break
        default:
            break
        }
        
        if btn != nil {
            btn?.badgeCenterOffset = CGPoint.init(x: -34, y: 13)
            btn?.showBadge(with: .number, value: bage, animationType: .none)
        }
        
    }
    
}
