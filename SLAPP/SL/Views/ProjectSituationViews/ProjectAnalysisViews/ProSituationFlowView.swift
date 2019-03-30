//
//  ProSituationFlowView.swift
//  SLAPP
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProSituationFlowView: UIView,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource{
    
    
    let btn:UIButton = UIButton.init(type: .custom)
    var currentPage:UIPageControl?
    var pageView:NewPagedFlowView?
    
    var cellHeight: CGFloat?
    let cellTop:CGFloat =  30
    var click:()->() = {
        
    }
    
    var dataArray:Array<ProAnalysisModel>?{
        
        didSet{
            pageView?.reloadData()
//            page.numberOfPages = (dataArray?.count)!+1
//            collectionView?.reloadData()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        cellHeight = frame.size.height - 100
        self.configUI()
    }
    
    func configUI(){
        pageView = NewPagedFlowView.init(frame: CGRect(x: 0, y: cellTop, width: self.frame.size.width, height: cellHeight!))
        let page = UIPageControl.init(frame: CGRect(x: 0, y: frame.size.height-50, width: MAIN_SCREEN_WIDTH, height: 30))
        
        
        
        page.currentPageIndicatorTintColor = kGreenColor
        pageView?.pageControl = page
        self.addSubview(page)
        self.currentPage = page
        
        pageView?.delegate = self
        pageView?.dataSource = self
        pageView?.minimumPageAlpha = 0
        pageView?.isCarousel = false
        pageView?.orientation = NewPagedFlowViewOrientationHorizontal
        pageView?.isOpenAutoScroll = true
        pageView?.scrollView.backgroundColor = UIColor.groupTableViewBackground
        let backView = UIScrollView.init(frame: self.bounds)
        backView.addSubview(pageView!)
        self.addSubview(backView)
        pageView?.reloadData()
        
        
        btn.frame = CGRect(x: 25, y: frame.size.height-60, width: MAIN_SCREEN_WIDTH-50, height: 40)
        btn.setTitle("确认提交", for: .normal)
        btn.backgroundColor = kGreenColor
        btn.isHidden = true
        self.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    func sizeForPage(in flowView: NewPagedFlowView!) -> CGSize {
        return CGSize.init(width: MAIN_SCREEN_WIDTH-50, height: cellHeight!)
    }
    
    
    func numberOfPages(in flowView: NewPagedFlowView!) -> Int {
        if self.dataArray != nil {
            return (self.dataArray?.count)!
        }
        return 0
    }
    
    func flowView(_ flowView: NewPagedFlowView!, cellForPageAt index: Int) -> UIView! {
        var banner:PGIndexBannerSubiew? = flowView.dequeueReusableCell() as? PGIndexBannerSubiew
        if banner == nil {
            banner = PGIndexBannerSubiew.init(frame: CGRect(x: 0, y: cellTop, width: frame.size.width-50, height: cellHeight!))
        }
        
        if index  == self.dataArray?.count {
            let cell:SituationSureCell = SituationSureCell.init(frame: CGRect(x: 10, y: 0, width: frame.size.width-70, height: cellHeight!))
            cell.click = { [weak self] in
                self?.click()
            }
            banner?.addSubview(cell)
            return banner
            
        }else
        {
        let cell:SituationAndFlowCell = SituationAndFlowCell.init(frame: CGRect(x: 10, y: 0, width: frame.size.width-70, height: cellHeight!))
        cell.model = self.dataArray?[index]
        cell.myclick = { [weak self] in
             self?.toScroll(index: index)
        }
        banner?.addSubview(cell)
        return banner
        }
    }
    
    
    func toScroll(index:Int){
        
        let page = index + 1
        if page < (self.dataArray?.count)! {
            pageView?.scrollView.setContentOffset(CGPoint.init(x: (frame.size.width-50)*CGFloat(page), y: 0), animated: true)
        }
        
        if index == (self.dataArray?.count)! - 1 {
            if self.dataArray![index].select != nil {
                btn.isHidden = false
                currentPage?.isHidden = true
            }
        }
        
    }
    
    func didScroll(toPage pageNumber: Int, in flowView: NewPagedFlowView!) {
        
        if pageNumber == (self.dataArray?.count)!-1 {
            if self.dataArray![pageNumber].select != nil {
                btn.isHidden = false
                currentPage?.isHidden = true
            }
        }else{
            btn.isHidden = true
            currentPage?.isHidden = false
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(){
        self.click()
    }
    
}
