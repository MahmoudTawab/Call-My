//
//  UserCell.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/5/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message:Message? {
        didSet {
            
         setupNameAndProfileImage()
            
            if message?.text != nil {
            detailTextLabel?.text = message?.text
            }
            
            if message?.imageUrl != nil {
            detailTextLabel?.text = "🌄 Image"
            }
            
            if message?.videoUrl != nil {
            detailTextLabel?.text = "🎬 video"
            }
            
            //
            if let seconds = message?.timestamp?.doubleValue {
            let timestamDate = NSDate(timeIntervalSince1970: seconds)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:m a"
                timeLabel.text = dateFormatter.string(from: timestamDate as Date)
            }
        }
    }
    
     func  setupNameAndProfileImage() {
     if let id = message?.chatPartnerId() {
        let ref = Database.database().reference().child("users").child(id)
        ref.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.textLabel?.text = dictionary["name"] as? String
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                }
            }
        }, withCancel: nil)
    }
    }
    
    //
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y-1.5, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y+1.5, width: detailTextLabel!.frame.width , height: detailTextLabel!.frame.height)
    }
    //
    let profileImageView : UIImageView = {
        let ImageView = UIImageView()
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.layer.cornerRadius = 30
        ImageView.contentMode = .scaleAspectFill
        ImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ImageView.layer.borderWidth = 1
        ImageView.layer.masksToBounds = true
        ImageView.isUserInteractionEnabled = true
        return ImageView
    }()
    
    let timeLabel : UILabel = {
    let Label = UILabel()
    Label.font = UIFont.systemFont(ofSize: 13)
    Label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    Label.translatesAutoresizingMaskIntoConstraints = false
    return Label
    }()
    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)

        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor , constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo:self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
