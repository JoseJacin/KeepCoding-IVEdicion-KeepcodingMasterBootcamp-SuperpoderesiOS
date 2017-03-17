//
//  VolumeViewModel+ManagedObjectDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Storage

extension VolumeViewModel: ManagedObjectDecodable {

	init(managedObject: Volume) {
		identifier = managedObject.identifier
		title = managedObject.title ?? "Untitled"
		coverURL = managedObject.coverURL.flatMap { URL(string: $0) }
		publisherName = managedObject.publisher
	}
}
