 
 //
//  AppDelegate.swift
//  ComicList
//
//  Created by Guille Gonzalez on 06/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import UIKit
import Networking
import RxSwift
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var coordinator: AppCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        testResources()
        
		let window = UIWindow(frame: UIScreen.main.bounds)

		coordinator = AppCoordinator(window: window)
		coordinator?.start()

		return true
	}
}

 func testResources() {
    let client = WebClient()
    let resource = Volume.titles(with: "Bat")
    
    client.load(resource: resource)
        .map {
            return $0.results.map { $0.title }
        }.subscribe(onNext: { titles in
            print(titles)
        })
 }
