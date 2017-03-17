//
//  VolumeListViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 07/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Storage

/// A view model for the user's comic list.
final class VolumeListViewModel {

	/// Called when volumes are inserted or removed
	var didUpdate: () -> Void = {}

	/// The number of volumes in the list
	var numberOfVolumes: Int {
		return results.count
	}

	/// Returns the volume at a given position
	func item(at position: Int) -> VolumeViewModel {
		return results.value(at: position)
	}

	private let results: FetchedResults<VolumeViewModel>

	init(store: DataStore) {
		results = try! store.fetchedResults(VolumeViewModel.self, matching: .all)
		results.didChangeContent = { [weak self] in
			self?.didUpdate()
		}
	}
}
