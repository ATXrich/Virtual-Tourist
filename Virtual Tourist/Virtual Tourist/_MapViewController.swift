//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/11/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsView: UIView!
    var isEdit = false
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPins()
        loadMapViewRegion()
        placePinsOnMap()
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "OK", syle: .plain, target: nil, action: nil)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotation(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    override func viewDidLayoutSubviews() {
        deletePinsView.center.y += deletePinsView.frame.height
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isEdit = !isEdit
        if isEdit {
            sender.title = "Done"
            UIView.animate(withDuration: 0.25, animations: { 
                self.mapView.frame.origin.y -= self.deletePinsView.frame.height
                self.deletePinsView.center.y -= self.deletePinsView.frame.height
            })
        } else {
            sender.title = "Edit"
            UIView.animate(withDuration: 0.25, animations: { 
                self.mapView.frame.origin.y += self.deletePinsView.frame.height
                self.deletePinsView.center.y += self.deletePinsView.frame.height
            })
        }
    }
    
    func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != .began || isEdit {
            return
        } else {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoord: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = newCoord
            createNewPinObject(newAnnotation)
            mapView.addAnnotation(newAnnotation)
        }
    }
    
    //TODO: -- fix sharedInstance
    func createNewPinObject(_ annoation: MKPointAnnotation) {
        let pin = Pin(annotation: annoation, context: CoreDataStack.sharedInstance().context)
        pins.append(pin)
        CoreDataStack.sharedInstance().save()
    }
    
    func saveMapViewRegion() {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "Latitude")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "Longitude")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "LatitudeDelta")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "LongitudeDelta")
        
    }
    
    func loadMapViewRegion() {
        if isFirstLaunch() {
            return
        } else {
            let latitude = UserDefaults.standard.double(forKey: "Latitude")
            let longitude = UserDefaults.standard.double(forKey: "Longitude")
            let latitudeDelta = UserDefaults.standard.double(forKey: "LatitudeKey")
            let longitudeDelta = UserDefaults.standard.double(forKey: "LongitudeKey")
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: false)
            
        }
    }
    
    func isFirstLaunch() -> Bool {
        if let notFirstLaunch = UserDefaults.standard.value(forKey: "isFirstLaunch") {
            return notFirstLaunch as! Bool
        } else {
            UserDefaults.standard.set(false, forKey: "isFirstLaunch")
            return true
        }
    }
    
    func fetchPins() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Pin.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: CoreDataStack.sharedInstance().context)
        fetchRequest.entity = entity
        do {
            let foundObjects = try CoreDataStack.sharedInstance().context.fetch(fetchRequest)
            pins = foundObjects as! [Pin]
        } catch {
            fatalError("Could not fetch pins")
        }
    }
    
    func placePinsOnMap() {
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    func obtainPin(_ annotation: MKAnnotation) -> Pin {
        var location: Pin!
        for pin in pins {
            if (annotation.coordinate.latitude == pin.coordinate.latitude && annotation.coordinate.longitude == pin.coordinate.longitude) {
                location = pin
                break
            }
        }
        return location
        
    }
    
//    ovveride func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPhotos" {
//            let albumViewController = segue.destination as! AlbumViewController
//            let currentAnnotation = sender as! MKPointAnnotation
//            albumViewController.currentAnnotation = currentAnnotation
//            AlbumViewController.pin = obtainPin(currentAnnotation)
//        }
//    }



}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation, isEdit {
            self.mapView.removeAnnotation(annotation)
            CoreDataStack.sharedInstance().context.delete(obtainPin(annotation))
            CoreDataStack.sharedInstance().save()
        } else {
            let annotation = view.annotation
            mapView.deselectAnnotation(annotation, animated: false)
            performSegue(withIdentifier: "ShowPhotos", sender: annotation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapViewRegion()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let reuseID = "pin"
            var pin = MKPinAnnotationView()
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pin.animatesDrop = true
            return pin
        }
    }
    
    
    
}

