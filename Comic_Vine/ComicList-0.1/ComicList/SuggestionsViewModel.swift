//
//  SuggestionsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 08/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

// FIXME: This is a fake implementation

final class SuggestionsViewModel {

	/// The search query
	let query = Variable("")

	/// The search suggestions
	private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
		.throttle(0.3, scheduler: MainScheduler.instance)
		.map {
			$0.characters.split(separator: " ").map { String($0) }
		}
}
