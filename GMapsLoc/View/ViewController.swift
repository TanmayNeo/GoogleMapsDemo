//
//  ViewController.swift
//  GMapsLoc
//
//  Created by apple on 09/03/23.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    let locationManager = LocationManager.shared
    let googleAPIManager = GoogleAPIManager.shared
    
    private lazy var camera : GMSCameraPosition = {
        let cam = GMSCameraPosition(latitude: 37.323,
                                    longitude: -122.03218,
                                    zoom: 2.0)
        return cam
    }()
    
    private lazy var mapView : GMSMapView = {
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.frame = self.view.bounds
        return mapView
    }()
    
    private let viewModel : MapViewModel = {
        let vm = MapViewModel()
        return vm
    }()
    
    private lazy var marker : GMSMarker = {
        let marker = GMSMarker()
        marker.title = "Current Location"
        marker.snippet = "Your Location"
        marker.map = mapView
        return marker
    }()
    
    private lazy var restMarker : [GMSMarker] = {
        let restMarker = [GMSMarker]()
        return restMarker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleAPIManager.setupMapview(mapView: mapView)
        setupCallBacks()
        self.view.addSubview(mapView)
    }
    
    //Set location manager
    private func setupCallBacks(){
        LocationManager.shared.didReceiveUserLocation = { locn in
            print(locn)
        }
        locationManager.startUpdate()
        locationManager.didReceiveUserLocation = { userLoc in
            self.camera = GMSCameraPosition(latitude: userLoc.coordinate.latitude,
                                            longitude: userLoc.coordinate.longitude,
                                            zoom: 15.0)
            self.mapView.mapType = .satellite
            self.mapView.camera = self.camera
            let location = CLLocationCoordinate2D(latitude: userLoc.coordinate.latitude,
                                                  longitude: userLoc.coordinate.longitude)
            
            
            
            self.marker.position = location
            self.viewModel.fetchUserAddress(location: location)
        }
        
        googleAPIManager.didTapOnMarker = { marker in
            DispatchQueue.main.async {
                let addressText = "\(self.viewModel.getUserAddress())"
                let alert = UIAlertController(title: "Address",
                                              message: addressText,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Done",
                                           style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    //func to fetch all the nearby restaurants
    func setRestaurantMarkers(userLoc : CLLocationCoordinate2D){
        self.viewModel.fetchNearbyRestaurants(coordinate: userLoc) { restaurants in
            
            DispatchQueue.main.async {
                for restaurant in restaurants{
                    let newRest = GMSMarker(position: CLLocationCoordinate2D(latitude: restaurant.geometry.location.lat,
                                                                             longitude: restaurant.geometry.location.lng))
                    newRest.appearAnimation = .pop
                    newRest.title = restaurant.name
                    newRest.icon = UIImage(named: "restaurant_pin")
                    self.restMarker.append(newRest)
                }
                self.restMarker.forEach({$0.map = self.mapView})
            }
        }
    }
}
