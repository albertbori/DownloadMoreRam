//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Internet {
    func getResource(for url: URL, completion: @escaping (Result<Resource, Error>)->()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            var result: Result<Resource, Error> = .failure(RequestError.unknown)
            defer {
                completion(result)
            }
            guard error == nil else {
                result = .failure(error!)
                return
            }
            guard let data = data else {
                result = .failure(RequestError.noData)
                return
            }
            guard let mimeType = response?.mimeType else {
                result = .failure(RequestError.noMimeType)
                return
            }
            do {
                let resource = try Resource(url: url, mimeType: mimeType, data: data)
                result = .success(resource)
            } catch {
                result = .failure(error)
            }
        }
        task.resume()
    }
    
    enum RequestError: Error {
        case unknown
        case noData
        case noMimeType
    }
}
