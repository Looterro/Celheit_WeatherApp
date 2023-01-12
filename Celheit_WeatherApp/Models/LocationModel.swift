//
//  LocationModel.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import Foundation

struct Location: Codable, Identifiable {
    let id: Int
    let lat, lon, displayName: String

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case lat, lon
        case displayName = "display_name"

    }
    
    //MARK: - Sample Data
    
    static var SampleLocations: [Location] = Bundle.main.decode(file: "testLocationJSON.json")
}
