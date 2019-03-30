//
//  ChatContentCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/4/27.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var nikename: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageIcon.layer.cornerRadius = 20
        imageIcon.clipsToBounds = true
        imageIcon.layer.borderColor = UIColor.lightGray.cgColor
        imageIcon.layer.borderWidth = 0.5
        
        // Initialization code
    }

    func setModel(model:ChatContentModel){
     
       nikename.text = model.name
       content.text  = model.otherInformation
       let date = Date.init(timeIntervalSince1970: TimeInterval(model.time!/1000))
       
        timeLable.text = self.convertDate(date: date)
       imageIcon.sd_setImage(with: URL.init(string: model.portraitUri) , placeholderImage: RCKitUtility.imageNamed("default_portrait_msg", ofBundle: "RongCloud.bundle"))
    
    }
    
    func convertDate(date:Date) -> String {
        if Date.isToday(target: date) {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }else if Date.isLastDay(target: date) {
            return "昨天"
        }else if Date.isOneWeek(target: date) {
            return Date.weekWithDateString(target: date)
        }else{
            return Date.formattDay(target: date)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
