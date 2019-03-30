//
//  ThemeJoinedListCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ThemeJoinedListCell: ThemeListBaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(bottomView)
        
        bottomView.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.bgView.mas_bottom)!.offset()(0.5)
            make!.left.right().equalTo()(self)
            make!.height.equalTo()(40)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: RCConversationModel!{
        didSet {
            bottomView.backgroundColor = model.isTop ? model.topCellBackgroundColor : model.cellBackgroundColor
            
        }
    }
    override var bottomTitleImgs: Array<Array<String>>?{
        didSet{
            bottomView.creatBtnsWithTitleImage(btnTitleImages: bottomTitleImgs!)
        }
    }
    override class func cell(withTableView tableView: UITableView) -> ThemeJoinedListCell {
        //        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? ThemeListBaseCell
        //        if cell == nil {
        //            cell = ThemeListBaseCell(style: .default, reuseIdentifier: String(describing: self))
        //            cell?.selectionStyle = .none
        //        }
        let cell = ThemeJoinedListCell.init(style: .default, reuseIdentifier: String(describing: self))
        cell.selectionStyle = .none
        
        return cell
    }
    //MARK: - Getter and Setter
    //头像
    lazy var bottomView: ThemeListCellBottomView = {
        var bottomView = ThemeListCellBottomView()
        bottomView.delegate = self
        return bottomView
    }()
}

extension ThemeJoinedListCell : ThemeListCellBottomViewDelegate{

    func menuBtnDidClick(btn: UIButton) {
        if self.btnClickBlock != nil {
            self.btnClickBlock!(btn)
        }
    }
}
