//
//  IntroductionVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class IntroductionVC: UITableViewController {

    var dataArray = Array<Dictionary<String,Any>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "功能介绍"
        self.configData()
        self.tableView.tableFooterView = UIView()
    }

    
    func configData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: INTRODUCTION, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
             PublicMethod.dismiss()
            self?.dataArray.removeAll()
            if let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>> {
                self?.dataArray = array
            }
            
            self?.tableView.reloadData()
        }
        
    }
    
    
    // MARK: - table delegate Datasource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIde)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = String.noNilStr(str:self.dataArray[indexPath.row]["title"])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dic = self.dataArray[indexPath.row]
        let vc = UIViewController()
        let web = UIWebView()
        vc.view = web
        vc.title = String.noNilStr(str: dic["title"])
        web.loadRequest(URLRequest.init(url: URL.init(string: String.noNilStr(str: dic["url"]))!))
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
