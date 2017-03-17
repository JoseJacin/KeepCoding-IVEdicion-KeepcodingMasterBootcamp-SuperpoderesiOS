//
//  JSONDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

/// JSON decoding error
///
/// - invalidData:     The raw data is not JSON
/// - unsupportedType: The provided type cannot be decoded from JSON
public enum JSONError: Error {
	case invalidData
	case unsupportedType
}

/// Implemented by types that can be decoded from JSON
public protocol JSONDecodable {
	init(jsonDictionary: JSONDictionary) throws
}

/// Decodes a JSON dictionary into a value.
///
/// - parameter jsonDictionary: A JSON dictionary.
///
/// - throws: A `JSONError` value.
///
/// - returns: A value decoded from the given JSON dictionary.
public func decode<T: JSONDecodable>(jsonDictionary: JSONDictionary) throws -> T {
	return try T(jsonDictionary: jsonDictionary)
}

/// Decodes a JSON array into an array of values.
///
/// - parameter jsonArray: A JSON array.
///
/// - throws: A `JSONError` value.
///
/// - returns: An array of values decoded from the given JSON array.
public func decode<T: JSONDecodable>(jsonArray: JSONArray) throws -> [T] {
	return try jsonArray.map(T.init(jsonDictionary:))
}

/// Decodes raw JSON data into a value.
///
/// - parameter data: Raw JSON data.
///
/// - throws: A `JSONError` value.
///
/// - returns: A value decoded from the given raw JSON data.
public func decode<T: JSONDecodable>(data: Data) throws -> T {
	guard
		let object = try? JSONSerialization.jsonObject(with: data, options: []),
		let dictionary = object as? JSONDictionary else {
			throw JSONError.invalidData
	}

	return try decode(jsonDictionary: dictionary)
}

/// Decodes raw JSON data into an array of values.
///
/// - parameter data: Raw JSON data.
///
/// - throws: A `JSONError` value.
///
/// - returns: An array of values decoded from the given raw JSON data.
public func decode<T: JSONDecodable>(data: Data) throws -> [T] {
	guard
		let object = try? JSONSerialization.jsonObject(with: data, options: []),
		let array = object as? JSONArray else {
			throw JSONError.invalidData
	}

	return try decode(jsonArray: array)
}
