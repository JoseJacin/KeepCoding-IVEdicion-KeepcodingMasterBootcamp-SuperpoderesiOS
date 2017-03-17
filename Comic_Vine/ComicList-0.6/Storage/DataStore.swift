//
//  DataStore.swift
//  ComicList
//
//  Created by Guille Gonzalez on 11/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

public final class DataStore {

	public static func temporary() -> DataStore {
		let container = NSPersistentContainer(name: "tmp", managedObjectModel: mergedModel())
		container.persistentStoreDescriptions = [.temporary()]

		return DataStore(container: container)
	}

	public convenience init(name: String) {
		let container = NSPersistentContainer(name: name, managedObjectModel: mergedModel())
		self.init(container: container)
	}

	public func write(_ block: (WriteContext) throws -> Void) throws {
		precondition(Thread.isMainThread)

		let context = container.viewContext

		try block(WriteContext(context))
		try context.save()
	}

	public func asyncWrite(_ block: @escaping (WriteContext) throws -> Void) -> Observable<Void> {
		let container = self.container

		return Observable.create { observer in
			container.performBackgroundTask { context in
				do {
					try block(WriteContext(context))
					try context.save()

					observer.onNext()
					observer.onCompleted()
				} catch {
					observer.onError(error)
				}
			}

			return Disposables.create()
		}
	}

	public func fetchedResults<T: ManagedObjectDecodable>(_ type: T.Type, matching query: T.ManagedObject.Query) throws -> FetchedResults<T> where T.ManagedObject: ManagedObjectType {
		precondition(Thread.isMainThread)

		let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: T.ManagedObject.entityName)
		fetchRequest.predicate = query.predicate
		fetchRequest.sortDescriptors = query.sortDescriptors

		return try FetchedResults(fetchRequest: fetchRequest, context: container.viewContext)
	}

	public func contains<T: NSManagedObject>(_ type: T.Type, withIdentifier identifier: Int64) -> Bool where T: ManagedObjectType {
		precondition(Thread.isMainThread)

		let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
		fetchRequest.predicate = T.uniquingPredicate(withIdentifier: identifier)

		let count = (try? container.viewContext.count(for: fetchRequest)) ?? 0
		return count > 0
	}

	// MARK: - Private

	private let container: NSPersistentContainer

	private init(container: NSPersistentContainer) {
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Couldn't load the persistent store: \(error)")
			}
		}

		self.container = container
		self.container.viewContext.automaticallyMergesChangesFromParent = true
	}
}

private func mergedModel() -> NSManagedObjectModel {
	let bundle = Bundle(for: DataStore.self)
	guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else {
		fatalError("No models found!")
	}

	return model
}
