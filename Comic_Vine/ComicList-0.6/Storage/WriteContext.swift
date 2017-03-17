//
//  WriteContext.swift
//  ComicList
//
//  Created by Guille Gonzalez on 11/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

public final class WriteContext {

	internal let managedObjectContext: NSManagedObjectContext

	internal init(_ context: NSManagedObjectContext) {
		managedObjectContext = context
	}

	public func add<T: ManagedObjectEncodable>(_ value: T) {
		let _ = value.managedObject(inContext: self)
	}

	public func add<T: Sequence>(_ values: T) where T.Iterator.Element: ManagedObjectEncodable {
		values.forEach { add($0) }
	}

	public func delete<T: NSManagedObject>(_ type: T.Type, withIdentifier identifier: Int64) throws where T: ManagedObjectType {
		let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
		fetchRequest.predicate = T.uniquingPredicate(withIdentifier: identifier)

		let objects = try managedObjectContext.fetch(fetchRequest)

		if objects.count > 0 {
			managedObjectContext.delete(objects[0])
		}
	}
}
