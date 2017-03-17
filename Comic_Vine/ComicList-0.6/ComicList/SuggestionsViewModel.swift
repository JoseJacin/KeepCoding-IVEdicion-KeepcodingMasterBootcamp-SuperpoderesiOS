//
//  SuggestionsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 08/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

import ComicVine

final class SuggestionsViewModel {

	/// The search query
	let query = Variable("")

	/// The search suggestions
	private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
		.filter { query in
			// Ignore query strings with less than 3 characters
			query.characters.count > 2
		}
		// This will avoid making unnecessary requests if the user types too fast
		.throttle(0.3, scheduler: MainScheduler.instance)
		.flatMapLatest { query in
			// When the query string changes, any ongoing request will be cancelled
			// and a new request will be made with the new query.
			//
			// The results are flattened into the resulting Observer
			self.service.suggestions(withQuery: query)
		}
		// Make sure events are delivered in the main thread
		.observeOn(MainScheduler.instance)
		// Make sure multiple subscriptions share the side effects
		.shareReplay(1)

	private let service = Service()
}
