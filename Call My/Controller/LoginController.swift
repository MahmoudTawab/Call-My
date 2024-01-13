//
//  LoginController.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 2/19/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation
class LoginController: UIViewController ,UITextFieldDelegate {
    
    var messagesController:MessagesController?
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /////
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
   //
    lazy var loginRegisterButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Button.setTitle("Register", for: .normal)
        Button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        Button.titleLabel?.font = UIFont.init(name: "Snell Roundhand", size: 44)
        Button.layer.cornerRadius = 28
        Button.translatesAutoresizingMaskIntoConstraints = false
        ////////////////
        Button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        ////////////////
        return Button
        
    }()
    ////
    @objc func handleLoginRegister() {
//        //
        if emailTextField.text == "" && PasswordTextField.text == "" {
           self.alertTheUser(title: "message for User", message: "There are no data")
        }
        //
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    ///
    private func alertTheUser(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok);
        alert.modalPresentationStyle = .fullScreen
        present(alert , animated: true , completion: nil);
        
    }
    
    
    
    ////
    func handleLogin() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        guard let email = emailTextField.text ,  let Password = PasswordTextField.text else {
            print("Form is not velid")
            return}
        Auth.auth().signIn(withEmail: email, password: Password) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            // successfully logged in our user
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            self.messagesController?.observeUserMessages()
            PresenController(Controller: self)
            self.emailTextField.text = ""
            self.PasswordTextField.text = ""
            LoadingOverlay.shared.hideOverlayView()

        }
    }

    //
    let nameTextField : UITextField  = {
     let tf = UITextField()
     tf.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     tf.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
     tf.attributedPlaceholder = NSAttributedString(string: "Name",
                                                   attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.652156464)])
     tf.font = UIFont(name: "Snell Roundhand" ,size: 30)
     tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    ///
    let nameSepartorViwe : UIView = {
     let view = UIView()
       view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       view.translatesAutoresizingMaskIntoConstraints = false
     return view
    }()
    ///
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tf.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                      attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.652156464)])
        tf.font = UIFont(name: "Snell Roundhand" ,size: 30)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    ////
    let emailSepartorViwe : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /////
    let PasswordTextField : UITextField = {
        let tf = UITextField()
        tf.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tf.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.attributedPlaceholder = NSAttributedString(string: "Password",
                                                      attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.652156464)])
        tf.font = UIFont(name: "Snell Roundhand" ,size: 30)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    /////
    let PasswordSepartorViwe : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    ///////
    lazy var profileImageViwe : UIImageView = {
        let ImageViwe = UIImageView()
        ImageViwe.layer.cornerRadius = 105
        ImageViwe.clipsToBounds = true
        ImageViwe.image = UIImage(named: "Group")
        ImageViwe.layer.borderWidth = 6
        ImageViwe.translatesAutoresizingMaskIntoConstraints = false
        ImageViwe.contentMode = .scaleAspectFill
        ImageViwe.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ImageViwe.backgroundColor = #colorLiteral(red: 0.7638061643, green: 0.1994748414, blue: 0.161098361, alpha: 1)
        ImageViwe.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageViwe)))
        ImageViwe.isUserInteractionEnabled = true
        return ImageViwe
    }()

    lazy var loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleloginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    ///////
    @objc func handleloginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
       // change height of inputContainerView , dut how???
        inputscontainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 120 : 180
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
          nameSepartorViwe.isHidden = true
            profileImageViwe.alpha = 0
        }else{
         nameSepartorViwe.isHidden = false
            profileImageViwe.alpha = 1
        }
        //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor , multiplier:loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        //change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
       emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor , multiplier:loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change height of PasswordTextField
        PasswordTextFieldHeightAnchor?.isActive = false
        PasswordTextFieldHeightAnchor = PasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor , multiplier:loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
       PasswordTextFieldHeightAnchor?.isActive = true
        
    }
    var audioPlayer = AVAudioPlayer()
    var player:AVAudioPlayer!
    //
    var gradientLayer: CAGradientLayer!
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.20, 0.62]
        self.view.layer.addSublayer(gradientLayer)
        
        //
        let path = Bundle.main.path(forResource: "Hello", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        player.play()
    }
    ///////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
        //
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageViwe)
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsConaiinerView()
        setuploginRegisterButton()
        setupprofileImageViwe2()
        setupRegisterSegmentedControl()
        nameTextField.delegate = self
        emailTextField.delegate = self
        PasswordTextField.delegate = self
//
        view.addSubview(rocket1)
        view.addSubview(rocket2)
        //
        rocket1.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height)
        // Do any additional setup after loading the view, typically from a nib.
        rocket2.frame = CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: view.frame.height)
        // Do any additional setup after loading the view, typically from a nib.
        ///////////////
        //
        if isanamation == false{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LoginController.doAnmation), userInfo: nil, repeats: true)
            
            isanamation = true
        }else {
            isanamation = false
        }
        perform(#selector(MY), with: self, afterDelay: 4)
    }

    func setupRegisterSegmentedControl(){
      // need x, y,white,height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: loginRegisterButton.topAnchor , constant : 130).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor , multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    /////
    func setupprofileImageViwe2() {
        // need x, y,white,height constraints
        profileImageViwe.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageViwe.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor ,constant: -15 ).isActive = true
        profileImageViwe.widthAnchor.constraint(equalToConstant: 210).isActive = true
        profileImageViwe.heightAnchor.constraint(equalToConstant: 210).isActive = true
    }
    ///
    var inputscontainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    var PasswordTextFieldHeightAnchor : NSLayoutConstraint?
    ///
    func setupInputsConaiinerView() {
        // need x, y,white,height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -45).isActive = true
        inputscontainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 180)
        inputscontainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSepartorViwe)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSepartorViwe)
        inputsContainerView.addSubview(PasswordTextField)
        inputsContainerView.addSubview(PasswordSepartorViwe)
           // need x, y,white,height constraints
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor , constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
       nameTextFieldHeightAnchor?.isActive = true
        
          // need x, y,white,height constraints
        nameSepartorViwe.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSepartorViwe.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSepartorViwe.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSepartorViwe.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        // need x, y,white,height constraints
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor , constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // need x, y,white,height constraints
        emailSepartorViwe.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSepartorViwe.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSepartorViwe.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSepartorViwe.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x, y,white,height constraints
        
        PasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor , constant: 12).isActive = true
         PasswordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PasswordTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        PasswordTextFieldHeightAnchor = PasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        PasswordTextFieldHeightAnchor?.isActive = true
        
        // need x, y,white,height constraints
        PasswordSepartorViwe.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        PasswordSepartorViwe.topAnchor.constraint(equalTo: PasswordTextField.bottomAnchor).isActive = true
        PasswordSepartorViwe.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        PasswordSepartorViwe.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    ////
    func setuploginRegisterButton() {
        // need x, y,white,height constraints
         loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor ,constant: 35 ).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    ////
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    let rocket1 : UIImageView = {
        let rocket1 = UIImageView()
        rocket1.image = UIImage(named: "1.tiff")
        rocket1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return rocket1
    }()
    
    let rocket2 : UIImageView = {
        let rocket2 = UIImageView()
        rocket2.image = UIImage(named: "1.tiff")
        rocket2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return rocket2
    }()
    
    
    
    var counter = 0
    var timer = Timer()
    var isanamation = false
    var arry : [String] =    ["1.tiff","2.tiff","3.tiff","4.tiff","5.tiff","6.tiff","7.tiff","8.tiff","9.tiff","10.tiff","11.tiff","12.tiff","13.tiff","14.tiff","15.tiff","16.tiff","17.tiff","18.tiff","19.tiff","20.tiff","21.tiff","22.tiff","23.tiff","24.tiff","25.tiff","26.tiff","27.tiff","28.tiff","29.tiff","30.tiff","31.tiff","32.tiff","33.tiff","34.tiff","35.tiff","36.tiff","37.tiff","38.tiff","39.tiff","40.tiff","41.tiff","42.tiff","43.tiff","44.tiff","45.tiff","46.tiff","47.tiff","48.tiff","49.tiff","50.tiff","51.tiff","52.tiff","53.tiff","54.tiff","55.tiff","56.tiff","57.tiff","58.tiff","59.tiff","60.tiff"]
    @objc func doAnmation (){
        rocket1.image = UIImage(named: arry[counter])
        counter = counter + 1
        if counter == 59 {
            counter = 0
        }
        rocket2.image = UIImage(named: arry[counter])
        counter = counter + 1
        if counter == 59 {
            counter = 0
        }
    }
    @objc func MY() {
        UIView.animate(withDuration: 0.7 , animations: {
            self.rocket2.frame = CGRect(x: self.view.frame.maxX, y:0, width: self.rocket2.frame.width, height: self.rocket2.frame.height)
            self.rocket1.frame = CGRect(x: self.view.frame.minX - self.rocket1.frame.width , y:0, width: self.rocket1.frame.width, height: self.rocket1.frame.height)
        }) { (finished) in
            self.rocket1.isHidden = true
            self.rocket2.isHidden = true
        }
    }

}
