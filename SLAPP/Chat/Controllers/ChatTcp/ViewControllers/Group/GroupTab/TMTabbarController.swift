//
//  TMTabbarController.swift
//  TMSwiftLearn
//
//  Created by harry on 17/2/7.
//  Copyright © 2017年 timer. All rights reserved.
//

import UIKit



//tabbar高度
let kTabBarHeight :Float = 49;
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height



class TMTabbarController: UITabBarController
{
    
    var currentBtn:TMTabbarButton?
    var pointButton:UIButton?
    var projectId = ""
    
  @objc var groupModel:RCConversationModel?{
    
        didSet {
            creatChildViewControllers()
        }
    }
    
    lazy var titleArray:[String] =
    {
//       let array = ["闲聊","话题","文件","公告"]
        let array = ["闲聊","话题"]
       return array
    
    }()
    
//    lazy var vcArray:[String] =
//        {
//            let array = ["ViewController","ViewController","ViewController","ViewController"]
//            return array
//            
//    }()
    
    lazy var imageNomalArray:[String] =
    {
            let array = ["xljm5_Nomal","xljm6_Nomal","xljm8","xljm9"]
            return array
            
    }()
    
    
    lazy var imageSelectArray:[String] =
        {
            let array = ["xljm5_Select","xljm6_Select","xljm8","xljm9"]
            return array
            
    }()
    
    
    
   @objc lazy var bgImageView :UIImageView =
        {
            let img = UIImageView(image: UIImage(named: "find_radio_default"))
            img.contentMode = .scaleAspectFill
            img.layer.masksToBounds = true
            img.isUserInteractionEnabled = true
            return img
            
    }()
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tabBar.isHidden = true
        self.configBackItem()
        creatTab()
//        self.setRightBtnWithArray(items: [UIImage.init(named: "nav_groupSetting")])

//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        
        
        
        self.creatPointButton()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.projectId == "" {
            self.pointButton?.isHidden = true
        }else{
            self.pointButton?.isHidden = false
            
        }
    }
    func creatPointButton() {
        self.pointButton = UIButton.init(type: .custom)
        //self.pointButton?.setTitle("按钮", for: .normal)
        self.pointButton?.frame = CGRect(x: kScreenW-70, y: kScreenH-150, width: 60, height: 60)
        self.pointButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //self.pointButton?.backgroundColor = UIColor.orange
        self.pointButton?.layer.cornerRadius = 30
        self.pointButton?.layer.masksToBounds = true
        self.pointButton?.setImage(UIImage.init(imageLiteralResourceName: "QFxufuaniu"), for: .normal)
        self.pointButton?.addTarget(self, action: #selector(gotoProjectVC), for: .touchUpInside)
        self.view.addSubview(self.pointButton!)
        
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(changePostion(pan:)))
        self.pointButton?.addGestureRecognizer(pan)
        self.pointButton?.isHidden = true
    }
    @objc func gotoProjectVC(){
        PublicPush().pushToProjectVC(id: self.projectId)
    }
    
    @objc func changePostion(pan:UIPanGestureRecognizer) {
        let point:CGPoint = pan.translation(in: self.pointButton!)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let originalFrame = self.pointButton?.frame
        var newFrame = originalFrame
        
        if ((originalFrame?.origin.x)! >= CGFloat(0) && (originalFrame?.origin.x)!+(originalFrame?.size.width)! <= width) {
            
            newFrame?.origin.x = (originalFrame?.origin.x)!+point.x
            
            
        }
        if ((originalFrame?.origin.y)! >= CGFloat(0) && (originalFrame?.origin.y)!+(originalFrame?.size.height)! <= height) {
            
            newFrame?.origin.y = point.y + (originalFrame?.origin.y)!
            
        }
        
        self.pointButton?.frame = newFrame!
        
        pan.setTranslation(CGPoint.zero, in: self.pointButton!)
        
        if (pan.state == UIGestureRecognizerState.began) {
            
            self.pointButton?.isEnabled = false
            
        }else if (pan.state == UIGestureRecognizerState.changed){
            
        } else {
            
            let frame = self.pointButton?.frame
            var nFrame = frame
            //是否越界
            
            var isOver = false
            
            if ((frame?.origin.x)! < CGFloat(0)) {
                
                nFrame?.origin.x = 0;
                
                isOver = true
                
            } else if ((frame?.origin.x)!+(frame?.size.width)! > width) {
                
                nFrame?.origin.x = width - (frame?.size.width)!
                
                isOver = true
                
            }
            if ((frame?.origin.y)! < CGFloat(64)) {
                
                nFrame?.origin.y = 64;
                
                isOver = true
                
            } else if ((frame?.origin.y)!+(frame?.size.height)! > height) {
                
                nFrame?.origin.y = height - (frame?.size.height)!
                
                isOver = true
                
            }
            if (isOver) {
                self.pointButton?.frame = nFrame!
            }
            
            self.pointButton?.isEnabled = true
            
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//         self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rightBtnClick(button: UIButton) {
        let groupSettingVC : GroupSettingViewController = GroupSettingViewController()
        groupSettingVC.targetId = groupModel?.targetId
       self.navigationController?.pushViewController(groupSettingVC, animated: true)
    }
    
    
    /// 是否隐藏tab
    ///
    /// - Parameter isHidden: <#isHidden description#>
    func isHiddenTab(isHidden:Bool){
        
        bgImageView.isHidden = isHidden;
        for view in bgImageView.subviews {
            if view != nil {
                view.isHidden = isHidden
            }
        }
    }

    
    
    /// 消除主题红点显示
    func clearRedPoint(){
    
      let btn:TMTabbarButton? = bgImageView.viewWithTag(1001) as? TMTabbarButton
        if btn != nil {
            btn?.clearBadge()
        }
        
    }
    
    
    /// 显示红点提醒
    ///
    /// - Parameter type: 对应是哪个按钮 左--》右 0..1..2
    func showRedPoint(type:Int){
    
        let btn:TMTabbarButton? = bgImageView.viewWithTag(type+1000) as? TMTabbarButton
        
        if btn != nil {
            
            btn?.badgeCenterOffset = CGPoint.init(x:-(btn?.frame.size.width)!/2+10 , y: 16)
            btn?.showBadge(with: .redDot, value: 0, animationType: .none)
        }
    }
    
    
    
    
}

extension TMTabbarController
{
    
    /// 创建tab
    func creatTab()
    {
        bgImageView.frame = CGRect(x: 0, y: kScreenH - 49, width: kScreenW, height: 49)
        bgImageView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(bgImageView)
    }
    
    
    //MARK: 创建子控制器
    func creatChildViewControllers ()
    {
        for index  in 0..<titleArray.count
        {
           
//           let aClass = getClassWitnClassName(vcArray[index]) as! UIViewController.Type
//           let vc:UIViewController = aClass.init()
//          let nav = TabNavgationVC.init(rootViewController: vc)
//          vc.tabBarItem.title = titleArray[index]
//          vc.tabBarItem.image = UIImage(named:imageNomalArray[index])
//          vc.tabBarItem.selectedImage = UIImage(named:imageSelectArray[index])
//          vc.title = titleArray[index]
//           addChildViewController(nav)
            
           
            var cuVC :UIViewController?
            
            
            switch index {
            case 0:
                
                let vc = SmallTalkVC(conversationType: (groupModel?.conversationType)!, targetId: groupModel?.targetId)
//                let nav = TabNavgationVC.init(rootViewController: vc!)
                          vc?.tabBarItem.title = titleArray[index]
                          vc?.tabBarItem.image = UIImage(named:imageNomalArray[index])
                          vc?.tabBarItem.selectedImage = UIImage(named:imageSelectArray[index])
                          vc?.title = titleArray[index]
                           addChildViewController(vc!)
//                vc?.navigationController?.setNavigationBarHidden(true, animated: false)
//
                 cuVC = vc
            case 1:
                let vc = ThemeListVCViewController.init()
                let nav = BaseNavigationController.init(rootViewController: vc)
                vc.tabBarItem.title = titleArray[index]
                vc.tabBarItem.image = UIImage(named:imageNomalArray[index])
                vc.tabBarItem.selectedImage = UIImage(named:imageSelectArray[index])
                vc.title = titleArray[index]
                addChildViewController(vc)
                cuVC = vc
//            case 2:
//                let vc = UIViewController.init()
//                let nav = TabNavgationVC.init(rootViewController: vc)
//                vc.tabBarItem.title = titleArray[index]
//                vc.tabBarItem.image = UIImage(named:imageNomalArray[index])
//                vc.tabBarItem.selectedImage = UIImage(named:imageSelectArray[index])
//                vc.title = titleArray[index]
//                addChildViewController(nav)
//                cuVC = vc
//            case 1:
//                let vc = TestVC.init()
//                let nav = TabNavgationVC.init(rootViewController: vc)
//                vc.tabBarItem.title = titleArray[index]
//                vc.tabBarItem.image = UIImage(named:imageNomalArray[index])
//                vc.tabBarItem.selectedImage = UIImage(named:imageSelectArray[index])
//                vc.title = titleArray[index]
//                addChildViewController(nav)
//                cuVC = vc
            default: break
                
            }
            
            
            
            let width :CGFloat = kScreenW/CGFloat(titleArray.count)
            let btn:TMTabbarButton = TMTabbarButton.init(frame:CGRect(x: width * CGFloat(index), y: 0, width: width, height: 49 ))

            btn.configWithItem((cuVC?.tabBarItem)!)
            btn.tag = index+1000
            
            bgImageView.addSubview(btn)
            btn.addTarget(self, action: #selector(btnClick(_ :)), for: UIControlEvents.touchUpInside)
            if index == 0 {
                
                self.selectedIndex = 0
                btn.isSelected = true
//                btn.backgroundColor = UIColor.hexString(hexString: "1782D2")
                currentBtn = btn;
            }
            
        }
    }
    
    @objc func btnClick(_ btn:TMTabbarButton)
    {
        
        if (currentBtn != nil)
        {
           currentBtn?.isSelected = false
            currentBtn?.backgroundColor = UIColor.groupTableViewBackground

        }
        btn.isSelected = true
        self.selectedIndex = btn.tag-1000
//        btn.backgroundColor = UIColor.hexString(hexString: "1782D2")
        currentBtn = btn
    
    }

    //获取工程的名字
    func getBundleName() -> String{
        var bundlePath = Bundle.main.bundlePath
        bundlePath = bundlePath.components(separatedBy: "/").last!
        bundlePath = bundlePath.components(separatedBy: ".").first!
        return bundlePath
    }
    //通过类名返回一个AnyClass
    func getClassWitnClassName(_ name:String) ->AnyClass?{
        let type = getBundleName() + "." + name
        return NSClassFromString(type)
    }
    
}
