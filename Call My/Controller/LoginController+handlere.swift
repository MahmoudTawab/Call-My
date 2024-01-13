//
//  LoginController+handlere.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 2/28/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

     func handleRegister() {
        guard let email = emailTextField.text, let password = PasswordTextField.text, let name = nameTextField.text else {
            print("Form is not velid")
            return
        }
        
         LoadingOverlay.shared.showOverlay(view: self.view)
        Auth.auth().createUser(withEmail: email, password: password , completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // MARK: - hadleLogin//
            
            guard let uid = user?.user.uid  else {
                return
            }
            
            // MARK: - image successful authenficated user
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let _ = self.profileImageViwe.image, let
                uploadData = self.profileImageViwe.image!.jpegData(compressionQuality: 0.4) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil, metadata != nil {
                        print(error ?? "")
                        return
                        
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registerUsreIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                            LoadingOverlay.shared.hideOverlayView()
                        }
                    })
                })
            }
        })
    }
    
     func registerUsreIntoDatabaseWithUID(uid:String , values:[String:AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            let user = User()
            //this setter potentially crashes if keys don't match
            user.name = values["name"] as? String
            self.messagesController?.setupNavBarWithUser(user: user)
            PresenController(Controller: self)
            self.emailTextField.text = ""
            self.nameTextField.text = ""
            self.PasswordTextField.text = ""
        })
    }
    @objc func handleSelectProfileImageViwe() {
        let pulse = Pulsing(numberOfPluses: 2, radius: 180, position: profileImageViwe.frame)
        pulse.animationDuration = 0.2
        pulse.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: profileImageViwe.layer)
        let ImagePickerController = UIImagePickerController()
        //
        ImagePickerController.allowsEditing = true
        //
        ImagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                ImagePickerController.sourceType = .camera
                ImagePickerController.modalPresentationStyle = .fullScreen
                self.present(ImagePickerController, animated: true , completion: nil)
            }
            else{
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            ImagePickerController.sourceType = .photoLibrary
            ImagePickerController.modalPresentationStyle = .fullScreen
            self.present(ImagePickerController, animated: true , completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.modalPresentationStyle = .fullScreen
        self.present(actionSheet, animated: true , completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        profileImageViwe.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
