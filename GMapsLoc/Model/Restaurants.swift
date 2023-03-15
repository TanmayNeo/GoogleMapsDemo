//
//  Restaurants.swift
//  GMapsLoc
//
//  Created by apple on 10/03/23.
//

import Foundation

// MARK: - Welcome
struct Restaurants: Codable {
    let htmlAttributions: [String]
    let nextPageToken: String
    let results: [Results]
    let status: String

    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case nextPageToken = "next_page_token"
        case results, status
    }
}

// MARK: - Result
struct Results: Codable {
    let businessStatus: BusinessStatus
    let geometry: Geometry
    let icon: String
    let iconBackgroundColor: IconBackgroundColor
    let iconMaskBaseURI: String
    let name: String
    let photos: [Photo]?
    let placeID: String
    let plusCode: PlusCode
    let priceLevel: Int?
    let rating: Double
    let reference: String
    let scope: Scope
    let types: [String]
    let userRatingsTotal: Int
    let vicinity: String
    let openingHours: OpeningHours?
    let permanentlyClosed: Bool?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name, photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case priceLevel = "price_level"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
        case openingHours = "opening_hours"
        case permanentlyClosed = "permanently_closed"
    }
}

enum BusinessStatus: String, Codable {
    case closedTemporarily = "CLOSED_TEMPORARILY"
    case operational = "OPERATIONAL"
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location
}

enum IconBackgroundColor: String, Codable {
    case ff9E67 = "#FF9E67"
    case the909Ce1 = "#909CE1"
}

// MARK: - OpeningHours
struct OpeningHours: Codable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

enum Scope: String, Codable {
    case google = "GOOGLE"
}
