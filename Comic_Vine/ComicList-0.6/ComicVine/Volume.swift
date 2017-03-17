//
//  Volume.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

/// A ComicVine volume
public struct Volume {

	public let identifier: Int64
	public let title: String
	public let coverURL: URL?
	public let publisherName: String?
	public let description: String?
}
