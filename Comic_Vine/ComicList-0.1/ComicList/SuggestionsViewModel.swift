//
//  SuggestionsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 08/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking
import RxSwift

final class SuggestionsViewModel {

	/// The search query
	let query = Variable("")
    
    private let webClient = WebClient()

	/// The search suggestions
	private(set) lazy var suggestions: Observable<[String]> = self.query.asObservable()
        // Se filtran las peticiones para que no se realicen peticiones al API mientas el tamaño de query sea menor a 2
        .filter { $0.characters.count > 2 }
        // Se retrasa la petición un tiempo para que no se realice en el momento
        .throttle(0.3, scheduler: MainScheduler.instance)
        // Se coge el último cambio, descarta el anterior y además cancela la suscripción del anterior
        .flatMapLatest { query -> Observable<Response<Volume>> in
            let r = Volume.titles(with: query)
            return self.webClient.load(resource: r)
        }
        .map { response -> [String] in
            return response.results
                .map { $0.title }
        }
        // Se indica que se ejecute en el thread (hilo) principal
        .observeOn(MainScheduler.instance)
}
