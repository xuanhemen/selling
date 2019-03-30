//
//  ProRiskingListVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProRiskingListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    var myModel:ProjectAnalyzeModel?{
        didSet{
            table.reloadData()
        }
    }
    
    var model:ProjectSituationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "风险预警"
        self.congigUI()
    }

    func congigUI(){
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.backgroundColor = UIColor.groupTableViewBackground
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
    }
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myModel != nil {
             return  (self.myModel?.risk_warning?.risk_warning.count)!
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cellID = "CELL0"
    var cell:ProjectAnalyzeCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ProjectAnalyzeCell
    if cell == nil {
        cell = ProjectAnalyzeCell(style: .default, reuseIdentifier: cellID)
        cell?.uiConfig(ID:cellID)
    }
        cell?.label.text = self.myModel?.risk_warning?.risk_warning[indexPath.row].title
        
//        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:cell!.label.text!)
//            attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 2))
//        cell?.label.attributedText = attrstring
//            
//        let subStr = cell?.label.text?.prefix(1)
//        cell?.subLabel.text = String(subStr!)
            
       
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ProjectAnalyzeBaseDetailVC()
        detailVC.myModel = self.model
        detailVC.riskModel = self.myModel?.risk_warning?.risk_warning[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
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
