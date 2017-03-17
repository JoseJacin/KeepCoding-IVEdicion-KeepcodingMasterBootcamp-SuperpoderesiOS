//
//  ManagedObjectDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

/// A type whose instances can be constructed using a managed object.
public protocol ManagedObjectDecodable {

	associatedtype ManagedObject: NSManagedObject

	init(managedObject: ManagedObject)
}
