//
//  Volume+ManagedObjectEncodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import ComicVine
import Storage

extension ComicVine.Volume: ManagedObjectEncodable {

	public func managedObject(inContext context: WriteContext) -> Storage.Volume {
		let volume = Volume(writeContext: context)

		volume.identifier = identifier
		volume.title = title
		volume.coverURL = coverURL?.absoluteString
		volume.publisher = publisherName

		volume.insertionDate = NSDate()

		return volume
	}
}
