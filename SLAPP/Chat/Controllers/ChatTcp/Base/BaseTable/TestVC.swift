//
//  TestVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/10.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class TestVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.configUIWith(fromCellName: "BaseTableCell", fromIsShowSearch: true,fromSearchType: true ,fromCellHeight: 50)
        
//        for i in 0...20
//        {
//            let model:BaseTableModel = BaseTableModel()
//            model.text = String(i)
//            model.id = String(i)
//            self.allDataArray?.append(model)
//        }
//        
//        self.setDataArray(dataArray: self.allDataArray!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
