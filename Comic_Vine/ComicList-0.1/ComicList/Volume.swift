//
//  Volume.swift
//  ComicList
//
//  Created by Jose Sanchez Rodriguez on 11/3/17.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

// Estructura de Volume (Comic)
struct Volume {
    let title: String
}

// Esto es lo mismo pero sin isar genéricos
//extension Volume: JSONDecodable {
//    init(jsonDictionary: JSONDictionary) throws {
//        guard let rawTitlte = jsonDictionary["name"] else {
//            throw JSONError.notFound("name")
//        }
//        
//        guard let title = (rawTitlte as? String) else {
//            throw JSONError.invalidValue(rawTitlte, "name")
//        }
//        
//        self.title = title
//    }
//}

extension Volume: JSONDecodable {
    init(jsonDictionary: JSONDictionary) throws {
        title = try unpack(from: jsonDictionary, key: "name")
    }
}

