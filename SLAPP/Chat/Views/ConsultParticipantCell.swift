//
//  ConsultParticipantCell.swift
//  SLAPP
//
//  Created by rms on 2018/2/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ConsultParticipantCell: UITableViewCell {

    var participantClickBlock : ((_ contactId: String?) -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        let titleLb = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: 200, height: 30))
        titleLb.textColor = UIColor.black
        titleLb.font = kFont_Big
        titleLb.text = "参与人员"
        self.addSubview(titleLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : Array<Dictionary<String,Any>>!{
        didSet{
            
            let colCount = 5
            let singleWidth = (MAIN_SCREEN_WIDTH - 30)/CGFloat(colCount)
            let singleHeight = singleWidth + 30
            
            for i in 0..<model.count {
                let singleView = ContactSingleView.init(modelDic: model[i], frame: CGRect.init(x: singleWidth * CGFloat(i % colCount), y: 40 + singleHeight * CGFloat(i / colCount), width: singleWidth, height: singleHeight))
                singleView.coverBtnClickBlock = ({ [weak self]contactId in
                    if self?.participantClickBlock != nil{
                        self?.participantClickBlock!(contactId)
                    }
                })
                self.contentView.addSubview(singleView)
            }
        }
    }
}
