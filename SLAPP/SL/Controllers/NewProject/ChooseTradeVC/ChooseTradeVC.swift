//
//  ChooseTradeVC.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ChooseTradeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @objc var result:(_ model:TradeModel)->() = {a in}
    
    var qfTradeId = ""
    var qfTradeParentId = ""
    
    var tradeId:String?
//    var allTrade = Array<TradeModel>(){
//        didSet{
//            parents = allTrade.flatMap{ (trade) ->TradeModel? in
//                if trade.parent_id == "0" {
//                    return nil
//                }
//                return trade
//            }
//        }
//    }
    var parents = Array<TradeModel>()
    var childs:Array<TradeModel>? = nil
    var leftIndexPath:IndexPath? = nil{
        didSet{
            tradeList(parent_id: self.parents[self.leftIndexPath!.row].index_id) { (tradeArr) in
                self.childs = tradeArr
                self.rightTable.reloadData()
            }
        }
    }
    
    
    let leftTable = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT))
    let rightTable = UITableView(frame: CGRect(x: SCREEN_WIDTH/2, y: 0, width: SCREEN_WIDTH/2, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
        configData()
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

    func configUI() {
        title = "选择行业"
        view.addSubview(leftTable)
        view.addSubview(rightTable)
        self.leftTable.delegate = self
        self.leftTable.dataSource = self
        self.rightTable.delegate = self
        self.rightTable.dataSource = self
        self.rightTable.backgroundColor = .groupTableViewBackground
    }
    func configData(){
       
        tradeList(parent_id: "0") { (tradeArr) in
            self.parents = tradeArr.sorted(by: { Int($0.index_id)! < Int($1.index_id)!})
            self.leftTable.reloadData()
            
            if self.tradeId == nil{
                self.leftIndexPath = IndexPath.init(row: 0, section: 0)
            }
            
        }
        
//        rightTable.reloadData()
    }
    
    // MARK: - tableDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTable{
            return parents.count
        }else{
            return childs != nil ? childs!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTable{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellLeft") as? RightCell
            if cell == nil{cell = Bundle.main.loadNibNamed("RightCell", owner: self, options: nil)?.last as? RightCell}
            //if leftIndexPath == indexPath{cell?.isNewSelected = true}
            cell?.mask?.isHidden = true
            let model = parents[indexPath.row]
            cell?.lable.text = model.name
            
            if qfTradeParentId != "" {
                if model.index_id == qfTradeParentId {
                    cell?.isNewSelected = true
                    leftIndexPath = indexPath
                    rightTable.reloadData()
                }
            }
//            if tradeId != nil && leftIndexPath != nil {
//                let pModel = childs?.first { (trad) -> Bool in
//                    return trad.index_id == self.tradeId
//                }
//                if pModel?.parent_id == model.index_id{
//                    cell?.isNewSelected = true
//                    leftIndexPath = indexPath
//                    rightTable.reloadData()
//                }
//            }
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RightCell
            if cell == nil{cell = Bundle.main.loadNibNamed("RightCell", owner: self, options: nil)?.last as? RightCell}
            cell?.backgroundColor = .clear
            cell?.mask?.isHidden = true
            if leftIndexPath != nil{
                let subModel = childs![indexPath.row]
                cell?.lable.text = subModel.name
                if tradeId != nil && subModel.index_id == self.tradeId {
                    cell?.isNewSelected = true
                }
                if qfTradeId != "" {
                    if subModel.index_id == qfTradeId {
                        cell?.isNewSelected = true
                    }
                }
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTable{
            let model = parents[indexPath.row]
            leftIndexPath = indexPath
            self.qfTradeParentId = model.index_id
            leftTable.reloadData()
        }else{
            let model = childs![indexPath.row]
            result(model)
            navigationController?.popViewController(animated: true)
        }
    }
    
    //获取行业
    func tradeList(parent_id:String , end:@escaping (Array<TradeModel>)->()){
        
        //parent_id 0 是一级   查对应一一级的子集  传对应一级的id
        let params:Dictionary = ["parent_id":parent_id,"token":UserModel.getUserModel().token]
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: TRADE_LIST, params: params, hadToast: true, fail: { (dic) in
            
        }) { (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            if dic["data"] is Array<Dictionary<String,String>>{
                var btnDic = Dictionary<String,String>()
                end((dic["data"] as! Array<Dictionary<String,String>>).map({ (oneDic) -> TradeModel in
                    return TradeModel.deserialize(from: oneDic)!
                }))
            }
        }
        
    }

}
