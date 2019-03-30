//
//  SLCluesDetailsHeadView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCluesDetailsHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    /**人名*/
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.black
        name.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        return name
    }()
    /**公司名称*/
    lazy var company: UILabel = {
        let company = UILabel()
        company.textColor = UIColor.lightGray
        company.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(company)
        company.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }
        return company
    }()
    /**状态*/
    lazy var state: UILabel = {
        let state = UILabel()
        state.textColor = UIColor.lightGray
        state.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(state)
        state.snp.makeConstraints { (make) in
            make.top.equalTo(company.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        return state
    }()
    /**所属*/
    lazy var belong: UILabel = {
        let belong = UILabel()
        belong.textColor = UIColor.lightGray
        belong.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(belong)
        belong.snp.makeConstraints { (make) in
            make.top.equalTo(state.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        return belong
    }()
    /**时限*/
    lazy var timeLimit: UILabel = {
        let timeLimit = UILabel()
        timeLimit.textColor = UIColor.lightGray
        timeLimit.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(timeLimit)
        timeLimit.snp.makeConstraints { (make) in
            make.top.equalTo(belong.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        return timeLimit
    }()
    /**负责*/
    lazy var responsible: UILabel = {
        let responsible = UILabel()
        responsible.textColor = UIColor.lightGray
        responsible.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(responsible)
        responsible.snp.makeConstraints { (make) in
            make.top.equalTo(timeLimit.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        return responsible
    }()
    /**来源*/
    lazy var fromSource: UILabel = {
        let fromSource = UILabel()
        fromSource.textColor = UIColor.lightGray
        fromSource.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(fromSource)
        fromSource.snp.makeConstraints { (make) in
            make.top.equalTo(responsible.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        return fromSource
    }()
    
    /**名片照片*/
    lazy var businessCard: UIImageView = {
        let businessCard = UIImageView()
        businessCard.backgroundColor = UIColor.clear
        self.addSubview(businessCard)
        businessCard.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 150, height: 100))
        })
        return businessCard
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
