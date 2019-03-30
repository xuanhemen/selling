//
//  MineVC.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SDWebImage

class MineVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIde")
        if (!(cell != nil))
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellIde")
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.imageView?.image = UIImage.init(named: self.imageArray[indexPath.row])
        cell?.textLabel?.text = self.titleArray[indexPath.row];
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let companyC = CompanyControlTableViewController.init(style: .grouped)
            self.navigationController?.pushViewController(companyC, animated: true)
        }
    }
    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var company: UILabel!
    
    
    var imageArray = Array<String>()
    var titleArray = Array<String>()
    var currentCorpid = ""
    
    let userModel = UserModel.getUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        self.configUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func personalInfoBtnClick(_ sender: Any) {
    }
    
    func configUI() {
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.topBackView.backgroundColor = kGrayColor_Slapp
        self.title = "我的"
        self.table.backgroundColor = UIColor.groupTableViewBackground
        self.userImage.layer.cornerRadius = 30
        self.userImage.clipsToBounds = true
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cellIde")
        self.table.isScrollEnabled = true
        self.table.delegate = self
        self.table.dataSource = self
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 60))
        view.backgroundColor = UIColor.groupTableViewBackground
        let exitBtn = UIButton.init(type: .custom)
        exitBtn.frame = CGRect(x:(MAIN_SCREEN_WIDTH-268)/2.0, y:8, width:268, height:44)
        exitBtn.setBackgroundImage(UIImage.init(named: "mine_exit"), for: .normal)
        exitBtn.setTitle("退出登录", for: .normal)
        exitBtn.addTarget(self, action: Selector("exitBtnClick:"), for: .touchUpInside)
        view.addSubview(exitBtn)
        self.table.tableFooterView = view;
        let model = UserModel.getUserModel()
        DLog(model)
        LoginRequest.getPost(methodName: LOGINER_MESSAGE, params: ["token":model.token], hadToast: false, fail: { (dic) in
            DLog(dic)
        }) { (dic) in
           
            self.userImage.sd_setImage(with: URL.init(string: dic["head"] as! String + imageSuffix), placeholderImage: UIImage.init(named: "mine_avatar"))
            self.userName.text = dic["username"] as! String
            self.userEmail.text = dic["email"] as! String
        }
//
//        self.userName.text = [model.realname isNotEmpty]?model.realname:@"无用户名";
//        self.userEmail.text = [model.email isNotEmpty]?model.email:@"未填写邮箱";
        self.configData()
    }
    func configData() {
        self.imageArray = ["bind_acount","mine_feedBack","aboutUs"]
        self.titleArray = ["成长地图","企业管理","关于我们"]
        
//        self.tableHeight.constant = self.imageArray.count * 44;
        
        //    self.company.text = @"还没有添加选择公司";
//        NSArray *tempKeysArr = [[self.companies allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            return [obj1 compare:obj2];
//            }];
//        let tempKeysArr = []
        
        self.company.text = userModel.companies?["name"]
        self.currentCorpid = userModel.companies!["id"]!
        
    }
    
    func exitBtnClick(sender:UIButton)  {
        
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
