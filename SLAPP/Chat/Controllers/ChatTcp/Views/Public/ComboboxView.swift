//
//  ComboboxView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

@objc protocol ComboboxViewDelegate {
    func comboboxViewOneRowClick(button:UIButton)
}
class ComboboxView: UIView {

   weak var delegate : ComboboxViewDelegate?
    convenience init(titles : Array<String>, imageNames : Array<Array<String>>?, bgImgName : String?, frame:CGRect) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear

        let comboboxView = UIView.init(frame: frame)
        self.addSubview(comboboxView)
        //顶部边距
        let topPadding : CGFloat = TOP_PADDING
        //背景颜色
        if bgImgName == nil {
            comboboxView.backgroundColor = UIColor.black
            comboboxView.alpha = 0.5
        } else {
            let imgBG = UIImageView.init(frame: comboboxView.bounds)
            imgBG.image = UIImage.init(named: bgImgName!)
            comboboxView.addSubview(imgBG)
        }
        
        //留白
        let blankSpace = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: topPadding))
        blankSpace.backgroundColor = UIColor.clear
        comboboxView.addSubview(blankSpace)
        for index in 0..<titles.count {
            let oneRow = UIButton.init(frame: CGRect.init(x: 0, y: CGFloat(index) * oneRow_height + topPadding + 1, width: frame.size.width, height: oneRow_height))
            oneRow.tag = index + 10
            oneRow.contentVerticalAlignment = .center
            //文字
            let finalText = (imageNames?.count)! > 0 ? "  ".appending(titles[index]) : titles[index]
            oneRow.setTitleColor(UIColor.white, for: .normal)
            oneRow.titleLabel?.font = FONT_14
            oneRow.setTitle(finalText, for: .normal)
            
            //图片
            if (imageNames?.count)! > 0 {
                let norImgName : String? = imageNames?[0][index]
                let selImgName : String? = imageNames?[1][index]
                oneRow.setImage(UIImage.init(named: norImgName!), for: .normal)
                oneRow.setImage(UIImage.init(named: selImgName!), for: .highlighted)
            }
            oneRow.addTarget(self, action: #selector(clickOneRow), for: .touchUpInside)
            comboboxView.addSubview(oneRow)
            
            if (index > 0) {
                //分割线
                let line = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(index) * oneRow_height + topPadding, width: frame.size.width, height: 1))
                line.backgroundColor = UIColor.hexString(hexString: "d6d2d2")
                comboboxView.addSubview(line)
            }
        }
    }
    @objc func clickOneRow(button:UIButton) {
        self.removeFromSuperview()
        delegate?.comboboxViewOneRowClick(button: button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
}

