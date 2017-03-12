//
//  Resource+ComicVine.swift
//  ComicList
//
//  Created by Jose Sanchez Rodriguez on 12/3/17.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

//MARK: - Constants
let apiKey = "3d20dd7f4df221ae93596c0e3501b5e568b36b4f"
private let apiURL = URL(string: "http://comicvine.gamespot.com/api")!

//MARK: - Extensions
extension Resource where M: JSONDecodable {
    init(comicVinePath path: String, parameters: [String : String]) {
        self.init(url: apiURL.appendingPathComponent(path), parameters: parameters, decode: decode(data:))
    }
}
