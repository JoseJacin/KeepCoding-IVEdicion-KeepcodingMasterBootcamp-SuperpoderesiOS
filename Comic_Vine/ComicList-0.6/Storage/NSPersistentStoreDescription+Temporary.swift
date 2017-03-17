//
//  NSPersistentStoreDescription+Temporary.swift
//  ComicList
//
//  Created by Guille Gonzalez on 10/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentStoreDescription {

	internal static func temporary() -> NSPersistentStoreDescription {
		let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
			.appendingPathComponent(UUID().uuidString)
		return NSPersistentStoreDescription(url: temporaryURL)
	}
}
