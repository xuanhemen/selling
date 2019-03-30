//
//  ProEditFlowVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProEditFlowVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
     var dataArray:Array<ProAnalysisModel>?
    var model:ProjectSituationModel?
    var click:()->() = {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
    }
    
    func configUI(){
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.groupTableViewBackground
        self.setRightBtnWithArray(items: ["保存"])
        
    }

    override func rightBtnClick(button: UIButton) {
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        var more = Dictionary<String,String>()
        for model in (self.dataArray)! {
            if model.select != nil{
                more[model.key] = model.select?.index
            }else{
                more[model.key] = ""
            }
        }
        params["more"] = BaseRequest.makeJsonStringWithObject(object: more)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_SAVE_SPBE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "提交成功")
            self?.click()
            self?.navigationController?.popViewController(animated: true)
            
        }
        
    }
    

    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray![indexPath.row].select
        if model?.name == nil {
            return 44
        }
        let height = UILabel.getHeightWith(str: (model?.name)!, font: 14,width: MAIN_SCREEN_WIDTH-140)
        return 44 > height ? 44 : height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.title == "项目形势" {
            return  (self.model?.situation_logic.count)!
        }
        return  (self.model?.procedure_logic.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "ProLoginSituationCell"
        var cell:ProLoginSituationCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProLoginSituationCell
        if cell == nil {
            cell = ProLoginSituationCell.init(style: .default, reuseIdentifier: cellIde)
        }
        if self.title == "项目形势" {
             cell?.model = self.model?.situation_logic[indexPath.row]
        }else{
            cell?.model = self.model?.procedure_logic[indexPath.row]
        }
        
       
        cell?.contentLable.text = self.dataArray![indexPath.row].select?.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let check = CheckView.configWithTitles(titles:self.dataArray![indexPath.row].contents())
        check.click = {[weak self] (str,index)  in
           
           self?.dataArray![indexPath.row].select = self?.dataArray![indexPath.row].list[index.row]
           self?.table.reloadRows(at: [indexPath], with: .none)
        }
        DLog(self.dataArray![indexPath.row].select?.name);
        check.selecArray = [String.noNilStr(str: self.dataArray![indexPath.row].select?.name)] as! [String]
        check.refresh()
        
        
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    
    
    

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
