//
//  PublicDataSingle.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/3/15.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import SVProgressHUD

let sharePublicDataSingle = PublicDataSingle()

struct PublicData {
    // structure definition goes here
    var avater = "" //头像地址
    var userid = "" //用户id
    var corpid = "" //公司id
    var realname = "" //真实姓名
    var access_token = "" //accToken
    var im_token = "" //imToken
    var im_userid = "" //im userid
    var pushToken = "" //推送token
}
class PluginData {
    var initToken = ""//init接口Token
    var openToken = ""//open接口Token
}

class PublicDataSingle: NSObject {

//    static let sharePublicDataSingle = PublicDataSingle()
    var publicData = PublicData()
    var pluginData = PluginData()
    
    var userId:NSString = ""//用户id
//    var token:NSString = "MDAwMDAwMDAwMJ6tsN_IYpqci3l8Yb20f5uZ3Hyhj3ivm6_LlpmG2oCkgqK837-Iq6uKiWedrculzpnQmqKNaLjRyZSFpZuTo6aSh5vPx2KRn311gJnHqXjLlZWIZn6f1c6ztXTbgcqumpOLl83Gh9ifgJt_mrCkgNiWlZahl56vm6_LfJiHpICkgqKw0b6H2auKiWedrculzoyrh2KPn6_cvqmIlJLLfZmRfLuWs3Snn3qbrZrGuG_OlbqqnX6f1c6ztXTbhsuIYYeIs5a0dKaffXWAqr64msuYqp6lj4ivm6_LdM2EpIGqk4vKy8aIop-Am3-asKSA2I27gGGNZ97bwJOf2ZCUiaGbi7vOtJmqrn92nWaytYeags13Yn6e3c7IqHnenKdwpJtmytXHnJqmlHV_Z63Le5eDp4Opgp-_lbTLfM2EpIFinHu4zcl3t5yVeaKlvrR_m33Nd2GEec3dtaWW3IXbopqFd7DNyZ2nZouKf5qzyn_dfcypmphouM3KqYnegcummoaHr9iunrewi4qAob6kf5t9zZVmg66v2K_Om9CRuIiaiJ2wyLFht62TeW-ZvqmEyICVY52XjLDRyc2q2pyohaiRZqyXvoizopSeraext63bgbmpp4Ofv5W-pGvNhKSBoZxln9y-iK-wepylmrG0f9h90J6mmaLSlcC3bM6ak4mdgp7W2smH2al9dYClvqWMy5W6Z2OWjbjRvpOB2pKojJqIoZuWx3fYqXqfhGLHlIjblrZ7Z36er9ivzp_ekJOJnZt3r5uumqKffXWAmb2UiNWY0Hhhj4ivm6_LeM2EpIGkm2bK1cecmqqTZIChxqiLzoPMe6mCeaeXtKWElYXbjGWGh6_Yrp3ZrItkoqa8k4zZjbqepH6f1c7LzpvVkJSJnZxnuKbIYs2rioVrm8aTZs6Apnyalo2wlceohcydtIBngqGblsd32KqToIykxqRn2n3MqZqPZ7zawKiJ3YHLppqCnd3Ov2O3pot5i5qzyn_dfcypmo5nn9nJqHnZmbiNq4Ke1seunNlnf3mLqr23rpaCqoiajovelrTbfJSHpIGVhXewzb5ir6KUZYSXyKhv1466ZpqEnrCzuKZ5l4y2iXOdZJeqtojFhISckGHHkabOhpWZZIhnwNO5z4XKj8yvgYaLl8-zm6etk6CimsalgNWY3YB_j4m41Lq1fa2dtYWhmmbK3bh2rrB_rHyhxZR3l4qqZquajMCXyc6ryp3OcIKNobOXupmSrH9lpp7Ika7Yg7d8koevuM25y32oms-Jio1n0tyyYNGtf3mupMW2pd-Hqqp7loyX2LS3l9CbqG9jjIuWmb1gzah-nniAxaaquYXPnpKYit7YtbaXlZq5iXWdi7_fvoezl5SdqanFtaKahZaikoKM0tm0qHnVmpOamoV3sM_HY6utkomHmrPLeJ6ApnyrmGefy8e4hM2HyoBkiIjJzrFzq2eUZIyqxbiHzoPMe2ODn7fOsqR9lZuTjaqboazZv4OqbHqgpqDFzW-VjruAYYZ9tNXIznjZkZNwpYKd3c6-Y7eviWRnnca4gNGXz2thmo2o0a_LotuEpIGkm2bK1cecmqCTZYCoxbiHzoPNc6R-orSWyc1szpqUgaiai7fOtJqiqXqfhKfHz3jVjqZ7Z36fp86ypH2UmbhonYKe1d2zdMhrf4aLqLLLoZaApnydmn2o1cnOiM2Hy3xihni73bJ0qmiAhoukrc-AzZbQhKeXiK-br86BxZy5kaCeiM6btmHFaYB5rn62lKHOgKZ8q5aMytqvy6LNhqV8qIiIr5m-nbqufnmDY7LOg92B0Iidgnyv3LSlfN6Fzomchoirlr6Htp-Xg3Nu"//用户token
//    var token:NSString = "MDAwMDAwMDAwMJ6tsN_IYpqci3l8Yb20f5uZ3Hyhj3ivm6_LiNuGpZ6ahXewlshit6-Tn3ylvrR_m33RgGKYfLzevpOX3JqlgKiKfLTVx52mq4pkb6Wtyq3Ojbt0qI1n2tHLtHyagct4moV3sNHHh6emk3V_Z63PhJaXqoiqjWfK3cilfNuJqYWhm6Gr2r5imqp6m62axqhv05W6ZpqEnq_cr8qqzZvOjZmbe5vNx4e2n4CbgJTItaGZgpWIlJmJvNG1pY3HnLWiY4h4wMjJhLuhf3mAlMi1ns6Op4hhjmioyMq1jN6RtY2UnYi737-Erq96m62axrhvzpW6qp1-n9XOs7WAloW1fKuGnr-Zspqyn311gKq-uJrLmKqepY-Ir5uvy3iUh6V4q4iIyd-zmrqffXWAqr64msuVu3OahJ6v3bTLmpSFtYBjhq6n366Z2J-TeXyryKdv2JaVlqGXoZ-Vx7hk0IHLppqGd6_Yrp3ZnpRliJfGqG_Tlbpnl5aNp861ynzbgcqump2MqNC-iLOiiWWIoca4i86DzHupg3nN3LPbnpeF25Bjgp3dzr6Iu56VeYyqrcum2pi6qqSBeLDfyqh5lJy5hJqIna_drpnYn5WKhJ3HzqLQfc2hmoOJp5W1pHzXgc6fnZKLt860nZZnk3mtpK3Oot-MlnSZmGizzrXKfNyByq6amoubl8aIs6KJZISnvqiLzoPMe5qBeLDZwKWJypm4bGOajLjRvWKvrIt5i5qzyoDQgqd4nIR8tNC1tZvRhaV5moaep5W_hMxqfnZ3ZrO1ntGNlYtlg3mvmMC0fNeBzoVinGe428eDqmx6m3-krc6i34yVhJ2XeK-br8t0zYSkgZmSZ7jVyZ2nZouFf2ety3vOgKZ8pJdnytXIzWzYmpOBoZt7u860maqufqyPqbG1g96CzZmqg3iv2K_Oq9qSk6OmkWa82b6Hzal6nKWax5SM3I67fJePaKzYs8t1pZuTo6aSh5vPx2KRn311gJrFuYCVlaqEmZqIr5vIz4nXmqSumpNmvNq_d7evepympsi4rtiApnyfmYzS0MC0fJqBy3yahXewz8dikq2KiWuhvrmDzoPPpZqNfbuVwLV9zJCpjGGTi7DNvXi2aX6ch2WtzWbYfdB4m45nvN_JkmyUmpOrnZudr5uum5J7goqaf7amfJiIuIRzmWWXsLTPhd6LzoF5mnjKsb-dxYGVeG-Lx8ya2JWniKSEjdaxyLh51Zq4jZ6GZ7TZx2KVan2HgGayznzNlapnnZmfsLG0zoWakcyFfJCfytG8nsmwf4adqLKlj5iOt4iph4yb3b6Thd2HqX2pnqDWmrOHyZd-n4Snu8-QtJmnhJ2CopqVt5N90ouUkXudis7Wup3YaoCKgKayuKKzgZWDY5qjqNq9qInYkc6fq5uK0r3GeLOFlZ2en7LPfNyOu3h1iIyfz7-1hdSHpZF2nqDO0MZ3yX-TnoClx82IzpbRdIWHo6i-s7l4zYSkgZubZ7Dcxoeyn4CceGqwpIDfl5Vrl5aMt861ynyVhaWIZYKd3c7JiK-ilJ-inK3Lpc6C3XNihIiv2K_Pid6SuYGmkouX0a6a0J-UZYyovrmAy46WeKSCn6imyZOf2ZG0bJubZpbOsXOroJWKgJfGuIzZjdCIqo1ouJrJqIjNh8t4pIKh3tu_Ys2riWSEp8fPeNWOpntngnjdzr-Uid2Qk4WnnKKo1b9zqmx-da2avZNv3peqnpx-n9XOs6R814HPiaGbi7vOtJqmZoB2oWay26GVgad3pH6ivJnJqJ_dkrSAZ4aIu9yzhLawfoaHqLG0rc6X0Himj3yf2a_Los2Jz6Odj57Srcl1xGaEeqKjyahru4LMe6R-o7TVwJNnzYfKgKqHrtLStISisIufe2OztYzOgqd4moKMt960pXjekZORm4eIq5m0h6qvf5uAag"//用户token
    var token:NSString = "MDAwMDAwMDAwMJ6tsN_IYpqci3l8Yb20f5uZ3Hyhj3ivm6_Llt2HpYSahXewlshit6-Tn3ylvrR_m33RmquXfajLs7WEmYbbiGaHnqeWs6rEroB2e6ityq3Ojbt0qI1n2tHLtHyagct4moV3sNHHh6emk3V_Z63OrtWZunimgoqomcmTq9uEzoWmgp3dzsd3mqSSiWqas8p_3X3MqZqYorzNyKhozJq4jJqInbDIyYS6aX95jJTItYzPjbedqX6e3c7IuGzNmbivnYKe1c6yhK5ofoZ7q7HLj5mBzXeagXiw3sC4l8qcqKOlk4evm66apmaAhplhs7WP3IK3lZqBeLDewLiXypm5eJqIna_ds5rIZ36sj6qytY_dfcypmpd8rN_Kp2zXmpOboZugn5XGh5KiepylmrG1h5qC3YNmg5-r3LWkfNeBzq-ZnGe4y8d3mqSSiWuXxbl3zoPMe6mDn82Ws9uAlIXbgGOCnd3OyYijoYqKiJ28lIjVlrqHmoSer920pZ6XhqWiY4Z4u5iumdifioqQmciojN59zaKmmYze2LKkfd6cqH1hnYyzzrSZqq56m62ayLmE0ZfQnpx-n9XOtNt8mIXagKSCoc7Rvoeyn4Cfa2LGqK3YfdCeq41oqM3JlIDNh8qAqYKd3c7Gh5ZokoqInbyThNuOqoeahJ6vzrKkfdiSpY2Xmoubl8aIs6KJZISnvqiLzoPMfJyDeazQtaiBz4e1n56GeKjOspqiZouGoWWxpXeag7eanY5nv5m0pXyXkrSApIKhtJbIY7Osk4V_Z63Kf9h90J6rjWe40cikfJqBy3iahXewzb5js6aVn3xhvrR_m33Nd5qBeLDYyJOX1JrNcKWbZrDVx3e2n4Cbf5qwpIDYlpWWoZehn9HIuHnUmqSAZ4Kh3tXKh6erfod4ZceTrtyA0ICmfp7dzr_On92cqJ-ckozRzrSdlmeTea2krc6a0ZbQhJ2Ynq-br85kzJqojJqFd7DTyYfNoYuFf2ety3fOgKZ8pZdnuNHIqJ_PgcummoZ3r9iuna-slKB4ob6kf5uBpqmajmef2cmoedmZuI2rgp7Wx66c2Wd_eYuqvbeuloKqiJqOi96WtNt8lIekgZWFd7DNvmKvopRlhJfIqG_XjrpmmoSesLO4pnmXjLaJc51kl6q2iMWEhJyQYceRps6GlZlkiGfA07nPhcqPzK96jXub0LSEzWyEZGeZxc5n0Y7NgKuXjJ_ataRkp521kZmSi87cs5yabJSdkGfHtZDNirmdqoGM3pe_zpvdnc2iY4-h0rHIc5KrgIiegcfbmriDp3dhiHuo1r-5ibmZzK92kozA27-Gr6yToHybx6em3ofReIuLe9LYtM6r3Ju3o4CHiKjGxoSjrYickInFqHy9iLmie4-NvN20uGSZmaarfZOhwL67YKeQimOZYbvLoqyDu6KZh2io07OTaLeatq-Fm3ub3MaFu2t_d4SpxsuIvZXQa59-o5bYr8-B3pqScKGTd6-brprEr4B2g5qwpICWl5WIqpaMt861ynyXhtt8qoKd3c7JiK-ilJ9rmca4i86DzHxlmGfe3L7beJSHtZphiIi_3LOExGl-hp2psaR_2H3QgGKYoZ_ZwLhkzZK5gZedfNLcv4OqbH51rZrGqG_Tlbpnl45nn97JqJ_PgcumqIV3sM_JiKucimRvqseootB9zaGogXiwz8iUfduZuIiaiJ2v3K6Z2J-VeaKlvrR_m4G3g2aDr7eataV83YXKrpqTjM7cxoironqcpamytXvfgaeHqIKfr96ypH3dkbhsnJtmls60mat9iHaikrfPf5mYzXxhmqG8ub_MgJiByq6anGbS08eZqmx6n49jscuA0IO3e6mOZ7_dv8ue3YaTiGGGrsrNvp26aIqcmp2-tYDNgtCHq36jlqI"
    
    var publicTabbar:TabBarController? = nil
    
    class func initData(fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()){
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setDefaultMaskType(.gradient)
//        SVProgressHUD.setBackgroundColor(UIColor.white)
//        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "正在请求数据")
        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
        let time =  String.noNilStr(str: UserDefaults.standard.object(forKey: username))
        
        
        DLog("增量从本地读取的时间戳******************************************")
        DLog(time)
        DLog(username)
        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { (error) in
            fail(error)
            SVProgressHUD.dismiss()
        }, success: { (dic) in
            SVProgressHUD.dismiss()
            success(dic)
        }
        )
        
    }
    

    
    func startGetMessageNot() -> () {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(getNewMessage(noti:)), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        RCIMClient.shared()
    }
    
    var successB:((_ success:Dictionary<String, Any>) ->())? = nil
    var successList:Array<(_ success:Dictionary<String, Any>) ->()> = Array<(_ success:Dictionary<String, Any>) ->()>.init()
    var successNum = 0
    //失败次数
    var failNum = 0
    var updateTime = "-1"
    
    func addSuccesB(success:@escaping (_ success:Dictionary<String, Any>) ->()){
        
        if self.successB == nil{
            self.successB = {
                dic in
                self.successList.removeAll()
                self.successB = nil
                self.updateTime = "-1"
                DLog("endSucc:\(self.successNum)")
            }
            self.successList.append(self.successB!)
        }
        self.successList.insert(success, at: 0)
        self.successB = {
            dic in
            self.successNum += 1
            for sb in self.successList {
                sb(dic)
            }
        }
    }
    
//    func endGetMessageNot() -> () {
//        <#function body#>
//    }
    
    @objc func getNewMessage(noti:Notification) -> () {
//        DLog("newMessageNo:\(noti.object)")

        let message = noti.object as! RCMessage
        let messageModel = MessageCenterModel.init()

        messageModel.messageId = "\(message.messageId)"
        messageModel.messageUId = (message.messageUId != nil ? message.messageUId : "")!
        messageModel.targetId = message.targetId
        let result = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@", message.targetId))
        if result.count > 0 {
            let groupModel:GroupModel = result.firstObject() as! GroupModel
            messageModel.parentId = groupModel.parentid
        }
        DataBaseOperation.addOnlyData(rlmObject: messageModel)
    }
    
    class func makePushContent(_ messageContent: RCMessageContent! , groupId:String) -> String{
        var pushCo = "" + (messageContent.senderUserInfo != nil ? messageContent.senderUserInfo.name : "")
        
        if GroupModel.objects(with: NSPredicate.init(format: "groupid == %@", groupId)).count > 0
        {
            let gModel:GroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@", groupId)).firstObject() as! GroupModel
            
            
            let groupName = (gModel.group_name as NSString).length>10 ? gModel.group_name.substring(to: (gModel.group_name.index((gModel.group_name.startIndex), offsetBy: 10))) : gModel.group_name
            pushCo = pushCo + "(" + groupName + ") : "
        }
        
       
        DLog(messageContent.self)
        if messageContent.isKind(of: RCTextMessage.self){
            pushCo = pushCo + (messageContent as! RCTextMessage).content
        }else if messageContent.isKind(of: RCImageMessage.self){
            pushCo = pushCo + "[图片]"
        }else if messageContent.isKind(of: RCVoiceMessage.self){
            pushCo = pushCo + "[语音]"
        }else if messageContent.isKind(of: ThemeMessageContent.self){
            pushCo = pushCo + "[话题]" + (messageContent as! ThemeMessageContent).content
        }else if messageContent.isKind(of: HistoryMessageContent.self){
            pushCo = pushCo + "[聊天记录]" + (messageContent as! HistoryMessageContent).title
        }

        DLog(pushCo)
        return pushCo
    }

//    func getToken(uerToken:NSString) {
//        UserRequest.getToken(params: ["appToken":sharePublicDataSingle.token], hadToast: true, fail: { (error) in
//            DLog(error)
//        }) { (dis) in
//            DLog(dis)
//            self.publicData.userid = dis["userid"] as! String
//            self.publicData.avater = dis["avater"] as! String
//            self.publicData.corpid = dis["corpid"] is NSNumber ? (dis["corpid"] as! NSNumber).stringValue : dis["corpid"] as! String
//            self.publicData.realname = dis["realname"] as! String
//            self.publicData.access_token = dis["access_token"] as! String
//            self.publicData.im_token = dis["im_token"] as! String
//        }
//    }
}
