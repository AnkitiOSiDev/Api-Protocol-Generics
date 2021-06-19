//
//  APIResource.swift
//  ApiCall
//
//  Created by Ankit on 16/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation


protocol APIResourse {
    var basePath:String {get}
    associatedtype ModelType : Decodable
    var methodPath : String {get}
    var filter: String? {get}
    var parameters: [String:String] {get}
    var headers: [String:String] {get}
    var httpMethod : HTTPMethod {get}
}

extension APIResourse {
    var request : URLRequest? {
        var components = URLComponents(string: basePath)
        components?.path = methodPath
        var queryItems = [URLQueryItem]()
        for (key,value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components?.queryItems =  queryItems
        guard let url = components?.url else {
           return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.type
        request.allHTTPHeaderFields = headers
        return request
    }
}


struct WordApiResourse: APIResourse {
    var headers: [String : String]
    var httpMethod: HTTPMethod
    var basePath: String {
        return "https://" + API.baseURL
    }
    var methodPath: String {
        return "/define"
    }
    var filter: String?
    var parameters: [String : String]
    typealias ModelType = Words
}
