//
//  Volume+Search.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

extension Volume {

	public static func titles(withQuery query: String) -> Resource<Response<Volume>> {
		return Resource(
			comicVinePath: "search",
			parameters: [
				"field_list": "name",
				"limit": "10",
				"page": "1",
				"query": query,
				"resources": "volume"
			]
		)
	}

	public static func search(withQuery query: String, page: Int) -> Resource<Response<Volume>> {
		return Resource(
			comicVinePath: "search",
			parameters: [
				"field_list": "id,image,name,publisher",
				"limit": "20",
				"page": String(page),
				"query": query,
				"resources": "volume"
			]
		)
	}

	public static func detail(withIdentifier identifier: Int64) -> Resource<Response<Volume>> {
		return Resource(
			comicVinePath: "volume/4050-\(identifier)",
			parameters: [
				"field_list": "name,description"
			]
		)
	}
}
