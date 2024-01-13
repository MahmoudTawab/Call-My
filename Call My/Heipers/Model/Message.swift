//
//  Message.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/5/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class Message: NSObject {
    
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    
    var imageUrl:String?
    var imagewidth:NSNumber?
    var imageheight:NSNumber?
    var videoUrl:String?
    
    func chatPartnerId() -> String? {
    return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        
}
    init(dictionary:[String:AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
    
        imageUrl = dictionary["imageUrl"] as? String
        imagewidth = dictionary["imagewidth"] as? NSNumber
        imageheight = dictionary["imageheight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
}
