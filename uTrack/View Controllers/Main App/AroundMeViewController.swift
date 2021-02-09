//
//  AroundMeViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 5/5/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit
import MapKit

class AroundMeViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var regionRadius:CLLocationDistance = 10000
    var stores:[MKMapItem] = [MKMapItem]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        zoomToLocation()
        findStores()
        // Do any additional setup after loading the view.
        //Timers for refreshing (needed for some reason or the view will not populate)
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(findStores), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(findStores), userInfo: nil, repeats: false)
    }
    func zoomToLocation(){
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius) //Zoomed To
        mapView.setRegion(coordinateRegion, animated: true) //set the region
        locationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    @objc func findStores(){ //This is going to find the stores the items might be at!
        var stores = ["Target","Best Buy Electronics", "Staples","Microcenter"]
        self.mapView.removeAnnotations(mapView.annotations) //Make sure previous annotations are removed
        for element in stores{
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = element
            searchRequest.region = mapView.region //Search within this region
            
            let search = MKLocalSearch(request: searchRequest)
            search.start(completionHandler: {(response, error)in //Do the search and apply the results
                if error != nil{ //There was some error
                    
                }
                else if response!.mapItems.count == 0{ //There are no results found around you
                }
                else{
                    for item in response!.mapItems{ //for each item that is found:
                        print("Name = \(item.name)")
                        //addto the list of found items
                        self.stores.append(item as MKMapItem)
                        print("The number of matching items is \(self.stores.count)")
                        //Add the annotation to the map
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
                
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
