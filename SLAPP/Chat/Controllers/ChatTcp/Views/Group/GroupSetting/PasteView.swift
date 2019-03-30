//
//  PasteView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/4/26.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class PasteView: UIView {

    typealias sendClickBlock = ()->()
    var click : sendClickBlock?
    
    func sendBtnClick(send:@escaping sendClickBlock){
       click = send
    }
    
    
    @IBAction func sendClick(_ sender: UIButton) {
        
       click?()
        self.removeFromSuperview()
    }
    @IBAction func cancelClick(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 4
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 0.3
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
