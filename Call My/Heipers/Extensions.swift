//
//  Extensions.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/3/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<NSString,UIImage>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString:String) {
        self.image = nil
    // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data,response,error) in
            //download hit an error so lets return out
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async() {
                if let downloadedimage = UIImage(data: data!) {
                    imageCache.setObject(downloadedimage, forKey: urlString as NSString)
                 self.image = downloadedimage
                }
               
            }
        }).resume()
    }
    
}
