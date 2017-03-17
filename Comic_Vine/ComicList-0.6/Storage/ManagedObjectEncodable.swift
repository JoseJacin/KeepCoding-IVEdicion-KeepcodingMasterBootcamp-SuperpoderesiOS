//
//  ManagedObjectEncodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 11/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

/// Represents a type that can be transformed into a managed object.
public protocol ManagedObjectEncodable {

	associatedtype ManagedObject: NSManagedObject

	func managedObject(inContext: WriteContext) -> ManagedObject
}
