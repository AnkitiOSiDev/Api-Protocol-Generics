//
//  ModuleManager.swift
//  ApiCall
//
//  Created by Ankit on 12/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class ModuleManager {
    static let manager = ModuleManager()
    private var netWordManager : NetWordManager
    private init(){
        netWordManager = NetWordManager.manager
    }
    
    func getWords(term:String,completion:@escaping responseHandler<Words>) {
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURL
        ]
        let resource = WordApiResourse(headers: headers, httpMethod: .GET, filter: nil, parameters: ["term":term])
        netWordManager.getData(resourse: resource, completion: completion)
    }
}

