//
//  FetchedResults.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import CoreData

/// An auto-updating collection of values returned from querying a data store.
public final class FetchedResults<T: ManagedObjectDecodable> {

	/// Called when the contents have changed
	public var didChangeContent: () -> Void {
		get { return delegateAdapter.didChangeContent }
		set { delegateAdapter.didChangeContent = newValue }
	}

	/// Returns the number of items in the collection
	public var count: Int {
		return resultsController.fetchedObjects?.count ?? 0
	}

	/// Returns the value at the specified index
	public func value(at index: Int) -> T {
		let indexPath = IndexPath(indexes: [0, index])
		let object = resultsController.object(at: indexPath)

		return T(managedObject: object)
	}

	private let delegateAdapter = FetchedResultsDelegateAdapter()
	private let resultsController: NSFetchedResultsController<T.ManagedObject>

	internal init(fetchRequest: NSFetchRequest<T.ManagedObject>, context: NSManagedObjectContext) throws {
		resultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		resultsController.delegate = delegateAdapter

		try resultsController.performFetch()
	}
}

private class FetchedResultsDelegateAdapter: NSObject, NSFetchedResultsControllerDelegate {

	var didChangeContent: () -> Void = {}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		didChangeContent()
	}
}
