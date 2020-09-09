//
//  RequestManager.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 08.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case badURL
    case noData
}

final class RequestManager {
    
    func requestCategories(completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
        guard let url = URL(string: urlString) else { completionHandler(.failure(.badURL)); return }
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { completionHandler(.failure(.noData)); return }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
    
    func requestCategory(categoryName name: String, completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(name)"
        guard let url = URL(string: urlString.removeSpacesInURL()) else { completionHandler(.failure(.badURL)); return }
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { completionHandler(.failure(.noData)); return }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
    
    func requestImage(urlString: String, completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        guard let url = URL(string: urlString) else { completionHandler(.failure(.badURL)); return }
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { completionHandler(.failure(.noData)); return }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
    
}
