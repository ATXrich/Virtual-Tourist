//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/25/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var id: String
    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: String
    @NSManaged public var pin: Pin

}
