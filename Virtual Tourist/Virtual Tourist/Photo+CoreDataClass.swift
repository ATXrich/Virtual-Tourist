//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/25/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)!
        super.init(entity: entity, insertInto: context)
        id = dictionary["id"] as! String
        imageURL = dictionary["url_m"] as! String
        imageData = nil
    }
    
    static func photosFromResult(_ result: AnyObject, context: NSManagedObjectContext) -> [Photo] {
        var photos = [Photo]()
        if let photosResult = result["photos"] as? NSDictionary {
            if let photosArray = photosResult["photo"] as? [[String:AnyObject]] {
                for dict in photosArray {
                    let photo = Photo(dictionary: dict, context: context)
                    photos.append(photo)
                }
            }
        }
        return photos
    }


}
