//
//  SearchResultsCoordinator.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import UIKit
import Storage

/// Coordinates the presentation of the search results
final class SearchResultsCoordinator: Coordinator {

	private let query: String
	private let store: DataStore
	private unowned let navigationController: UINavigationController

	init(query: String, store: DataStore, navigationController: UINavigationController) {
		self.query = query
		self.store = store
		self.navigationController = navigationController
	}

	override func start() {
		let viewModel = SearchResultsViewModel(query: query)
		let viewController = SearchResultsViewController(viewModel: viewModel)

		// Present the detail when a volume is selected in the search results
		viewController.didSelectVolume = { [weak self] volume in
			self?.presentDetail(for: volume)
		}

		viewController.didFinish = { [weak self] in
			// This will remove the coordinator from its parent
			self?.done()
		}

		navigationController.pushViewController(viewController, animated: true)
	}

	private func presentDetail(for volume: VolumeViewModel) {
		let coordinator = VolumeDetailCoordinator(volume: volume, store: store, navigationController: navigationController)
		add(child: coordinator)

		coordinator.start()
	}
}
