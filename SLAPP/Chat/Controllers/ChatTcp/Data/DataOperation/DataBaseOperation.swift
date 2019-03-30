//
//  DataBaseOperation.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class DataBaseOperation: NSObject
{
    
    
    
    /// 数据库的初始化
    public static func initDataBase()
    {
        
        let  config:RLMRealmConfiguration  = RLMRealmConfiguration.default()
        /// todo  暂时写死  最后需要换成用户相关的唯一标识字段
        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
        config.fileURL =  config.fileURL?.deletingLastPathComponent().appendingPathComponent(username).appendingPathExtension("realm")
        DLog("数据库地址：\(config.fileURL!)")
        //数据库迁移
        self.performingMigrationWithConfig(config: config)
        RLMRealmConfiguration.setDefault(config)
        
    }
    
    
    
    /// 清空本地数据库数据
    public static func removeAllData()
    {
        let realm:RLMRealm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.deleteAllObjects()
        try? realm.commitWriteTransaction()
        
    }
    
    
    
    /// 修改或添加一条数据
    ///
    /// - Parameter rlmObject: 需要修改或添加的数据
    public static func addData(rlmObject:RLMObject)
    {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.addOrUpdate(rlmObject)
        try? realm.commitWriteTransaction()
        
    }
    public static func addOnlyData(rlmObject:RLMObject)
    {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.add(rlmObject)
        try? realm.commitWriteTransaction()
        
    }

    
    /// 批量添加或修改数据
    ///
    /// - Parameters:
    ///   - rlmObjects: 需要添加或者修改的数据
    ///   - aClass: 数据库模型类型
    public static func addDataWithArray(rlmObjects:Array<Any>,aClass:AnyClass)
    {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        for any in rlmObjects {
            if any is Dictionary<String, Any>
            {

                if (aClass == UserModelTcp.self){
                    var myDic:Dictionary<String, Any> = any as! Dictionary<String, Any>
                    for (key,value) in (any as! Dictionary<String, Any>){
                        if value is String == false{
                            
                            myDic.updateValue(String.noNilStr(str: value), forKey: key)
                        }
                    }
                    aClass.createOrUpdateInDefaultRealm(withValue: myDic)
                }
                else{
                    aClass.createOrUpdateInDefaultRealm(withValue: any)
                    
                }
            }
        }
        try? realm.commitWriteTransaction()
    }
    
    
    
    /// 删除一条数据
    ///
    /// - Parameter rlmObject: 需要删除的数据
    public static func removeData(rlmObject:RLMObject?)
    {
        
        guard rlmObject != nil else {
            return
        }
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.delete(rlmObject!)
        try? realm.commitWriteTransaction()
        
    }
    
    
    /// 批量删除数据
    ///
    /// - Parameter rlmObjects: 需要删除的数据
    public static func removeDataWithArray(rlmObjects:Any?)
    {
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        realm.deleteObjects(rlmObjects! as! NSFastEnumeration)
        try? realm.commitWriteTransaction()
    }
    
    
    
    //    public static func removeDataWithIdentifications(_ idents:Array<Any>,aClass: Swift.AnyClass)
    //    {
    //        let realm = RLMRealm.default()
    //        realm.beginWriteTransaction()
    //        for any in idents
    //        {
    //            if any is String {
    //                model:RLMObject = aClass.objectForPrimaryKey(any)
    //            }
    //        }
    //        try? realm.commitWriteTransaction()
    //
    //
    //    }
    
    
    
    /// 数据库迁移
    ///
    /// - Parameter config: config description
    private static func performingMigrationWithConfig(config:RLMRealmConfiguration)
    {
        config.schemaVersion = 2
        config.migrationBlock = { (migration:RLMMigration,oldSchemaVersion:UInt64)->Void in
            if oldSchemaVersion < 1 {
                
            }
            
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(GroupModel.className(), block: { (oldObject, newObject) in
                    newObject?["project_id"] = ""
                    
                })
            }
           
        }
    }
    
}
