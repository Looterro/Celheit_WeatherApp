//
//  ApiManager.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import Foundation

final class ApiManager {
    
    //in case url is thrown, write this enum to handle them directly
    private enum ApiError: Error {
        case invalidURL
    }
    
    func getData<T: Decodable>(url: String, model: T.Type, completion: @escaping(Result<T, Error>) -> ()) {
        
        //protect against url not being a proper url
        guard let url = URL(string: url) else {
            //completion listener returns failure with error
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        //decode the data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //check if that is not nil
            guard let data = data else {
                if let error = error { completion(.failure(error)) }
                return
            }
            
            //try decoding the code or catch the error. send a completion listener signal that data decoding was a success or not
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(serverData))
            } catch {
                completion(.failure(error))
            }
            
        }.resume() //RESUME THE SESSION AT THE END so it begins its work after initialization
        
    }
    
}
