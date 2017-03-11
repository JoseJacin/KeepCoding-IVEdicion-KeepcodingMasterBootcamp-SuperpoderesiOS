//
//  AppCoordinator.swift
//  ComicList
//
//  Created by Guille Gonzalez on 07/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import UIKit

// El patrón de composición es muy sencillo
// Padre - Hijo
final class AppCoordinator: Coordinator {

	private let window: UIWindow
    // Se crea una instancia del NavigationController
	private let navigationController = UINavigationController()

	init(window: UIWindow) {
        // Se le pasa el elemento principal de la aplicación
		self.window = window
	}

	override func start() {
		customizeAppearance()

		window.rootViewController = navigationController

		// The volume list is the initial screen.
        // Prepara la pantalla inicial. 
        
        //Volume = Comic
        // Se crea un coordinator del tipo VolumeListCoordinator y se le inyecta el NavigationController navigationController
		let coordinator = VolumeListCoordinator(navigationController: navigationController)

        // Al coordinator padre se le añade el coordinator hijo que se acaba de crear
		add(child: coordinator)
        // Se presenta la pantalla principal
		coordinator.start()

		window.makeKeyAndVisible()
	}

	private func customizeAppearance() {
		let navigationBarAppearance = UINavigationBar.appearance()
		let barTintColor = UIColor(named: .bar)

		navigationBarAppearance.barStyle = .black // This will make the status bar white by default
		navigationBarAppearance.barTintColor = barTintColor
		navigationBarAppearance.tintColor = UIColor.white
		navigationBarAppearance.titleTextAttributes = [
			NSForegroundColorAttributeName: UIColor.white
		]
	}
}
