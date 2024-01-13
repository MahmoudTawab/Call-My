//
//  ChatLogController.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/3/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import MobileCoreServices

class ChatLogController: UICollectionViewController , UICollectionViewDelegateFlowLayout ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIGestureRecognizerDelegate {
    
    var user:User? {
    didSet {
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
    if let profileImageUrl = user?.profileImageUrl {
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
    nameLabel.text = user?.name

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    // need x, y,white,height constraints
    nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor , constant: 8).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
    self.navigationItem.titleView = titleView
    observeMessages()
    }
    }
    ///
    
    @objc func showimage() {
    if  popImageViwe.isHidden == true {
    popImageViwe.isHidden = false
    inputContainerView.isHidden = true
    }else{
    popImageViwe.isHidden = true
    inputContainerView.isHidden = false
    }
    }
    
    var messages = [Message]()
    
    //
    func observeMessages() {
    guard let uid = Auth.auth().currentUser?.uid , let toId = user?.id else {
    return
    }
    let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
    userMessagesRef.observe(.childAdded, with: { (snapshot) in
    let messagesId = snapshot.key
    let messagesRef = Database.database().reference().child("messages").child(messagesId)
    messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
    guard let dictionary = snapshot.value as? [String:AnyObject] else {
    return
    }
    self.messages.append(Message(dictionary: dictionary))
    DispatchQueue.main.async(execute: {
    self.collectionView.reloadData()
    ///////////
    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
    ///////////
    })
    }, withCancel: nil)
    }, withCancel: nil)
    }
    //
    let popImageViwe = UIView()
    let popImage = UIImageView()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    popImageViwe.isHidden = true
    popImage.translatesAutoresizingMaskIntoConstraints = false
    popImage.contentMode = .scaleToFill
    popImage.clipsToBounds = true
    popImage.layer.cornerRadius = 20
    if let profileImageUrl = user?.profileImageUrl {
    popImage.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
    }
    popImageViwe.translatesAutoresizingMaskIntoConstraints = false
    popImageViwe.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    view.addSubview(popImageViwe)
    popImageViwe.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    popImageViwe.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    popImageViwe.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    popImageViwe.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    ///
    let DuubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDuubleTapped))
    DuubleTap.numberOfTapsRequired = 2
    DuubleTap.delegate = self
    popImageViwe.addGestureRecognizer(DuubleTap)
    ///
    popImageViwe.addSubview(popImage)
    popImage.topAnchor.constraint(equalTo: popImageViwe.topAnchor, constant: 100).isActive = true
    popImage.bottomAnchor.constraint(equalTo: popImageViwe.bottomAnchor, constant: -50).isActive = true
    popImage.leftAnchor.constraint(equalTo: popImageViwe.leftAnchor, constant: 40).isActive = true
    popImage.rightAnchor.constraint(equalTo: popImageViwe.rightAnchor, constant: -40).isActive = true
    //
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.8911948964, green: 0.8911948964, blue: 0.8911948964, alpha: 1)
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
    collectionView.keyboardDismissMode = .interactive
    IQKeyboardManager.shared.enable = false
    setupKeyboardObservers()
////
    }
    //
    @objc func screenWasDuubleTapped() {
    popImageViwe.isHidden = true
    inputContainerView.isHidden = false
    }
//
    func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    @objc func handleKeyboardDidShow() {
    if messages.count > 0 {
    let indexPath = NSIndexPath(item: messages.count - 1, section: 0)
    collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
    }
    }
    ///
    lazy var inputContainerView : ChatInputContanerView = {
    let chatInputContanerView = ChatInputContanerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 58))
       chatInputContanerView.chatLogController = self
    return chatInputContanerView
    }()

    //
    @objc func handleUploadTap() {
    let ImagePickerController = UIImagePickerController()
    //
    ImagePickerController.allowsEditing = true
    //
    ImagePickerController.delegate = self
    ImagePickerController.mediaTypes = [kUTTypeImage , kUTTypeMovie] as [String]
    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
    if UIImagePickerController.isSourceTypeAvailable(.camera){
    ImagePickerController.sourceType = .camera
    ImagePickerController.modalPresentationStyle = .fullScreen
    self.present(ImagePickerController, animated: true , completion: nil)
    }else{
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    if let vidoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
    handleVideoSelectedForUrl(url: vidoUrl)
    }else{
    handelImageSelectedForInfo(info: info as [UIImagePickerController.InfoKey : AnyObject])
    }
    picker.dismiss(animated: true, completion: nil)
    }
    ////
    private func handelImageSelectedForInfo(info:[UIImagePickerController.InfoKey:AnyObject]) {
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
    let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
    uploadToFirebaseStorageUsingImage(image: selectedImage) { (imageUrl) in
    self.sendMessadewithImageUrl(imageUrl: imageUrl, image:selectedImage)
    }
        
    }
    /////
    public func handleVideoSelectedForUrl(url:NSURL) {
    let filename = NSUUID().uuidString + ".mov"
    let uploadTask = Storage.storage().reference().child("message_movies").child(filename)
    uploadTask.putFile(from: url as URL, metadata: nil) { (metadata, error) in
    if error != nil {
    print("Failed upload of video:",error!)
    return
    }
    uploadTask.downloadURL(completion: { (url, err) in
    if err != nil{
    print(err as Any)
    return
    }else{
    if let videoUrl = url?.absoluteString {
    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url! as NSURL) {
    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in
    let Properties:[String : Any] = ["imageUrl":imageUrl,"imagewidth":thumbnailImage.size.width,"imageheight":thumbnailImage.size.height,"videoUrl":videoUrl as Any]
    self.sendMessageWithProperties(Properties: Properties as [String : AnyObject])
    })
    }
    }
    }
    })
    }
    }
    /////
    public func thumbnailImageForFileUrl(fileUrl:NSURL) -> UIImage? {
    let asset = AVAsset(url: fileUrl as URL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    do{
    let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
    return UIImage(cgImage: thumbnailCGImage)
    }catch let err {
    print(err)
    }
    return nil
    }
    /////
    public func uploadToFirebaseStorageUsingImage(image: UIImage , completion:@escaping (_ imageUrl:String) -> () ) {
    let imageName = NSUUID().uuidString
    let ref = Storage.storage().reference().child("message_images").child("\(imageName).jpg")
    if let uploadData = image.jpegData(compressionQuality: 0.4) {
    ref.putData(uploadData, metadata: nil) { (metadata, error) in
    if error != nil{
    print("Failed to upload image:", error as Any)
    return
    }
    ref.downloadURL(completion: { (url, err) in
    if err != nil{
    print(err as Any)
    return
    }
    else{
    let imageUrl = url?.absoluteString
    completion(imageUrl!)
    }
    })
    }
    }
    }
    /////
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
    }
    //
    override var inputAccessoryView: UIView? {
    get {
    return inputContainerView
    }
    }
    ///
    override var canBecomeFirstResponder: Bool {
    return true
    }
    ///
    override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
    }
    ///
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
    }
    //
    var users : User?
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
    cell.chatLogController = self
    let message = messages[indexPath.item]
    
    cell.message = message
    cell.textView.text = message.text
    
    if let seconds = message.timestamp?.doubleValue {
    let timestamDate = NSDate(timeIntervalSince1970: seconds)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mma, MMMM d"
    cell.timeLabel.text = dateFormatter.string(from: timestamDate as Date)
    cell.timeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
        
    setupCell(cell: cell, message: message)
    if let text = message.text {
    cell.bubbleWidthAnchor?.constant = estimateFrameForText(txet:text).width + 32
    cell.textView.isHidden = false
    }
    else if message.imageUrl != nil {
    //fall in here if its an image message
    cell.bubbleWidthAnchor?.constant = 220
    cell.textView.isHidden = true
    }
    cell.playButton.isHidden = message.videoUrl == nil
    
    return cell
    }
    
    //nnnnnnnnnnnnn
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    //nnnnnnnnnnnnnnnnn
    
    var profileImageViwe : ChatInputContanerView?
    private func setupCell(cell:ChatMessageCell ,message:Message) {
    if let profileImageUrl = self.user?.profileImageUrl {
    cell.profileImageViwe.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
    }
    
    if message.fromId == Auth.auth().currentUser?.uid {
    //outgoing Color1
    cell.bubbleView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    cell.textView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    cell.profileImageViwe.isHidden = true
    cell.bubbleViewRightAnchor?.isActive = true
    cell.bubbleViewleftAnchor?.isActive = false
        
    cell.timeLabelRightAnchor?.isActive = true
    cell.timeLabelleftAnchor?.isActive = false
    }else{
    //incoming Color2
    cell.bubbleView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    cell.textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    cell.profileImageViwe.isHidden = false
    cell.bubbleViewRightAnchor?.isActive = false
    cell.bubbleViewleftAnchor?.isActive = true
            
    cell.timeLabelRightAnchor?.isActive = false
    cell.timeLabelleftAnchor?.isActive = true
    }
    if let messageImageUrl = message.imageUrl {
    cell.messageImageViwe.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
    cell.messageImageViwe.isHidden = false
    cell.bubbleView.backgroundColor = UIColor.clear
    }else{
    cell.messageImageViwe.isHidden = true
    }
   
    }
    //
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height:CGFloat = 80
        
    let message = messages[indexPath.item]
        
    if let txet = message.text {
    height = estimateFrameForText(txet: txet).height + 20
    }
    else if let imagewidth = message.imagewidth?.floatValue , let imageheight = message.imageheight?.floatValue {
    height = CGFloat(imageheight / imagewidth * 220)
    }
    /////////
    let width = UIScreen.main.bounds.width
    return CGSize(width: width , height: height)
    }
    //
    private func estimateFrameForText(txet:String) -> CGRect {
    let size = CGSize(width: 250, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return  NSString(string: txet).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)], context: nil)
    }
    //

    @objc func handleSend() {
    if self.inputContainerView.inputTextField.text != "" {
    let Properties = ["text":inputContainerView.inputTextField.text!] as [String : Any]
    sendMessageWithProperties(Properties: Properties as [String : AnyObject])
    }else{
    self.inputContainerView.inputTextField.shaking()
    }
    }

    ////

    public  func sendMessadewithImageUrl(imageUrl:String ,image:UIImage){
    let Properties:[String : Any] = ["imageUrl":imageUrl,"imagewidth":image.size.width,"imageheight":image.size.height]
    sendMessageWithProperties(Properties: Properties as [String : AnyObject])
    }
    //////
    public func sendMessageWithProperties(Properties: [String:AnyObject]) {
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = user!.id!
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = NSDate().timeIntervalSince1970
    var values:[String : Any] = ["toId": toId ,"fromId":fromId , "timestamp": timestamp]
    ///
    Properties.forEach({values[$0] = $1})
    childRef.updateChildValues(values) { (error, ref) in
    if error != nil {
    print(error ?? "")
    return
    }
    self.inputContainerView.inputTextField.text = nil

    guard let messageId = childRef.key else { return }
            
    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
    userMessagesRef.setValue(1)
    
    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
    recipientUserMessagesRef.setValue(1)
    };
    }

    var startingFrame:CGRect?
    var blackBackgroundViwe:UIView?
    var startingImageViwe:UIImageView?
    //my custom zooming logic
    func performZoomInForStartingImageViwe(startingImageViwe:UIImageView) {
    self.startingImageViwe = startingImageViwe
    self.startingImageViwe?.isHidden = true
    startingFrame = startingImageViwe.superview?.convert(startingImageViwe.frame, to: nil)
    let zoomIngImageViwe = UIImageView(frame: startingFrame!)
    zoomIngImageViwe.image = startingImageViwe.image
    zoomIngImageViwe.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
    zoomIngImageViwe.isUserInteractionEnabled = true

    if let keyWindow = UIApplication.shared.keyWindow{
    blackBackgroundViwe = UIView(frame: keyWindow.frame)
    blackBackgroundViwe?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    blackBackgroundViwe?.alpha = 0
    keyWindow.addSubview(blackBackgroundViwe!)
    keyWindow.addSubview(zoomIngImageViwe)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
    self.blackBackgroundViwe?.alpha = 1
    self.inputContainerView.alpha = 0
    let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
    zoomIngImageViwe.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height:height)
    zoomIngImageViwe.center = keyWindow.center
    }) { (completed) in
    }
    }
    if UIDevice.current.orientation.isLandscape {
    zoomIngImageViwe.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: self.view.frame.height - 60)
    zoomIngImageViwe.center = self.view.center
    }
    }
    
    
    @objc func handleZoomOut(tapGesture:UITapGestureRecognizer) {
    if let zoomOutImageViwe = tapGesture.view {
    zoomOutImageViwe.layer.cornerRadius = 17.5
    zoomOutImageViwe.clipsToBounds = true
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
    zoomOutImageViwe.frame = self.startingFrame!
    self.blackBackgroundViwe?.alpha = 0
    self.inputContainerView.alpha = 1
    }) { (completed) in
    zoomOutImageViwe.removeFromSuperview()
    self.startingImageViwe?.isHidden = false
    }
    }
    }
    @objc func Dawnfunc() {
    DispatchQueue.main.async(execute: {
    self.collectionView.reloadData()
    ///////////
    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
    ///////////
    })
    }

}


