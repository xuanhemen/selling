//
//  SLCluesRepeatVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/24.
//  Copyright © 2019 柴进. All rights reserved.
//

import UIKit

class SLCluesRepeatVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
   
    
 
    /**数据源*/
    var dataArr = [SLConverRepeatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "重复信息"
        
        /***/
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(SLCluesRepeatCell.self, forCellReuseIdentifier: "repeat")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        let remind = UILabel()
        remind.text = "系统中存在相似的客户信息，不可转化"
        remind.textColor = .white
        remind.font = UIFont.systemFont(ofSize: 14)
        remind.textAlignment = NSTextAlignment.center
        remind.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        remind.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30)
        tableView.tableHeaderView = remind
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeat") as! SLCluesRepeatCell
        cell.setCell(model: model)
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
