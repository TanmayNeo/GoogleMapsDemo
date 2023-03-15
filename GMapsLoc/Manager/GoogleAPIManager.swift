//
//  GoogleAPIManager.swift
//  GMapsLoc
//
//  Created by apple on 10/03/23.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GoogleAPIManager : GMSServices {
    
    static let shared = GoogleAPIManager()
    private var placesClient = GMSPlacesClient()
    private let networkManager = NetworkManager.shared
    
    var didTapOnMarker : ((GMSMarker) -> ())?
    
    private let apiKey = Bundle.main.infoDictionary?["Api_Key"] as? String
    
    private override init (){
        super.init()
        self.setup()
    }
    
    private func setup(){
        guard let apiKey = apiKey else { return }
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }
    
    //sets up the mapview and its delegate
    func setupMapview(mapView:GMSMapView){
        mapView.delegate = self
    }
    
    //fetch the nearby places of the user depending on the user location and keywords passed
    func fetchPlaces(location: CLLocationCoordinate2D,
                     radius: Int,
                     keyWord: String,
                     completion : @escaping (([Results]) -> ())) {
        guard let apiKey = apiKey else { return }
        
        let urlString = networkManager.generateURL(.nearby(apiKey,
                                                           "\(location.latitude)",
                                                           "\(location.longitude)",
                                                           keyWord,
                                                           "\(radius)"))
        guard let url = URL(string: urlString) else { return  }

        networkManager.getData(url: url, to: Restaurants.self) { results in
            switch results {
            case .success(let restaurants):
                completion(restaurants.results)
            case .failure(_):
                completion([Results]())
            }
        }
    }
    
    //gets the current address of the user
    func getAddress(location : CLLocationCoordinate2D, completion : @escaping ((Result<String, Error>) -> ())){
        let gsmGeocoding = GMSGeocoder()
        gsmGeocoding.reverseGeocodeCoordinate(location) { addressResponse, error in
            guard let address = addressResponse?.firstResult() else {
                completion(.failure(error!))
                return
                
            }
            completion(.success(self.addressToString(address: address)))
        }
    }
    
    
    func addressToString(address: GMSAddress) -> String {
        guard let address = address.thoroughfare else { return ""}
        return "\(address)"
    }
}

extension GoogleAPIManager : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didTapOnMarker?(marker)
        return true
    }
}
