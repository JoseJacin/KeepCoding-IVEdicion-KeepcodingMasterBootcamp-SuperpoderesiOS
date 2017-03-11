//
//  Response.swift
//  ComicList
//
//  Created by Jose Sanchez Rodriguez on 11/3/17.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

// Estructura de Response del API
struct Response<T: JSONDecodable> {
    let status: Int
    let message: String
    let results: [T]
}

extension Response: JSONDecodable {
    init(jsonDictionary: JSONDictionary) throws {
        // Si obligatoriamente se tiene que hacer unpack sobre una clave, se usa try, si es opcional, es decir, si no se hace unpack no pasa nada, se hace try?
        status = try unpack(from: jsonDictionary, key: "status_code")
        message = try unpack(from: jsonDictionary, key: "error")
        
        if let value: T = try? decode(from: jsonDictionary, key: "results") {
            results = [value]
        } else {
            results = try decode(from: jsonDictionary, key: "results")
        }
    }
}
