//
//  Configuration.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

/// ComicVine configuration.
public struct Configuration {

	/// The response format: "json" or "xml"
	public let format: String

	/// The API key
	public let apiKey: String

	public static let `default` = Configuration(
		format: "json",
		apiKey: "75d580a0593b7320727309feb6309f62def786cd"
	)
}
