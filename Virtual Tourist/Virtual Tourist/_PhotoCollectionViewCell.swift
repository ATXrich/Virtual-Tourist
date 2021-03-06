//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataTask: URLSessionDataTask?
    
    func configureCell(_ photo: Photo) {
        if photo.imageData != nil {
            dataTask?.cancel()
            activityIndicator.isHidden = true
            imageView.alpha = 1
            let image = UIImage(data: photo.imageData!)
            self.imageView.image = image
        } else {
            dataTask?.cancel()
            dataTask = nil
            imageView.image = UIImage(named: "Placeholder")
            imageView.alpha = 1
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            dataTask = FlickrClient.sharedInstance.getImage(photo.imageURL, completionHandler: { (imageData, errorString) in
                guard (errorString == nil) else {
                    print("Error downloading image: \(errorString)")
                    return
                }
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain({
                        self.imageView.image = image
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        if let imageData = UIImagePNGRepresentation(image) {
                            photo.imageData = imageData
                        }
                    })
                }
            })
        }
    }
    
    func isImageSelected(_ selected: Bool) {
        if selected {
            imageView.alpha = 0.5
        } else {
            imageView.alpha = 1
        }
    }
    
}
