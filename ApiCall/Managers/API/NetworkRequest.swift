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
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping responseHandler<ModelType>)
}

extension NetWorkRequest {
    func load(request: URLRequest?, completion: @escaping responseHandler<ModelType>) {
        guard let request = request else {
            return completion(.failure(ApiError.invalidRequest))
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error)  in
            if let error = error {
                return completion(.failure(error))
            }
            guard let data = data, let value = self.decode(data) else {
                return completion(.failure(ApiError.invalidResponse))
            }
            completion(.success(value))
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
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func execute(withCompletion completion: @escaping responseHandler<UIImage>) {
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
    func decode(_ data: Data) -> Resource.ModelType? {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(Resource.ModelType.self, from: data)
            return model
        } catch (let error) {
            print(error)
            return nil
        }
    }
    
    func execute(withCompletion completion: @escaping responseHandler<Resource.ModelType>) {
        load(request: resourse.request, completion: completion)
    }
}
