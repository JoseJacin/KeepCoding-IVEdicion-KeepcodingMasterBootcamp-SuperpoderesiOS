//
//  VolumeListCoordinator.swift
//  ComicList
//
//  Created by Guille Gonzalez on 07/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import UIKit

/// Coordinates all the navigation originating from the comic list screen
final class VolumeListCoordinator: Coordinator {

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	override func start() {
		let viewController = setupViewController()
        // Se crea otro coordinator que es el que se va a mostrar como la búsqueda de Cómics
		let suggestionsCoordinator = SuggestionsCoordinator(
			navigationItem: viewController.navigationItem,
			navigationController: navigationController
		)

        // Se añade el coordinator hijo al padre
		add(child: suggestionsCoordinator)
        // Se inicia el coordinator
		suggestionsCoordinator.start()

		navigationController.pushViewController(viewController, animated: false)
	}

	// MARK: - Private

	private unowned let navigationController: UINavigationController

	private func setupViewController() -> UIViewController {
        // Instancia el ViewController (del tipo VolumeListViewController), inyectándole como dependencia el ViewModel VolumeListViewModel
		let viewController = VolumeListViewController(viewModel: VolumeListViewModel())

        
		viewController.didSelectVolume = { [weak self] volume in
			self?.presentDetail(for: volume)
		}

		viewController.definesPresentationContext = true
		return viewController
	}

	private func presentDetail(for volume: VolumeViewModel) {
        // Le dice al coordinator de detalle de Volume VolumeDetailCoordinator que presente volume en el NavigationController navigationController
		let coordinator = VolumeDetailCoordinator(volume: volume, navigationController: navigationController)
        // Añade el coordinator al padre
		add(child: coordinator)
        // Lo muestra
		coordinator.start()
	}
}
