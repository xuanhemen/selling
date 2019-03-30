//
//  ProjectEmptyAnalysisVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectEmptyAnalysisVC: BaseVC {
    var model:ProjectSituationModel?
     let btn = UIButton.init(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
       self.title = model?.name
        self.view.addSubview(nameLable)
        nameLable.textAlignment = .center
        nameLable.text = "还没有做过项目体检，因此没有分析报告"
        nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(20)
            
        }
        
       
        self.view.addSubview(btn)
        btn.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.nameLable.snp.bottom)!).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(49)
        }
        btn.backgroundColor = UIColor.red
        btn.setTitle("花5分钟时间，给项目做一次体检？", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
//        let tab:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
        
        
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect(x: -5, y: 0, width: 40, height: 40)
        leftBtn.setImage(#imageLiteral(resourceName: "icon-arrow-left"), for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(leftItemClick(button:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
        
    }

    
    @objc func leftItemClick(button: UIButton) {
        
        self.tabBarController?.navigationController?.popViewController(animated: true)
        
    }
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func btnClick(){
//        let tab:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
        
        let analysisVC = ProjectAnalysisVC()
        analysisVC.model = self.model
        analysisVC.isAuth = (self.model?.save_auth == "1")
   self.tabBarController?.navigationController?.pushViewController(analysisVC, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
}
