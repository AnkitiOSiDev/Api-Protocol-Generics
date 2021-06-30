//
//  News.swift
//  ApiCall
//
//  Created by Ankit on 30/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

struct TopNews: Decodable {
    let value : [News]
}

struct News : Decodable,Hashable{
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}


struct Company: Decodable {
    let name : String
}
