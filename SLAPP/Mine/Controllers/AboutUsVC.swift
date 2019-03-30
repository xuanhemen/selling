//
//  AboutUsVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AboutUsVC: UITableViewController {
    
    let titleArray = ["去评分","功能介绍","意见反馈","服务协议","服务热线"]
//    let titleArray = ["去评分","服务协议"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于"
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
//       self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.addTopView()
        self.tableView.tableFooterView = UIView()
        self.tableView.isScrollEnabled = false
    }

    func addTopView(){
        
        let backView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 200))
        backView.backgroundColor = UIColor.white
        let line = UIView()
        backView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let imageView = UIImageView()
        backView.addSubview(imageView)
        imageView.image = UIImage.init(named: "myIcon")
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        let version = UILabel()
        version.textAlignment = .center
        backView.addSubview(version)
        version.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        let info = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = info?["CFBundleShortVersionString"] as AnyObject
        version.text = "版本号:".appending("\(majorVersion ?? 1.0 as AnyObject)")
        self.tableView.tableHeaderView = backView
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "reuseIdentifier")
        }
        
        cell?.textLabel?.text = titleArray[indexPath.row]
        if cell?.textLabel?.text == "服务热线" {
            cell?.detailTextLabel?.text = "4000-010-815"
        
        }else{
            cell?.detailTextLabel?.text = nil;
        }
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            UIApplication.shared.openURL(URL.init(string: String.init(format: "itms-apps://itunes.apple.com/app/id%@","1346473902"))!)
            break
        case 1:
            
//            let vc = UIViewController()
//            let web = UIWebView()
//            web.loadRequest(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "protocol", ofType: "html")!)))
//            vc.view = web
//            vc.title = "服务协议"
            self.navigationController?.pushViewController(IntroductionVC(), animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(FeedBackVC(), animated: true)
            break
        case 3:
            let vc = UIViewController()
            let web = UIWebView()
            web.loadRequest(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "protocol", ofType: "html")!)))
            vc.view = web
            vc.title = "服务协议"
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
          case 4:
            self.toCall()
//            self.showAlert(titleStr: "您确定拨服务热线吗？") {[weak self] in
//                
//            }
            
            
            break
        default: break
            
        }
        
        
    }
    
    
    func toCall(){
        let web = UIWebView()
        self.view.addSubview(web)
        web.loadRequest(URLRequest.init(url: URL.init(string: String.init(format: "tel:%@","4000-010-815"))!))
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
