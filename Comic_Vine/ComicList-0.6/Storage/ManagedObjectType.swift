//
//  ManagedObjectType.swift
//  ComicList
//
//  Created by Guille Gonzalez on 13/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

public protocol QueryDescription {

	var predicate: NSPredicate? { get }
	var sortDescriptors: [NSSortDescriptor] { get }
}

/// Our managed object subclasses must conform to this protocol
public protocol ManagedObjectType {

	/// A type that models queries for this managed object type
	associatedtype Query: QueryDescription

	/// The entity name for this managed object type
	static var entityName: String { get }

	/// Returns a uniquing predicate for this managed object type
	static func uniquingPredicate(withIdentifier: Int64) -> NSPredicate

	/// Creates the managed object using the provided write context
	init(writeContext: WriteContext)
}

extension ManagedObjectType where Self: NSManagedObject {

	public init(writeContext: WriteContext) {
		self.init(context: writeContext.managedObjectContext)
	}
}
