//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation
import CoreData
import MapKit


public class Pin: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(annotation: MKPointAnnotation, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context)!
        super.init(entity: entity, insertInto: context)
        self.hasPhotos = false
        self.latitude = annotation.coordinate.latitude
        self.longitude = annotation.coordinate.longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
