//
//  Response.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

public struct Response<M: JSONDecodable> {

	public let status: Int
	public let message: String
	public let results: [M]

	public var succeeded: Bool {
		return status == 1
	}
}

extension Response: JSONDecodable {

	public init(jsonDictionary: JSONDictionary) throws {
		guard
			let status = jsonDictionary["status_code"] as? Int,
			let message = jsonDictionary["error"] as? String,
			let payload = jsonDictionary["results"] else {
				throw JSONError.unsupportedType
		}

		var results: [M] = []

		switch payload {
		case let dictionary as JSONDictionary:
			results = try [decode(jsonDictionary: dictionary)]
		case let array as JSONArray:
			results = try decode(jsonArray: array)
		default:
			throw JSONError.unsupportedType
		}

		self.status = status
		self.message = message
		self.results = results
	}
}
