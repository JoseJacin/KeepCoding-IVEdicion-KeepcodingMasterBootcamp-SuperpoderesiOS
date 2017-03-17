//
//  Volume+ManagedObjectType.swift
//  ComicList
//
//  Created by Guille Gonzalez on 13/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

extension Volume: ManagedObjectType {

	public enum Query: QueryDescription {
		case all

		public var predicate: NSPredicate? {
			return nil
		}

		public var sortDescriptors: [NSSortDescriptor] {
			return [NSSortDescriptor(key: "insertionDate", ascending: true)]
		}
	}

	public static let entityName = "Volume"

	public static func uniquingPredicate(withIdentifier identifier: Int64) -> NSPredicate {
		return NSPredicate(format: "identifier == %d", identifier)
	}
}
