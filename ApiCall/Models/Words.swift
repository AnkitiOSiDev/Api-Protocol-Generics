//
//  Words.swift
//  ApiCall
//
//  Created by Ankit on 16/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

struct Words: Decodable {
    let list : [Word]
}

struct Word : Decodable,Hashable {
    let definition : String
    let example: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(definition)
    }
}
