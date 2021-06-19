//
//  Constants.swift
//  ApiCall
//
//  Created by Ankit on 15/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

enum HTTPMethod {
    case GET
    case POST
    
    var type : String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

enum Result<T,U> {
    case success(T)
    case failure(U)
}

typealias responseHandler<T> = (Result<T,Error>) -> Void

enum ApiError : Error {
    case invalidRequest
    case invalidStautsCode
    case invalidResponse
}

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value(for key: String) throws -> String {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let string as String:
            return string
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var apiKey: String {
        do {
           let value: String = try Configuration.value(for: "API_KEY")
           return value
        } catch (let error) {
           fatalError(error.localizedDescription)
        }
    }
    
    static var baseURL: String {
         do {
                  let value: String = try Configuration.value(for: "API_BASE_URL")
                  return value
            } catch (let error) {
                  fatalError(error.localizedDescription)
            }
    }
}
