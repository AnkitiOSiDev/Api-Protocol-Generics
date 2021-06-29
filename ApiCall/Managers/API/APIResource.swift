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
        return "https://" + API.baseURLDictionary
    }
    var methodPath: String {
        return "/define"
    }
    var parameters: [String : String]
    typealias ModelType = Words
}


struct WeatherForecastApiResoource: APIResourse {
   var basePath: String {
        return "https://" + API.baseURLWeather
    }
    
    var methodPath: String {
        return "/forecast.json"
    }
        
    var parameters: [String : String]
    
    var headers: [String : String]
    
    var httpMethod: HTTPMethod
    
    typealias ModelType = Weather
    
    
}


extension Data {
    func dataToJSON() -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
}
