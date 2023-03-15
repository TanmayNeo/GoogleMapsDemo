//
//  NetworkManager.swift
//  GMapsLoc
//
//  Created by apple on 10/03/23.
//

import Foundation
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=<string>&location=<string>
enum Paths {
    case nearby(String, String, String, String, String)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init (){  }
    
    //Func to generate complete url from the passed endpoint
    func generateURL(_ endPoint: Paths) -> String {
        let baseURL = "https://maps.googleapis.com/maps/api/place"
        switch endPoint {
        case .nearby(let apiKey, let lat, let long, let keyword, let radius) :
            let totalString = baseURL + "/nearbysearch/json?keyword=\(keyword)&location=\(lat),\(long)&key=\(apiKey)&radius=\(radius)"
            return  totalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? totalString
        }
    }
    
    //returnes generic data, from the webservice, of model type passed through the paramtre
    func getData < T : Codable > (url : URL,
                                  to: T.Type,
                                  completion : @escaping ((Result<T, Error>) -> ())){
        let session = URLSession.shared
        session.dataTask(with: url) {
            data, response, error in
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode(to, from: data)
                completion(.success(jsonData))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
