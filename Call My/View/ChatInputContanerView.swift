//
//  ChatInputContanerView.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/18/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit

class ChatInputContanerView: UIView , UITextFieldDelegate {
    
    var messages = [Message]()
    
    var chatLogController:ChatLogController? {
    didSet {
    sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
    uploadImageView.addTarget(chatLogController, action: #selector(ChatLogController.handleUploadTap), for: .touchUpInside)
    Dawn.addTarget(chatLogController, action: #selector(ChatLogController.Dawnfunc), for: .touchUpInside)
    }
    }

     let inputTextField = ShakingTextField()
    //////

    let uploadImageView:UIButton = {
    let uploadImageView = UIButton(type: .custom)
    uploadImageView.setImage(UIImage.init(named: "Group 5"), for: .normal)
    uploadImageView.translatesAutoresizingMaskIntoConstraints = false
    return uploadImageView
    }()
    ////
    lazy var sendButton : UIButton = {
    let sendButton = UIButton(type: .custom)
    sendButton.setImage(UIImage.init(named: "Group 4"), for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    return sendButton
    }()
    //////
    let Dawn:UIButton = {
    let Dawn = UIButton(type: .custom)
    Dawn.setImage(UIImage.init(named: "Group 6"), for: .normal)
    Dawn.translatesAutoresizingMaskIntoConstraints = false
    return Dawn
    }()

    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(uploadImageView)
        inputTextField.addSubview(Dawn)
        //...inputTextField
        inputTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 38 , height: inputTextField.frame.height))
        inputTextField.rightViewMode = .always
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12 , height: inputTextField.frame.height))
        inputTextField.leftViewMode = .always
        inputTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputTextField.layer.cornerRadius = 24
        inputTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        inputTextField.attributedPlaceholder = NSAttributedString(string: "Enter message....",
                                                             attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3499394806)])
        inputTextField.font = UIFont(name: "Times New Roman" ,size: 25)
        inputTextField.layer.borderWidth = 0.5
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        ///
        // need x, y,white,height constraints
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 53).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 53).isActive = true
        //
       
        addSubview(sendButton)
        // need x, y,white,height constraints
        sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 53).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        //
        addSubview(inputTextField)
        // need x, y,white,height constraints
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 5).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor , constant: -3).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor , constant: -5 ).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        //
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        // need x, y,white,height constraints
        separatorLineView.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo:topAnchor, constant: -1).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo:widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //     need x, y,white,height constraints
        Dawn.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        Dawn.rightAnchor.constraint(equalTo: inputTextField.rightAnchor , constant: 1 ).isActive = true
        Dawn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        Dawn.heightAnchor.constraint(equalToConstant: 48).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //deleteBackward()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       inputTextField.text = ""
        return true
    }
}
