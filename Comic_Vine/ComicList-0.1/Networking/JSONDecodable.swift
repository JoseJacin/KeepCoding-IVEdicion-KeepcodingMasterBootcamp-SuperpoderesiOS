//
//  JSONDecodable.swift
//  ComicList
//
//  Created by Jose Sanchez Rodriguez on 11/3/17.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

// Método que decodifica un JSON al tipo indicado por el genérico T

//MARK: - Aliases
public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

//MARK: - Enums
public enum JSONError: Error {
    case invalidData
    case notFound(String)
    case invalidValue(Any, String)
}

//MARK: - Protocols
public protocol JSONDecodable {
    init(jsonDictionary: JSONDictionary) throws
}

//MARK: - Functions
// Función genérica decode que recibe un JSONDictionary y retorna un T
public func decode<T: JSONDecodable>(jsonDictionary: JSONDictionary) throws -> T {
    return try T(jsonDictionary: jsonDictionary)
}

// Función genérica decode que recibe un Array y retorna un array de T
public func decode<T: JSONDecodable>(jsonArray: JSONArray) throws -> [T] {
    // Lo siguiente son distintas formas de hacer lo mismo
    // A cada elemento del array de le decodifica en jsonDictionary.
    return try jsonArray.map(decode(jsonDictionary: ))
    //return try jsonArray.map(T.init(jsonDictionary:))
    //return try jsonArray.map { try T(jsonDictionary: S0) }
}

// Función genérica decode que recibe un Data y retorna un T
public func decode<T: JSONDecodable>(data: Data) throws -> T {
    let object = try JSONSerialization.jsonObject(with: data, options: [])
    
    guard let dictionary = object as? JSONDictionary else {
        throw JSONError.invalidData
    }
    
    return try decode(jsonDictionary: dictionary)
}

// Función que desempaqueta un campo del Dictionary
public func unpack<T>(from jsonDictionary: JSONDictionary, key: String) throws -> T {
    guard let rawValue = jsonDictionary[key] else {
        throw JSONError.notFound(key)
    }
    
    guard let value = (rawValue as? T) else {
        throw JSONError.invalidValue(rawValue, key)
    }
    
    return value
}

// Función que desempaqueta el valor de una clave que se encuentra en un JSONDuctionary y retorna T
public func decode<T: JSONDecodable>(from jsonDictionary : JSONDictionary, key: String) throws -> T {
    let rawValue: JSONDictionary = try unpack(from: jsonDictionary, key: key)
    return try decode(jsonDictionary: rawValue)
}

// Función que desempaqueta el valor de una clave que se encuentra en un JSONDuctionary y retorna un array de T
public func decode<T: JSONDecodable>(from jsonDictionary : JSONDictionary, key: String) throws -> [T] {
    let rawValues: JSONArray = try unpack(from: jsonDictionary, key: key)
    return try decode(jsonArray: rawValues)
}
