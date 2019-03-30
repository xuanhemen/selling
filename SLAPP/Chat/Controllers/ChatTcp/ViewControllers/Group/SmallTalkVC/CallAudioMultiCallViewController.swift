//
//  CallAudioMultiCallViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 2018/1/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CallAudioMultiCallViewController: RCCallAudioMultiCallViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //自定义邀请按钮事件
        self.inviteUserButton.addTarget(self, action: #selector(self.inviteUserButtonClicked), for: .touchUpInside)
    }

    @objc func inviteUserButtonClicked() {
        let vc = SelectMemberViewController.init(conversationType: self.conversationType, targetId: self.targetId, mediaType: RCCallMediaType.audio, exist: [sharePublicDataSingle.publicData.im_userid], success: { [weak self](addUserIdList) in
            //邀请用户加入通话
            self?.callSession.inviteRemoteUsers(addUserIdList, mediaType: (self?.mediaType)!)
            
        })
        let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0'", argumentArray: [self.targetId])
        let groupUsers =  GroupUserModel.objects(with: predicate)
        
        vc?.listingUserIdList = groupUsers.value(forKeyPath: "im_userid") as! [Any]
        for userProfile in self.callSession.userProfileList {
            
            vc?.existUserIdList.append((userProfile as! RCCallUserProfile).userId)
        }
        self.present(vc!, animated: true, completion: nil)
    }
}
