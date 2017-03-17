//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

import ComicVine
import Storage

final class SearchResultsViewModel {

	let query: String
	var didLoadPage: () -> Void = {}

	public var numberOfItems: Int {
		return results.count
	}

	public func item(at position: Int) -> VolumeViewModel {
		return results.value(at: position)
	}

	public func load(autoloadNextOn trigger: Observable<Void>) -> Observable<Int> {
		return doLoad(page: 1, autoloadNextOn: trigger)
	}

	private let service: Service
	private let store: DataStore
	private let results: FetchedResults<VolumeViewModel>

	init(query: String) {
		self.query = query

		service = Service()
		store = DataStore.temporary()
		results = try! store.fetchedResults(VolumeViewModel.self, matching: .all)

		results.didChangeContent = { [weak self] in
			self?.didLoadPage()
		}
	}

	private func doLoad(page pageNumber: Int, autoloadNextOn trigger: Observable<Void>) -> Observable<Int> {
		let store = self.store
		let resource = Volume.search(withQuery: query, page: pageNumber)

		return service.results(for: resource)
			.flatMap { volumes in
				return store.asyncWrite { context in
					context.add(volumes)
				}
			}
			.observeOn(MainScheduler.instance)
			.flatMap { [weak self] () -> Observable<Int> in
				guard let `self` = self else {
					return Observable.just(pageNumber)
				}

				return Observable.concat([
					Observable.just(pageNumber),
					Observable.never().takeUntil(trigger),
					self.doLoad(page: pageNumber + 1, autoloadNextOn: trigger)
				])
			}
	}
}
