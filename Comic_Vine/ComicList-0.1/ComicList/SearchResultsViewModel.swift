//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

// FIXME: This is a fake implementation

final class SearchResultsViewModel {

	let query: String
	var didLoadPage: () -> Void = {}

	public var numberOfItems: Int {
		return items.count
	}

	public func item(at position: Int) -> VolumeViewModel {
		precondition(position < numberOfItems)
		return items[position]
	}

	public func load(autoloadNextOn trigger: Observable<Void>) -> Observable<Int> {
		return doLoad(page: 1, nextPage: trigger)
	}

	private var items: [VolumeViewModel] = []

	init(query: String) {
		self.query = query
	}

	private func doLoad(page current: Int, nextPage trigger: Observable<Void>) -> Observable<Int> {
		items.append(contentsOf: [
			VolumeViewModel(identifier: 38656,
			                title: "Doctor Strange: The Oath",
			                coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/1641291-ds__to.jpg"),
			                publisherName: "Marvel"),
			VolumeViewModel(identifier: 67079,
			                title: "Age Of Ultron",
			                coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/3816330-01.jpg"),
			                publisherName: "Marvel"),
			VolumeViewModel(identifier: 39255,
			                title: "Thanos Imperative",
			                coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/1704425-the_thanos_imperative_hc.jpg"),
			                publisherName: "Marvel")
			])
		didLoadPage()

		return Observable.just(1)
	}
}
