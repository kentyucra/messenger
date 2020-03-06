//
//  Extensions.swift
//  ChartWithFIrebase1
//
//  Created by kyucraquispe on 3/6/20.
//  Copyright © 2020 kyucraquispe. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        // blank out the image in a start
        self.image = nil
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: NSString(string: urlString)) as? UIImage {
            self.image = cacheImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            //download hit an error so lets return out
            if error != nil {
                print("something is happening to the momento to download the photos")
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
