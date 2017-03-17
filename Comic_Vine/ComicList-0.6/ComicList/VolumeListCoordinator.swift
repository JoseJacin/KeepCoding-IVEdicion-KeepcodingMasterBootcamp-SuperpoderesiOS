//
//  VolumeListCoordinator.swift
//  ComicList
//
//  Created by Guille Gonzalez on 07/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import UIKit
import Storage

/// Coordinates all the navigation originating from the comic list screen
final class VolumeListCoordinator: Coordinator {

	init(store: DataStore, navigationController: UINavigationController) {
		self.store = store
		self.navigationController = navigationController
	}

	override func start() {
		let viewController = setupViewController()
		let suggestionsCoordinator = SuggestionsCoordinator(
			store: store,
			navigationItem: viewController.navigationItem,
			navigationController: navigationController
		)

		add(child: suggestionsCoordinator)
		suggestionsCoordinator.start()

		navigationController.pushViewController(viewController, animated: false)
	}

	// MARK: - Private

	private let store: DataStore
	private unowned let navigationController: UINavigationController

	private func setupViewController() -> UIViewController {
		let viewController = VolumeListViewController(viewModel: VolumeListViewModel(store: store))

		viewController.didSelectVolume = { [weak self] volume in
			self?.presentDetail(for: volume)
		}

		viewController.definesPresentationContext = true
		return viewController
	}

	private func presentDetail(for volume: VolumeViewModel) {
		let coordinator = VolumeDetailCoordinator(volume: volume, store: store, navigationController: navigationController)
		add(child: coordinator)

		coordinator.start()
	}
}
