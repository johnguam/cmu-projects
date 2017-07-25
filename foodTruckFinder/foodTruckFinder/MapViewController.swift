//
//  MapViewController.swift
//  foodTruckFinder
//
//  Created by Lee, John on 7/16/17.
//  Copyright © 2017 Silver Lining. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    enum Constant {
        static let latitude: CLLocationDegrees = 37.3533530886479
        static let longitude: CLLocationDegrees = -122.013784749846
        static let radius = 500
        static let regionRadius: CLLocationDistance = 1000
    }
    
    @IBOutlet fileprivate var mapView: MKMapView!
    fileprivate var locationManager = CLLocationManager()
    let mobileEatsService = MobileEatsService()
    var searchResults: [FoodTruck] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        let location = CLLocation(latitude: Constant.latitude, longitude: Constant.longitude)
        centerMapOnLocation(location: location)
        
        populateMap()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, Constant.regionRadius * 2, Constant.regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func populateMap() {
        
        mobileEatsService.getSearchResults(latitude: Constant.latitude, longitude: Constant.longitude, radius: Constant.radius) { results, errorMessage in
            if let results = results {
                self.searchResults = results
                self.mapView.addAnnotations(self.searchResults)
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}