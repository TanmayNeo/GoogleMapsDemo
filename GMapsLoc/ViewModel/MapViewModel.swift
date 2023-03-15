//
//  MapViewModel.swift
//  GMapsLoc
//
//  Created by apple on 10/03/23.
//

import Foundation
import CoreLocation

class MapViewModel{
    var googleAPIManager = GoogleAPIManager.shared
    let networkManager = NetworkManager.shared
    private var userAddress : String?
    private let radius = 1000
    private let restaurants = "restaurants"
    
    //func to fetch nearby restaurants locations
    func fetchNearbyRestaurants(coordinate : CLLocationCoordinate2D,
                                completion : @escaping (([Results]) -> ())){
        googleAPIManager.fetchPlaces(location: coordinate,
                                     radius: radius,
                                     keyWord: restaurants) { results in
            
            completion(results)
        }
    }
    
    //func to fetch user address
    func fetchUserAddress(location : CLLocationCoordinate2D) {
        googleAPIManager.getAddress(location: location) { result in
            switch result {
            case .success(let address) :
                self.userAddress = address
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    //return the user address
    func getUserAddress() -> String {
        guard let _userAddress = userAddress else { return ""}
        return _userAddress
        
    }
}
