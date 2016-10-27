//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation
import CoreData
 

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var hasPhotos: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photo: Photo?

}
