//
//  Resource+ComicVine.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

private let apiURL = URL(string: "http://www.comicvine.com/api")!

extension Resource where M: JSONDecodable {

	internal init(comicVinePath path: String, parameters: [String: String]) {
		self.init(url: apiURL.appendingPathComponent(path), parameters: parameters)
	}
}
