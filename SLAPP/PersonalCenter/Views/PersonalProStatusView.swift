//
//  PersonalProStatusView.swift
//  SLAPP
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class PersonalProStatusView: UIView {

    var click:(Array<Int>)->() = { _ in
        
    }
    
    var selectArray = Array<Int>()
    
    var model:PersonalModel?
    
    
    
    
  convenience init(model:PersonalModel,frame: CGRect) {
        self.init(frame: frame)
        self.model = model
        self.configUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
       
    }
    
    func configUI(){
//        let array = ["意向","方案","即将成交","商务","赢单"]
        
        let  autoScale = MAIN_SCREEN_WIDTH/750
        let margeLeft:CGFloat = 30
        let margeTop:CGFloat = 30
        let mPadding:CGFloat = 10
        
        let mWidth:CGFloat = autoScale * 520
        let mHeight:CGFloat = autoScale * 440
        
        let count = self.model!.pro_funnel_list.count
        for i in 0..<count {
            
            let lab = UILabel()
            lab.textAlignment = .center
            
            let subModel = self.model!.pro_funnel_list[i]
            let str = subModel.name.appending("\(subModel.amount)").appending("万")
            lab.text = str
            lab.font = UIFont.systemFont(ofSize: 10)
            self.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.centerX.equalTo((1-mPadding/mHeight)*mWidth/2 + margeLeft+mPadding/2)
                make.height.equalTo(20)
                make.width.equalTo(70)
                DLog(CGFloat(i)/CGFloat(count))
                DLog(margeTop+(CGFloat(i)/CGFloat(count)+mPadding/mHeight)*mHeight + 20 )
                make.centerY.equalTo(margeTop+(CGFloat(i)/CGFloat(count)+mPadding/mHeight)*mHeight + 0.5*(1/CGFloat(count)-mPadding/mHeight)*mHeight )
            }
            
            let imageView = UIImageView()
            self.addSubview(imageView)
            imageView.image = #imageLiteral(resourceName: "personalCheckSelect.png")
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints {[weak lab] (make) in
                make.right.equalToSuperview().offset(-50)
                make.width.height.equalTo(15)
                make.centerY.equalTo((lab?.snp.centerY)!)
            }
            
            let btn = UIButton.init(type: .custom)
            self.addSubview(btn)
            imageView.tag = 1000+i
            btn.tag = 1100+i
            btn.snp.makeConstraints {[weak imageView] (make) in
                make.width.equalTo(50)
                make.height.equalTo(30)
                make.center.equalTo(imageView!)
            }
            btn.addTarget(self, action: #selector(btnclick(btn:)), for: .touchUpInside)
            selectArray.append(i)
        }
    }
    
    @objc func btnclick(btn:UIButton){
        if selectArray.contains(btn.tag-1100) {
            selectArray.remove(at: selectArray.index(of: btn.tag-1100)!)
            let im:UIImageView = self.viewWithTag(btn.tag-100) as! UIImageView
            im.image = #imageLiteral(resourceName: "personalCheckNomal")
        }else{
            selectArray.append(btn.tag-1100)
            let im:UIImageView = self.viewWithTag(btn.tag-100) as! UIImageView
            im.image = #imageLiteral(resourceName: "personalCheckSelect.png")
        }
        
        click(selectArray)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
         self.draw()
    }
    
    func draw(){
        let  autoScale = MAIN_SCREEN_WIDTH/750
        let margeLeft:CGFloat = 30
         let margeTop:CGFloat = 30
         let mPadding:CGFloat = 10
        
         let mWidth:CGFloat = autoScale * 520
         let mHeight:CGFloat = autoScale * 440
        let count:CGFloat = CGFloat(self.model!.pro_funnel_list.count)
        let colorArr = [UIColor.hexString(hexString: "46C1DE"),UIColor.hexString(hexString: "41CACB"),UIColor.hexString(hexString: "9ED464"),UIColor.hexString(hexString: "F3BD5F"),UIColor.hexString(hexString: "FF9666")]
        
        guard count > 0 else {
            return
        }
        for a in 0...Int(count-1) {
            let i = CGFloat(a)
            let drawPath = UIBezierPath()
            drawPath.move(to: CGPoint.init(x: margeLeft+(i/count+mPadding/mHeight)*mWidth/2, y: margeTop+(i/count+mPadding/mHeight)*mHeight))
            drawPath.addLine(to: CGPoint.init(x: margeLeft+mWidth-(i/count+mPadding/mHeight)*mWidth/2, y: margeTop+(i/count+mPadding/mHeight)*mHeight))
            drawPath.addLine(to: CGPoint.init(x: margeLeft+mWidth-(i + 1)/count*mWidth/2, y: margeTop+(i + 1)/count*mHeight))
            drawPath.addLine(to: CGPoint.init(x: margeLeft+(i + 1)/count*mWidth/2, y: margeTop+(i + 1)/count*mHeight))
            drawPath.close()
        
            colorArr[a%5].set()
            drawPath.fill()
           
        }
        
        
    }
}
