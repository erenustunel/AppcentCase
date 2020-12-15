//
//  LoginResponse.swift
//  AppcentCase
//
//  Created by Eren Üstünel on 12.12.2020.
//

import Foundation
// MARK: - LocationElement
struct LocationElement: Codable {
    let distance: Int?
    let title: String?
    let locationType: LocationType?
    let woeid: Int?
    let lattLong: String?

    enum CodingKeys: String, CodingKey {
        case distance, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias Locations = [LocationElement]
