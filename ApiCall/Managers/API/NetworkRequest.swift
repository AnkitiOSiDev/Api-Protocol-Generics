//
//  NetWorkRequest.swift
//  ApiCall
//
//  Created by Ankit on 09/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation
import UIKit


protocol NetWorkRequest {
    associatedtype ModelType
    func execute(withCompletion completion: @escaping responseHandler<ModelType>)
}

extension NetWorkRequest {
    func load(request: URLRequest?, completion: @escaping NetworkCompletionHandler) {
        guard let request = request else {
            return completion(.failure(ApiError.invalidRequest))
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error)  in
            if let error = error {
                return completion(.failure(error))
            }
            guard let data = data else {
                return completion(.failure(ApiError.invalidResponse))
            }
            completion(.success(data))
        }
        task.resume()
    }
}


class ImageRequest {
    let request : URLRequest?
    
    init(url: URL) {
        self.request = URLRequest(url:url)
    }
}

extension ImageRequest: NetWorkRequest {
    func execute(withCompletion completion: @escaping NetworkCompletionHandler) {
        load(request: request, completion: completion)
    }
}

class APIRequest<Resource: APIResourse> {
    let resourse : Resource
    init(resourse: Resource) {
        self.resourse = resourse
    }
}

extension APIRequest: NetWorkRequest {
    func execute(withCompletion completion: @escaping NetworkCompletionHandler) {
        load(request: resourse.request, completion: completion)
    }
}
