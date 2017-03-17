//
//  Service+Suggestions.swift
//  ComicList
//
//  Created by Guille Gonzalez on 10/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

import ComicVine

extension Service {

	func suggestions(withQuery query: String) -> Observable<[String]> {
		return results(for: Volume.titles(withQuery: query))
			.map { volumes in
				// Convert suggestions into titles, removing any duplicates
				var titles: [String] = []

				for volume in volumes where !titles.contains(volume.title) {
					titles.append(volume.title)
				}

				return titles
			}
	}
}
