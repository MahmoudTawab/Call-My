//
//  ChatMessageCell.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/9/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message:Message?
    var chatLogController:ChatLogController?
    
    let activityIndicatorView:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.translatesAutoresizingMaskIntoConstraints = false
    aiv.hidesWhenStopped = true
    aiv.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    return aiv
    }()

    lazy var playButton : UIButton = {
        let button  = UIButton(type: .custom)
        button.setImage(UIImage(named: "PLAY"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    var playerLayer:AVPlayerLayer?
    var player:AVPlayer?
    @objc func handlePlay(){
        if let videoUrlString = message?.videoUrl , let url = NSURL(string: videoUrlString)  {
        player = AVPlayer(url: url as URL)
        let vc = AVPlayerViewController()
        vc.player = player
        activityIndicatorView.startAnimating()
        print("Attempting to play video.......???")
        playButton.isHidden = true
        vc.exitsFullScreenWhenPlaybackEnds = true
        chatLogController?.present(vc, animated: true) {
        vc.player?.play()
        self.playButton.isHidden = false
        self.activityIndicatorView.stopAnimating()
        }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    /////
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = UIColor.clear
        tv.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
       return tv
    }()
    
    let bubbleView: UIView = {
      let View = UIView()
        View.backgroundColor = UIColor.black
        View.translatesAutoresizingMaskIntoConstraints = false
        View.layer.cornerRadius = 16
        View.layer.masksToBounds = true
        return View
    }()
////
    let profileImageViwe:UIImageView = {
       let imageViwe = UIImageView()
        imageViwe.image = UIImage(named: "Group")
        imageViwe.translatesAutoresizingMaskIntoConstraints = false
        imageViwe.contentMode = .scaleAspectFill
        imageViwe.layer.borderWidth = 0.5
        imageViwe.layer.cornerRadius = 17.5
        imageViwe.layer.masksToBounds = true
        imageViwe.isUserInteractionEnabled = true
        return imageViwe
    }()
    
    //
    lazy var messageImageViwe:UIImageView = {
        let imageViwe = UIImageView()
        imageViwe.translatesAutoresizingMaskIntoConstraints = false
        imageViwe.contentMode = .scaleAspectFill
        imageViwe.layer.borderWidth = 0.5
        imageViwe.layer.cornerRadius = 17.5
        imageViwe.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageViwe.layer.masksToBounds = true
        imageViwe.isUserInteractionEnabled = true
        imageViwe.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageViwe
    }()
    
    @objc func handleZoomTap(TapGesture:UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        if let imageViwe = TapGesture.view as? UIImageView {
            self.chatLogController!.performZoomInForStartingImageViwe(startingImageViwe: imageViwe)
        }
    }
    
    //
    let timeLabel : UILabel = {
        let Label = UILabel()
        Label.font = UIFont.systemFont(ofSize: 12)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()

    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor:NSLayoutConstraint?
    var bubbleViewleftAnchor:NSLayoutConstraint?
    var timeLabelRightAnchor:NSLayoutConstraint?
    var timeLabelleftAnchor:NSLayoutConstraint?
    //
    override init(frame: CGRect) {
        super.init(frame:frame)
    addSubview(bubbleView)
    addSubview(textView)
    addSubview(profileImageViwe)
    bubbleView.addSubview(messageImageViwe)
    addSubview(timeLabel)

        // need x, y,white,height constraints
        messageImageViwe.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageViwe.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageViwe.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageViwe.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        // need x, y,white,height constraints
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // need x, y,white,height constraints
        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // need x, y,white,height constraints
        profileImageViwe.rightAnchor.constraint(equalTo: self.rightAnchor ,constant: -8).isActive = true
        profileImageViwe.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageViwe.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImageViwe.heightAnchor.constraint(equalToConstant: 35).isActive = true
        // need x, y,white,height constraints
        bubbleViewRightAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor ,constant: 10)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewleftAnchor = bubbleView.rightAnchor.constraint(equalTo: profileImageViwe.leftAnchor ,constant: -8)
//        bubbleViewleftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        // need x, y,white,height constraints
        timeLabelRightAnchor = timeLabel.leftAnchor.constraint(equalTo:  self.leftAnchor ,constant: 20)
        timeLabelRightAnchor?.isActive = true
        
        timeLabelleftAnchor = timeLabel.rightAnchor.constraint(equalTo:  self.rightAnchor ,constant: -25)
        //        bubbleViewleftAnchor?.isActive = false
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor,constant: 20).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //     need x, y,white,height constraints
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor , constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
