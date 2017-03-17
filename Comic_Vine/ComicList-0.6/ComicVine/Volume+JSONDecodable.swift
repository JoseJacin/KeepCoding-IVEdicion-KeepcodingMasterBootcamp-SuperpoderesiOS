//
//  Volume+JSONDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

extension Volume: JSONDecodable {

	public init(jsonDictionary: JSONDictionary) throws {
		guard let title = jsonDictionary["name"] as? String else {
			throw JSONError.unsupportedType
		}

		self.identifier = jsonDictionary["id"] as? Int64 ?? 0
		self.title = title
		self.coverURL = ((jsonDictionary as NSDictionary)
			.value(forKeyPath: "image.small_url") as? String)
			.flatMap { URL(string: $0) }
		self.publisherName = (jsonDictionary as NSDictionary)
			.value(forKeyPath: "publisher.name") as? String
		self.description = jsonDictionary["description"] as? String
	}
}
