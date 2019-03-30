//
//  GroupNameEditViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/14.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
fileprivate let maxTextLength = 10
class GroupNameEditViewController: BaseViewController {

    var groupModel:GroupModel?{
    
        didSet {
            
            inputTextField.text = (groupModel?.group_name.characters.count)! > maxTextLength ? groupModel?.group_name.substring(to: (groupModel?.group_name.index((groupModel?.group_name.startIndex)!, offsetBy: maxTextLength))!) : groupModel?.group_name
            countLabel.text = "\((inputTextField.text?.characters.count)!)/\(maxTextLength)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "群组名称"
        
        self.setRightBtnWithArray(items: ["完成"])
        self.view.addSubview(inputTextField)
        self.view.addSubview(countLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func rightBtnClick(button: UIButton) {

        self.progressShow()
        GroupRequest.update(params: ["app_token":sharePublicDataSingle.token,"groupid":groupModel?.groupid,"group_name":inputTextField.text], hadToast: true, fail: { [weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
            }
        }) { [weak self](dic) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
                let realm:RLMRealm = RLMRealm.default()
                realm.beginWriteTransaction()
                strongSelf.groupModel?.setValue(strongSelf.inputTextField.text, forKey: "group_name")
                try? realm.commitWriteTransaction()
                strongSelf.navigationController!.popViewController(animated: true)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.endEditing(true)
    }
    //MARK: --------------------------- Getter and Setter --------------------------
    fileprivate lazy var inputTextField: GroupNameEditTextField = {
        var inputTextField = GroupNameEditTextField.init(placeholder: "请输入群组名称")
        inputTextField.frame = CGRect.init(x: 15, y: NAV_HEIGHT + 15, width: SCREEN_WIDTH - 15 * 2, height: inputTF_height)
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged);
        return inputTextField
    }()
    
    fileprivate lazy var countLabel: UILabel = {
        var countLabel = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH - 15 - 40, y: NAV_HEIGHT + 15 + inputTF_height + 5, width: 40, height: 30))
        countLabel.font = FONT_14
        countLabel.textColor = UIColor.gray
        countLabel.textAlignment = .right
        return countLabel
    }()
    @objc func textFieldDidChange(textField : UITextField) { //同样的代码:适配iOS8
        if textField.textInputMode?.primaryLanguage == "zh-Hans" { //键盘输入模式 : 简体中文输入，包括简体拼音，健体五笔，简体手写
            let selectedRange : UITextRange? = textField.markedTextRange
            //获取高亮部分
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textField.position(from: (selectedRange?.start)!, offset: 0)!
            }
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if position == nil {
                if (textField.text?.characters.count)! > maxTextLength {
                    textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.startIndex)!, offsetBy: maxTextLength))!)
                    countLabel.text = "\(maxTextLength)/\(maxTextLength)"
                    return
                }
                countLabel.text = "\((textField.text?.characters.count)!)/\(maxTextLength)"
            }else{ //有高亮选择的字符串，则暂不对文字进行统计和限制
            
            }
        }else{ //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (textField.text?.characters.count)! > maxTextLength {
                textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.startIndex)!, offsetBy: maxTextLength))!)
                countLabel.text = "\(maxTextLength)/\(maxTextLength)"
                return
            }
            countLabel.text = "\((textField.text?.characters.count)!)/\(maxTextLength)"
        }
    }
}
extension GroupNameEditViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var str = textField.text?.replacingCharacters(in: (textField.text?.changeToRange(from: range)!)!, with: string)
        if textField.textInputMode?.primaryLanguage == "zh-Hans" {
            let selectedRange : UITextRange? = textField.markedTextRange
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textField.position(from: (selectedRange?.start)!, offset: 0)!
            }
            if position == nil {
                if (str?.characters.count)! > maxTextLength {
                    textField.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
                    countLabel.text = "\(maxTextLength)/\(maxTextLength)"

                    return false
                }

            }else{
                
            }
        }else{
            if (str?.characters.count)! > maxTextLength {
                textField.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
                countLabel.text = "\(maxTextLength)/\(maxTextLength)"
                return false
            }

        }
        return true

    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        countLabel.text = "0/\(maxTextLength)"
        return true
    }

}
