//
//  RecordView.swift
//  SLAPP
//
//  Created by rms on 2018/1/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SCSiriWaveformView

class RecordView: UIView {

    var progressView : SCSiriWaveformView!
    var controlBtn : UIButton!
    var timeLable : UILabel!
    /// 录音按钮点击事件的回调
    var controlBtnClickBlock : ((_ btn: UIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.layer.cornerRadius = 5
//        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.alpha = 0.9
//
        progressView = SCSiriWaveformView.init()
        progressView.waveColor = .white
        progressView.primaryWaveLineWidth = 1
        progressView.secondaryWaveLineWidth = 1
        progressView.backgroundColor = .clear
//        progressView = UIProgressView.init()
//        progressView.progress = 0.5
        controlBtn = UIButton.init()
        controlBtn.layer.cornerRadius = 3
        controlBtn.layer.masksToBounds = true
        controlBtn.backgroundColor = UIColor.white // UIColor.init(hexString: "157dfa")
        controlBtn.setTitleColor(.red, for: .normal)
        controlBtn.setTitle("完成", for: .normal)
        controlBtn.setTitle("继续录", for: .selected)
        controlBtn.addTarget(self, action: #selector(controlBtnClicked), for: .touchUpInside)
        controlBtn.titleLabel?.font = kFont_Small
        timeLable = UILabel.init()
        timeLable.text = "00:00"
        timeLable.font = kFont_Small
        timeLable.textColor = .white
        
        self.addSubview(progressView)
        self.addSubview(controlBtn)
        self.addSubview(timeLable)
        
        controlBtn.mas_makeConstraints { (make) in
//            make!.top.equalTo()(20)
            make?.centerY.equalTo()(self)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 50, height: 20))
        }
        progressView.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.controlBtn)//?.offset()(-10)
            make!.left.equalTo()(timeLable.mas_right)?.offset()(-LEFT_PADDING)
            make!.right.equalTo()(self.controlBtn.mas_left)?.offset()(-LEFT_PADDING)
            make!.height.equalTo()(50)
        }
        timeLable.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.controlBtn)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 50, height: 20))
//            make!.top.equalTo()(self.progressView.mas_bottom)?.offset()(10)
//            make!.centerX.equalTo()(self.progressView)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更新录音进度数据
    ///
    /// - Parameters:
    ///   - progress: 进度条当前百分比
    ///   - timeStr: 已录音时间
    func updateProgressData(progress: Float,timeStr:String) {
//        progressView.progress = progress
        timeLable.text = timeStr
    }
    
    /// 录音控制按钮点击事件
    ///
    /// - Parameter btn: 录音控制按钮
    @objc func controlBtnClicked(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        if self.controlBtnClickBlock != nil {
            self.controlBtnClickBlock!(btn)
        }
    }
}
