//
//  ChooseProductVC.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit


class ChooseProductVC: BaseVC,RightCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    /**
     *  点击确定按钮后的回调  数组中放有选择的产品model
     */
    var resultArray:(_ resultArray:Array<Product_lineModel>)->() = {a in
        
    }
    var alreadyArray = Array<Dictionary<String,String>>()
    
    var alldata = Array<Product_lineModel>()
    var left = UITableView()
    var right = UITableView()
    
    var leftArray = Array<Product_lineModel>()
    var rightDic = Dictionary<String,Array<Product_lineModel>>()
    var selectArray = Array<Product_lineModel>()
    
    var leftIndex = IndexPath.init(row: 0, section: 0)
    var level = 0
    
//    @property (nonatomic,copy) void(^resultArray)(NSArray *resultArray);
//
//
//    @property(nonatomic,strong)NSMutableArray *alreadyArray;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        congigUI()
        configData()
        
        
        
        
    }
    
    func congigUI() {
        self.title = "选择产品";
        left = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2.0, height: MAIN_SCREEN_HEIGHT))
        right = UITableView.init(frame: CGRect(x: SCREEN_WIDTH/2.0, y: 0, width: SCREEN_WIDTH/2, height: MAIN_SCREEN_HEIGHT))
        left.tableFooterView = UIView()
        right.tableFooterView = UIView()
        
        view.addSubview(left)
        view.addSubview(right)
        self.left.delegate = self;
        self.left.dataSource = self;
        self.right.delegate = self;
        self.right.dataSource = self;
        
        self.right.backgroundColor = UIColor.groupTableViewBackground
        
        self.setRightBtnWithArray(items: ["确定"])
        
//        [self setRightBtnWithTitle:@"确定"];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configData() {
        var leftArray = Array<Product_lineModel>()
        var rightDic = Dictionary<String,Array<Product_lineModel>>()
//        var selectArray = Array<Product_lineModel>()

        let products = alldata
        if products.count == 0{
            DLog("当前没有可选择的产品")
            return
        }
        level = 0
        configALLData(parentArray: products)
        
        
        if alreadyArray.count > 0 {
            selectArray.removeAll()
            for dic in alreadyArray{
                
                let subModel = Product_lineModel.init()
                subModel.id = dic["id"]
                subModel.amount = dic["price"]
                subModel.name = dic["products"]
                let nameModel = findProduct_lineModel(pId: subModel.id!, lines: alldata)
                subModel.name = nameModel?.name
                subModel.parentid = nameModel?.parentid
                
                selectArray.append(subModel)
            }
        }
        
       
        
        left.reloadData()
        right.reloadData()
    }
    
    func findProduct_lineModel(pId:String,lines:Array<Product_lineModel>) -> Product_lineModel? {
        var pLineModel:Product_lineModel? = nil
        for lineModel in lines {
            if lineModel.id == pId{
                pLineModel = lineModel
            }
            if pLineModel == nil && lineModel.child != nil && lineModel.child?.count != 0{
                pLineModel = findProduct_lineModel(pId: pId, lines: lineModel.child!)
            }
        }
        return pLineModel
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configALLData(parentArray:Array<Product_lineModel>) {
        for pModel in parentArray {
            var rightArray = Array<Product_lineModel>()
            if pModel.parentid == "0"{
                level = 0
            }
//            RLMRealm.default().beginWriteTransaction()
//            pModel.level = level
//            RLMRealm.default().cancelWriteTransaction()
            
            let subProducts = pModel.child
            if subProducts != nil && subProducts?.count != 0{
                level = level + 1
                self.leftArray.append(pModel)
                var allRight = Array<Product_lineModel>()
                if pModel.child != nil {
                    for j in 0..<(pModel.child?.count)! {
                        let chileP = pModel.child![j]
                         chileP.parentid = pModel.id
                        if pModel.child != nil && pModel.child?.count != 0{
                            continue
                        }
                        allRight.append(chileP)
                    }
                }
                rightDic[pModel.id!] = allRight
                configALLData(parentArray: subProducts!)
            }else{
                if level == 0{
                    leftArray.append(pModel)
                    var allRight = [pModel]
                    if pModel.child != nil{
                        for i in 0..<(pModel.child?.count)!{
                            let chileP = pModel.child![i]
                            chileP.parentid = pModel.id
                            if pModel.child != nil && chileP.child?.count != 0{
                                continue
                            }
                            allRight.append(chileP)
                        }
                    }
                    rightDic[pModel.id!] = allRight
                }
                if rightDic[pModel.parentid!] == nil{
                    rightArray.append(pModel)
                    rightDic[pModel.parentid!] = rightArray
                }else{
                    rightDic[pModel.parentid!]?.append(pModel)
                }
            }
        }
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == left {
            return 44
        }else{
            return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == left {
            return leftArray.count
        }else{
            if leftArray.count == 0{
                return 0
            }
            let model = leftArray[leftIndex.row]
            let array = rightDic[model.id!]
            if array != nil {
                return (array?.count)!
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==left{
            let cellName = "cell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellName)
            if (cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellName)
                cell?.textLabel?.font = kFont_Big
                cell?.textLabel?.textColor = .darkText
            }
            
            let model = leftArray[indexPath.row]
            let array = rightDic[model.id!]
            
            
            if indexPath == leftIndex{
                cell?.textLabel?.textColor = kGreenColor
                cell?.backgroundColor = UIColor.groupTableViewBackground
            }else{
                cell?.textLabel?.textColor = .darkText
                cell?.backgroundColor = UIColor.white
            }
            
           
            for selectModel in selectArray{
                if selectModel.parentid == model.id {
                    cell?.textLabel?.textColor = kGreenColor
                }
            }
            
            
//            let model = leftArray[indexPath.row]
            var str = ""
            for i in 0..<model.level {
                str.append("     ")
            }
            cell?.textLabel?.text = str+model.name!
            return cell!
        }
        else
        {
            let cellIde = "cellRight"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIde) as? QFProductRightCell
            if cell == nil{
                cell = Bundle.main.loadNibNamed("QFProductRightCell", owner: self, options: nil)?.last as? QFProductRightCell
            }
            cell?.contentView.backgroundColor = UIColor.groupTableViewBackground
            cell?.indexPath = indexPath
            cell?.delegate = self
            cell?.textField.delegate = self
            let model = leftArray[leftIndex.row]
            let array = rightDic[model.id!]
            let rModel = array![indexPath.row]
            cell?.nameLable.text = rModel.name
            cell?.textField.text = rModel.amount != "0" ? rModel.amount : "0.0"
            cell?.textField.tag = Int(rModel.id!)!
            cell?.markBtn.isSelected = false
            cell?.textField.isEnabled = false
            cell?.textField.backgroundColor = .groupTableViewBackground
            DLog(rModel.id)
            for selectmodel in selectArray{
               
                if rModel.id == selectmodel.id{
                    cell?.markBtn.isSelected = true
                    cell?.textField.text = NSString.init(format: "%@", selectmodel.amount!).floatValue>0 ? selectmodel.amount : "0.0"
                    cell?.textField.isEnabled = true
                    cell?.textField.backgroundColor = .white
                }else{
//                    cell?.textField.isEnabled = false
//                    cell?.textField.backgroundColor = .groupTableViewBackground
                }
                        }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLog(rightDic)
        if tableView==left{
            self.leftIndex = indexPath
            self.left.reloadData()
            self.right.reloadData()
        }else{
//            cell.markBtn.selected = !cell.markBtn.selected;
            self.rightCellMarkBtnClickWith(indexpath: indexPath)
        }
    }
    
    func rightCellMarkBtnClickWith(indexpath: IndexPath) {
        var cell = right.cellForRow(at: indexpath) as? QFProductRightCell
        cell?.markBtn.isSelected = !(cell?.markBtn.isSelected)!
        cell?.textField.isEnabled = (cell?.markBtn.isSelected)!
        if (cell?.markBtn.isSelected)!{
            cell?.textField.backgroundColor = .white
            let model = leftArray[leftIndex.row]
            let array = rightDic[model.id!]
            let rModel = array![indexpath.row]
            let selectModel = Product_lineModel.init()
            selectModel.id = rModel.id;
            selectModel.amount = rModel.amount;
            selectModel.name = rModel.name;
            selectModel.parentid = rModel.parentid;
            DLog("父类id" + selectModel.parentid!)
            selectArray.append(selectModel)
            
            cell?.textField.becomeFirstResponder()
        }else{
            cell?.textField.backgroundColor = .groupTableViewBackground
            let model = self.leftArray[leftIndex.row]
            let array = self.rightDic[model.id!]
            let rModel = array![indexpath.row]
            for selectmodel in selectArray{
                if selectmodel.id==rModel.id
                {
                    self.selectArray.remove(at: self.selectArray.index(of: selectmodel)!)
                    break;
                }
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isFloatNumber())! || textField.text == nil{
            for selectmodel in selectArray{
                if selectmodel.id == String(textField.tag){
                    selectmodel.amount = textField.text != nil ? textField.text : "0.0"
                    break;
                }
            }
        }else{
            textField.text = "0.0";

        }
    }
    override func rightBtnClick(button: UIButton) {
        view.endEditing(true)
            self.resultArray(self.selectArray)
        navigationController?.popViewController(animated: true)
    }
}
