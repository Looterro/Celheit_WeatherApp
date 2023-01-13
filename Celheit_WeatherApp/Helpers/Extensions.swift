//
//  Extensions.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import Foundation
import SwiftUI

//Get the preview data stored in this file
extension Bundle {
    //reason for making it generic is that we want to pass any file to make it decodable
    func decode<T: Decodable>(file: String) -> T {
        
        //create url, if it is not there throw error
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the bundle!")
        }
        
        //get the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from the bundle")
        }
        
        let decoder = JSONDecoder()
        
        //take the json data and decode it
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from the bundle")
        }
        
        return loadedData
    }
}

// an extension on View Protocol that allows the modifier to be called .cardify
extension View {
    func cardify (isRefreshed: Bool) -> some View {
        self.modifier(Cardify(isRefreshed: isRefreshed))
    }
}
