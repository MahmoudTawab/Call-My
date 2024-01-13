//
//  PopViweUser.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 4/1/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase

class PopViweUser: UIViewController , UIGestureRecognizerDelegate {
    
    var messagesController:MessagesController?
    var chatLogController:ChatLogController?
    
    let popImageViwe:UIImageView = {
    let popImageViwe = UIImageView()
    popImageViwe.translatesAutoresizingMaskIntoConstraints = false
    popImageViwe.contentMode = .scaleToFill
    popImageViwe.clipsToBounds = true
    popImageViwe.layer.cornerRadius = 20
    return popImageViwe
    }()
    let Labelname:UILabel = {
        let Labelname = UILabel()
        Labelname.font = UIFont(name: "Snell Roundhand", size: 40)
        Labelname.textAlignment = .center
        Labelname.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Labelname.translatesAutoresizingMaskIntoConstraints = false
        return Labelname
    }()
    func fetchUserAndSetupNavBarTitle() {
        guard let uid =  Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                user.name = dictionary["name"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    func setupNavBarWithUser(user:User) {
        if let profileImageUrl = user.profileImageUrl {
            popImageViwe.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        Labelname.text = user.name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAndSetupNavBarTitle()
        view.addSubview(popImageViwe)
        view.addSubview(Labelname)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //
        popImageViwe.topAnchor.constraint(equalTo: view.topAnchor, constant: 100 ).isActive = true
        popImageViwe.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        popImageViwe.leftAnchor.constraint(equalTo: view.leftAnchor , constant: 40).isActive = true
        popImageViwe.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        //
        Labelname.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        Labelname.bottomAnchor.constraint(equalTo: popImageViwe.topAnchor).isActive = true
        Labelname.leftAnchor.constraint(equalTo: view.leftAnchor , constant: 20).isActive = true
        Labelname.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addDuubleTap()
    }
    func addDuubleTap() {
        let DuubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDuubleTapped))
        DuubleTap.numberOfTapsRequired = 1
        DuubleTap.delegate = self
        view.addGestureRecognizer(DuubleTap)
        
    }
    @objc func screenWasDuubleTapped() {
        dismiss(animated: true, completion: nil)
    }
}
