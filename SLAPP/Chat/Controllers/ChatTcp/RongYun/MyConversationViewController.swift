//
//  MyConversationViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/6.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import IQKeyboardManager

class MyConversationViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//       语音消息  暂时还没有确定具体样式 self.conversationMessageCollectionView .register(MyVoiceCell.self, forCellWithReuseIdentifier: "voice")
        
        IQKeyboardManager.shared().isEnabled = false

        
        self.conversationMessageCollectionView .register(MyVoiceCell.self, forCellWithReuseIdentifier: "voice")
//        self.chatSessionInputBarControl.delegate = self
        

        NotificationCenter.default.addObserver(self, selector: #selector(click), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(clickshow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
   @objc func click(notification: NSNotification)
   {
    if self.chatSessionInputBarControl.frame.origin.y>kScreenH-49{
      self.view.frame = CGRect.init(x: 0, y: 0, width:kScreenW, height: kScreenH)
    }
    else
    {
     self.view.frame = CGRect.init(x: 0, y: -49, width:kScreenW, height: kScreenH)
    }
   }
    
    @objc func clickshow(notification: NSNotification)
    {
        self.view.frame = CGRect.init(x: 0, y: 0, width:kScreenW, height: kScreenH)
    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
//    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
//
    
    
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.frame = CGRect.init(x: 0, y: -49, width:kScreenW, height: kScreenH)
        self.view.backgroundColor = UIColor.white
        self.conversationMessageCollectionView.frame = CGRect.init(x: 0, y: 49, width: kScreenW, height: kScreenH-NAV_HEIGHT-49-50)
        self.scrollToBottom(animated: false)
//        make!.top.mas_equalTo()(view)
//        make!.bottom.mas_equalTo()(view)!.mas_offset()(-50)
//        }
//        
//        self.chatSessionInputBarControl.mas_makeConstraints { (make) in
////            make!.top.mas_equalTo()(view)
//            make!.height.mas_equalTo()(50)
//            make!.bottom.mas_equalTo()(view)!.mas_offset()(0)
//        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.conversationMessageCollectionView .frame = CGRect.init(x: 0, y: NAV_HEIGHT, width:kScreenW, height: kScreenH-50-49-NAV_HEIGHT)
//        self.scrollToBottom(animated: false)
//        self.chatSessionInputBarControl.frame = CGRect.init(x: 0, y: kScreenH-50-49, width:kScreenW, height: 50)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        
//        let model:RCMessageModel = self.conversationDataRepository[indexPath.row] as! RCMessageModel
//        if model.objectName == "RC:VcMsg"
//        {
//            let cell:MyVoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "voice", for: indexPath) as! MyVoiceCell
//            cell.setDataModel(model)
//            return  cell as UICollectionViewCell
//        }
//        else
//        {
//            return super.collectionView(collectionView, cellForItemAt: indexPath)
//        }
//    }
    
//    override func didLongTouchMessageCell(_ model: RCMessageModel!, in view: UIView!) {
//        
//      }
    
    

}



//extension MyConversationViewController:RCChatSessionInputBarControlDelegate
//{
//    func present(_ viewController: UIViewController!, functionTag: Int) {
//        
//    }
//}
