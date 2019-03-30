//
//  DatePicker.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class DatePicker: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
//        resultTimeStr(nil,Int(datePicker.date.timeIntervalSince1970))
        self.removeFromSuperview()
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        let fomatter = DateFormatter.init()
        if isTime {
            fomatter.dateFormat = "yyyy-MM-dd HH:mm"
        }else{
            fomatter.dateFormat = "yyyy-MM-dd"
        }
        let dateStr = fomatter.string(from: datePicker.date)
        
        resultTimeStr(dateStr,Int(datePicker.date.timeIntervalSince1970))
        self.removeFromSuperview()
    }
    
    var resultTimeStr:(_ str:String?,_ timrInt:Int)->() = {a,b in}
    var isTime = false{
        didSet{
            if isTime{
                datePicker.datePickerMode = .dateAndTime
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.setTitleColor(kGreenColor, for: .normal)
        sureBtn.setTitleColor(kGreenColor, for: .normal)
        datePicker.datePickerMode = .date
    }
    
    func showInVC(view:UIView) {
        self.frame = CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT, width: SCREEN_WIDTH, height: 200)
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-200, width: SCREEN_WIDTH, height: 200)
        }
        view.addSubview(self)
    }
    
}
