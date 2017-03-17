//
//  Resource+JSONDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

extension Resource where M: JSONDecodable {

	public init(method: Method = .GET, url: URL, parameters: [String: String] = [:]) {
		self.init(method: method, url: url, parameters: parameters, decode: decode(data:))
	}
}
