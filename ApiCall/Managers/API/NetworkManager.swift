//
//  ApiManager.swift
//  ApiCall
//
//  Created by Ankit on 12/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class NetWordManager:ApiCallerProtocol {
    static let manager = NetWordManager()
    private init(){
    }
    func getData<T>(resourse: T, completion: @escaping responseHandler<T.ModelType>) where T : APIResourse {
        let apiRequest = APIRequest(resourse: resourse)
        apiRequest.execute(withCompletion:completion)
    }
}


protocol ApiCallerProtocol {
    func getData<T:APIResourse>(resourse:T,completion: @escaping responseHandler<T.ModelType>)
}

