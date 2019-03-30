//
//  SLIndustryVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

/**回调协议*/
protocol PassIndustry {
    func passValue(name: String,id:String)
}
class SLIndustryVC: BaseVC {

    /**数据源*/
     var dataArr = [SLIndustryModel]()
    /**视图*/
     let industryView = SLIndustryView()
    /**代理传值*/
    var delegate:PassIndustry?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "请选择行业"
        
        /**添加行业视图，并且等待该视图回调所选行业model，返回上一级控制器*/
        industryView.passModel = {(oneModel,twoModel) in
            self.delegate?.passValue(name: oneModel.name!+"-"+twoModel.name!, id: twoModel.index_id!)
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(industryView)
        industryView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, SAFE_HEIGHT, 0))
        }
        self.requestData()
        // Do any additional setup after loading the view.
    }
    //MARK: - 请求行业
    func requestData() {
        let parameters = [String:String]()
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: "pp.user.industry_all", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            print("结果\(dataDic)")
            self.showDismiss()
            if let json = JSON(dataDic).dictionary,let array = json["data"]?.arrayObject {
                let models = [SLIndustryModel].deserialize(from: array) as! [SLIndustryModel]
                for model in models{
                    if model.parent_id=="0"{
                        self.dataArr.append(model)
                        for subModel in models{
                            if subModel.parent_id == model.index_id{
                                model.subArray.append(subModel)
                            }
                        }
                    }
                }
            }
            self.industryView.dataArr = self.dataArr
            self.industryView.levelOneTableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
