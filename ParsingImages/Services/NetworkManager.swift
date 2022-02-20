//
//  NetworkManager.swift
//  ParsingImages
//
//  Created by Roman Zhukov on 19.02.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}


class NetworkManager {
    static let shared = NetworkManager()
    
    private let url = "https://api.unsplash.com/photos?per_page=30&client_id=j0jvFBCxGG342dl2oyuw497E6Eh7eMvCOQz8gu-U5Ow"
    
    private init() {}
    
    func fetchData(completion: @escaping(Result<[Image], NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let images = try JSONDecoder().decode([Image].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(images))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
