//
//  NetworkManager.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/9/24.
//

import Foundation

class NetworkManager {
    
    
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknown))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
enum NetworkError: Error {
    case unknown
}
