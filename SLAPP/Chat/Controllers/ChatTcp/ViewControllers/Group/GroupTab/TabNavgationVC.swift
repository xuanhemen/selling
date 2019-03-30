//
//  TabNavgationVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/8.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class TabNavgationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
       let bar = UINavigationBar.appearance()
        bar.barTintColor = UIColor.black
        bar.tintColor = UIColor.white
        
        var attrs = [NSAttributedStringKey : AnyObject]()
        
        attrs[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 17)
        attrs[NSAttributedStringKey.foregroundColor] = UIColor.white
        bar.titleTextAttributes = attrs

        
    }
    
    
   
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            
            let backBtn :UIButton = UIButton.init(type: .custom)
            backBtn.frame = CGRect.init(x: 0, y: 0, width: kNavBackWidth*3, height: kNavBackHeight*2)
            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-40,0,0);
            //        backBtn.setTitle("返回", for: .normal)
            backBtn.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
            backBtn.sizeToFit()
            backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            let barItem :UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
            viewController.navigationItem.backBarButtonItem = barItem
            
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc func btnClick()
    {
        if self.childViewControllers.count>1 {
            let Tab:TMTabbarController = self.childViewControllers[1] as! TMTabbarController
            let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
            smak.clearInputText()
            self.popViewController(animated: true)

        }
        else
        {
            let nav = self.tabBarController?.navigationController
            nav?.popViewController(animated: true)
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
