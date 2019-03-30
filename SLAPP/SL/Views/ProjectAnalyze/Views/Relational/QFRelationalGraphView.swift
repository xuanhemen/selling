//
//  QFRelationalGraphView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/13.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit


protocol QFRelationalDelegate:NSObjectProtocol {
    func qf_delegateClickRole(pid:String);
}

class QFRelationalGraphView: UIView,PSTreeGraphDelegate{
    
    var clickPeople:(_ pid:String)->() = { _ in
        
    }
    var delegate:QFRelationalDelegate?
    
    let valueArray = [
        ["title":"司令1","node":[
            ["title":"军长1","node":[
                ["title":"师长1","node":[]],
                ["title":"师长2","node":[
                    ["title":"旅长1","node":[]]
                    ]]
                ]
            ],
            ["title":"军长2","node":[
                ["title":"师长3","node":[]],
                ["title":"师长4","node":[]]
                ]
            ]]
        ],
        ["title":"组织结构图","node":[
            ["title":"军长3","node":[
                ["title":"师长5","node":[]],
                ["title":"师长6","node":[
                    ["title":"旅长1","node":[]],
                    ["title":"旅长2","node":[]],
                    ["title":"旅长3","node":[]]
                    ]]
                ]
            ]]
        ]
    ]
    
    
    func uiConfig(dict:Dictionary<String,Any>) {
        self.backgroundColor = UIColor.init(red: 0.55, green: 0.76, blue: 0.93, alpha: 1.0)
        //QF -- MARK:组织结构图背景颜色
        self.backgroundColor = .white
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        self.addSubview(scrollView)
        
        
        let treeGraphView = PSBaseTreeGraphView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        //QF -- MARK:组织结构图背景颜色
        treeGraphView?.backgroundColor = .white
        treeGraphView?.nodeViewNibName = "ObjCClassTreeNodeView"
        treeGraphView?.treeGraphOrientation  = PSTreeGraphOrientationStyle.horizontal
        treeGraphView?.delegate = self
        
        //let dict = ["title":"开始分支","node":valueArray] as [String : Any]
        treeGraphView?.modelRoot =  QFNode.init(dict: dict)
        
        scrollView.addSubview(treeGraphView!)
        scrollView.contentSize = (treeGraphView?.minimumFrameSize)!
        

        
    }
    
    
    //QF -- MARK:组织结构图点击事件
    func select(_ node: PSTreeGraphModelNode!) {
        let node:QFNode = node as! QFNode
        self.delegate?.qf_delegateClickRole(pid: node.nodeId()!)
        //self.clickPeople(node.nodeId()!);
        
        print("QF -- log:node=",node.name!,node.nodeName()!,node.nodeId()!)
    }
    func configureNodeView(_ nodeView: UIView!, with modelNode: PSTreeGraphModelNode!) {
        let node:QFNode = modelNode as! QFNode
        let leafView:MyLeafView = nodeView as! MyLeafView
        
        if node.nodeId() != "-1" {
            leafView.fillColor = HexColor(node.nodeBackgroundColor()!)
            //print("QF -- log:node=",node.nodeBackgroundColor()!)
        }
        
        
        let arr:Array? = node.childModelNodes()
        if arr != nil{
            if arr?.count == 0 {
                leafView.expandButton.isHidden = true
            }
        }
        let frame = leafView.frame
    
        leafView.titleLabel.text  = node.name! as String
        if node.name == "组织结构图" {
            leafView.isHidden = true
        }
        if node.name == "开始分支" {
            
            leafView.isHidden = true
            leafView.frame = CGRect(x: 0, y: frame.origin.y, width: 30, height: frame.size.height)
        }
        
        //leafView.detailLabel.text = String.init(format: "%zd bytes", objectWrapper.wrappedClassInstanceSize)

    }

}
