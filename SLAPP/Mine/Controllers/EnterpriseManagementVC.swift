//
//  EnterpriseManagementVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class EnterpriseManagementVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

  lazy  var  titleArray:Array<String> = {
       let array = ["机构信息","部门及人员","产品信息","授权信息"]
        return array
    }()
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.table.backgroundColor = UIColor.red
        self.title = "企业管理"
        self.table.delegate = self
        self.table.dataSource = self
        self.table.isScrollEnabled = false
        self.table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIde)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = titleArray[indexPath.row]
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(AgencyInformationVC(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(DepartmentVC(), animated: true)
            break
        case 2:
           
       self.navigationController?.pushViewController(ProductInformationVC(), animated: true)
        break
        case 3:
            self.navigationController?.pushViewController(AuthorizationInformationVC(), animated: true)
            break
        default: break
            
        }; 
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
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
