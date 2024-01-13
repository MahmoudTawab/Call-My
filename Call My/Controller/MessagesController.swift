//
//  MessagesController.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 2/19/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController , UIGestureRecognizerDelegate  {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//      navigationController?.hidesBarsOnSwipe = true
        let image = UIImage(named: "Group 2")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = ""
        navigationController?.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        fetchUserAndSetupNavBarTitle()
        }
    
    ///
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
         let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
        let userId = snapshot.key
    Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
    let messageId = snapshot.key
    self.fetcMeesageWithMessageId(messageId: messageId)
    }, withCancel: nil)
    }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            
            print(snapshot.key)
            print(self.messagesDictionary)
            
            self.messagesDictionary.removeValue(forKey: snapshot.key)
             self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    ///
    private func fetcMeesageWithMessageId(messageId:String){
    let messagesReference = Database.database().reference().child("messages").child(messageId)
    messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
    
    if let dictionary = snapshot.value as? [String:AnyObject] {
    let message = Message(dictionary: dictionary)

    if let chatPartnerId = message.chatPartnerId() {
    self.messagesDictionary[chatPartnerId] = message
    
    }
    self.attemptReloadOfTable()
    
    }
    }, withCancel: nil)
    }
    ///
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    ///
    var timer:Timer?
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            do{
                return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!;
            } catch {
                print("Eroor")
            }
        })
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
//        tableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let dictionary = snapshot.value as? [String:AnyObject] else{
        return
        }
        let user = User()
        user.name = dictionary["name"] as? String
        user.email = dictionary["email"] as? String
        user.profileImageUrl = dictionary["profileImageUrl"] as? String
        user.id = snapshot.key
        user.id = chatPartnerId
        self.showChatControllerForUser(user: user)
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
     }
     ///
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     guard let uid = Auth.auth().currentUser?.uid else {
         return
     }
     let message = self.messages[indexPath.row]
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this messages", preferredStyle: .alert)
        let Yes = UIAlertAction(title: "Yes", style: .destructive) { (Action) in
        if let chatPartnerId = message.chatPartnerId() {
        Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
        if error != nil {
        print("Failed to delete message:",error!)
        return
        }
        }
        self.messagesDictionary.removeValue(forKey: chatPartnerId)
        self.attemptReloadOfTable()
        }
        }
        let No = UIAlertAction(title: "No", style: .default)
        alert.addAction(No)
        alert.addAction(Yes)
        alert.modalPresentationStyle = .fullScreen
        self.present(alert , animated: true , completion: nil);
     }
    
    @objc func handleNewMessage() {
        let newMessagesController = NewMessagesController()
        newMessagesController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessagesController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }



    func fetchUserAndSetupNavBarTitle() {
        guard let uid =  Auth.auth().currentUser?.uid else {return}
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

        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()

        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showimage)))
        let profileImageView = UIImageView()
        profileImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImageView.layer.borderWidth = 0.5
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 22.5
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        titleView.addSubview(profileImageView)
         // need x, y,white,height constraints
        profileImageView.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        let nameLabel = UILabel()
        titleView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // need x, y,white,height constraints
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor , constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        self.navigationItem.titleView = titleView

//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    @objc func showimage(){
        let newMessagesController = PopViweUser()
        newMessagesController.messagesController = self
        newMessagesController.modalPresentationStyle = .fullScreen
        present(newMessagesController, animated: true, completion: nil)
    }

    //
    @objc func showChatControllerForUser(user:User) {
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "log out", style: .destructive , handler: { (_) in
        do {
        try Auth.auth().signOut()
        ToPresenController(Controller: self)
        }catch let signOutErr {
        print("Failed to sign out:",signOutErr)
        }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        }

}


