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
    let identifier: Int64
    let title: String
    let coverURL: URL?
    let description: String?
}

// Esto es lo mismo pero sin usar genéricos
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
        identifier = (try? unpack(from: jsonDictionary, key: "id")) ?? 0
        title = try unpack(from: jsonDictionary, key: "name")
        coverURL = try? unpack(from: jsonDictionary, keyPath: "image.small_url")
        description = try? unpack(from: jsonDictionary, key: "description")
    }
}

extension Volume {
    // Función estática que retorna el título para recuperar los títulos
    public static func titles(with query: String) -> Resource<Response<Volume>> {
        return Resource(
            comicVinePath: "search",
            parameters: [
                "api_key" : apiKey,
                "format" : "json",
                "field_list" : "name",
                "limit" : "10",
                "page" : "1",
                "query" : query,
                "resources" : "volume"
            ]
        )
    }
    
    // Función estática que retorna el título para recuperar los títulos pero con paginación además de retornar más campos
    public static func search(with query: String, page: Int) -> Resource<Response<Volume>> {
        return Resource(
            comicVinePath: "search",
            parameters: [
                "api_key" : apiKey,
                "format" : "json",
                "field_list" : "id,image,name",
                "limit" : "20",
                "page" : String(page),
                "query" : query,
                "resources" : "volume"
            ]
        )
    }
}
