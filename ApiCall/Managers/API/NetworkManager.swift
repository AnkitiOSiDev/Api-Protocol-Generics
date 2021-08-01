//
//  ApiManager.swift
//  ApiCall
//
//  Created by Ankit on 12/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class NetworkManager:ApiCallerProtocol {
    static let manager = NetworkManager()
    private init(){
    }
    func getData<T>(resourse: T, completion: @escaping NetworkCompletionHandler) where T : APIResourse {
        let apiRequest = APIRequest(resourse: resourse)
        apiRequest.execute(withCompletion:completion)
    }

}


protocol ApiCallerProtocol {
    func getData<T:APIResourse>(resourse:T,completion: @escaping NetworkCompletionHandler)
}

