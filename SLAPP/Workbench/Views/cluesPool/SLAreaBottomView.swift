//
//  SLAreaBottomView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

/**传值*/
protocol AreaDelegate {
    func passAreaInfo(name: String,provinceID: String,cityID: String,areaID: String)
}
class SLAreaBottomView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    /**数据源*/
    var dataArr = [SLProvinceModel]()
    /**城市数据源*/
    var cityDataArr = [SLCityeModel]()
    /**地区数据源*/
    var areaDataArr = [SLAreaModel]()
    
    var provinceModel:SLProvinceModel?
    
    var cityModel:SLCityeModel?
    
    var areaModel:SLAreaModel?
    /**滚动视图*/
    var scrollView = UIScrollView()
    /**色块*/
    let colorView = UIView()
    /**装省市区btn*/
    var btnArr:[UIButton] = []
    /**记录省*/
    var provinceName:String = ""
    /**代理*/
    var delegate:AreaDelegate?
    /**视图消失通知---特殊需求*/
    typealias ViewDismiss = () -> Void
    var dismissNotice: ViewDismiss?
    
    convenience init(array: [SLProvinceModel]){
        self.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 350))
        dataArr = array
    }
    func show(){
        self.backWindow.isHidden = false
        UIView.animate(withDuration: 0.3) {
            var center = self.center
            center.y -= 350
            self.center = center
        }
        provinceTV.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        let text = UILabel()
        text.text = "所有地区"
        text.textColor = colorNormal
        text.font = FONT_17
        topView.addSubview(text)
        text.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
        }
        let chooseView = UIView()
        chooseView.backgroundColor = UIColor.white
        self.addSubview(chooseView)
        chooseView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        for index in 0..<3{
            let chooseBtn = UIButton.init(type: UIButtonType.custom)
            chooseBtn.backgroundColor = UIColor.clear
            chooseBtn.setTitle("请选择", for: UIControlState.normal)
            chooseBtn.setTitleColor(RGBA(R: 190, G: 34, B: 47, A: 1), for: UIControlState.normal)
            chooseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            chooseBtn.tag = index
            chooseBtn.addTarget(self, action: #selector(moveColorView), for: UIControlEvents.touchUpInside)
            chooseView.addSubview(chooseBtn)
            chooseBtn.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(60*index)
                make.size.equalTo(CGSize(width: 60, height: 40))
            })
            btnArr.append(chooseBtn)
            if index == 0{
                colorView.backgroundColor = RGBA(R: 190, G: 34, B: 47, A: 1)
                chooseView.addSubview(colorView)
                colorView.snp.makeConstraints { (make) in
                    make.centerX.equalTo(chooseBtn)
                    make.bottom.equalToSuperview().offset(-3)
                    make.size.equalTo(CGSize(width: 50, height: 3))
                }
            }
        }
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH*3, height: 0)
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview().inset(UIEdgeInsetsMake(80, 0, SAFE_HEIGHT, 0))
        }
        let clearView = UIView()
        clearView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        clearView.backgroundColor = UIColor.clear
        self.backWindow.addSubview(clearView)
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        clearView.addGestureRecognizer(ges)
        
        self.backWindow.addSubview(self)
        
    }
    lazy var backWindow: UIWindow = {
        let backWindow = UIWindow.init(frame: UIScreen.main.bounds)
        backWindow.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 0.5)
        backWindow.isHidden = true
        backWindow.windowLevel = UIWindowLevelAlert
        return backWindow
    }()
    //MARK: - 视图消失
    @objc func dismissView(){
        
        UIView.animate(withDuration: 0.3, animations: {
                var center = self.center
                center.y += 350
                self.center = center
        }) { (true) in
            /**视图消失通知*/
            self.dismissNotice!()
            self.backWindow.isHidden = true
            self.backWindow.removeFromSuperview()
        }
       
    }
    func passVlue(){
        let name = (provinceModel?.name)!+(cityModel?.name)!+(areaModel?.name)!
        self.delegate?.passAreaInfo(name: name, provinceID: (provinceModel?.id!)!, cityID: (cityModel?.id!)!, areaID: (areaModel?.id!)!)
        self.dismissView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var provinceTV: UITableView = {
        let provinceTV = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        provinceTV.backgroundColor = UIColor.white
        provinceTV.tag = 0
        provinceTV.delegate = self
        provinceTV.dataSource = self
        provinceTV.tableFooterView = UIView()
        provinceTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        print(scrollView.frame.size.height)
        provinceTV.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height-80-SAFE_HEIGHT)
        scrollView.addSubview(provinceTV)
        
        return provinceTV
    }()
    lazy var cityTV: UITableView = {
        let cityTV = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
         cityTV.backgroundColor = UIColor.white
        cityTV.tag = 1
        cityTV.delegate = self
        cityTV.dataSource = self
        cityTV.tableFooterView = UIView()
        cityTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cityTV.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height-80-SAFE_HEIGHT)
        scrollView.addSubview(cityTV)
        return cityTV
    }()
    lazy var areaTV: UITableView = {
        let areaTV = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
         areaTV.backgroundColor = UIColor.white
        areaTV.tag = 2
        areaTV.delegate = self
        areaTV.dataSource = self
        areaTV.tableFooterView = UIView()
        areaTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        areaTV.frame = CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height-80-SAFE_HEIGHT)
        scrollView.addSubview(areaTV)
        return areaTV
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag==0 {
             return  self.dataArr.count
        }else if tableView.tag==1{
             return self.cityDataArr.count
        }else{
             return self.areaDataArr.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = colorLight
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = RGBA(R: 211, G: 56, B: 52, A: 0.3)
        cell.textLabel?.highlightedTextColor = .white

        if tableView.tag==0 {
             let model = self.dataArr[indexPath.row]
             cell.textLabel?.text = model.name
        }else if tableView.tag==1{
            let model = self.cityDataArr[indexPath.row]
             cell.textLabel?.text = model.name
        }else{
            let model = self.areaDataArr[indexPath.row]
             cell.textLabel?.text = model.name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag==0 {
            let model = self.dataArr[indexPath.row]
            if model.name != provinceName{
               let button = btnArr[tableView.tag+1]
                 button.setTitle("请选择", for: UIControlState.normal)
            }
            provinceName = model.name!
            provinceModel = model
            self.cityDataArr = model.city!
            self.cityTV.reloadData()
            /**改变btn的title*/
            let button = btnArr[tableView.tag]
            button.setTitle(model.name, for: UIControlState.normal)
            /**点击cell移动色块和scrollview*/
            let btn = btnArr[tableView.tag+1]
            self.moveColorView(btn: btn)
        }else if tableView.tag==1{
            let model = self.cityDataArr[indexPath.row]
            cityModel = model
            self.areaDataArr = model.area!
            self.areaTV.reloadData()
            /**改变btn的title*/
            let button = btnArr[tableView.tag]
            button.setTitle(model.name, for: UIControlState.normal)
            let btn = btnArr[tableView.tag+1]
            self.moveColorView(btn: btn)
        }else{
            let model = self.areaDataArr[indexPath.row]
            areaModel = model
            /**改变btn的title*/
            let button = btnArr[tableView.tag]
            button.setTitle(model.name, for: UIControlState.normal)
            self.passVlue()
        }
    }
    /**移动色块*/
    @objc func moveColorView(btn: UIButton) {
       UIView.animate(withDuration: 0.3) {
                var center = self.colorView.center
                let centerBtn = btn.center
                center.x = centerBtn.x
                self.colorView.center = center
                self.scrollView.contentOffset = CGPoint(x: Int(SCREEN_WIDTH)*btn.tag, y: 0)
       }
        
    }
   
       
    
}
