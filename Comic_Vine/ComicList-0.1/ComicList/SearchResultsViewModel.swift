//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking
import RxSwift

//MARK: - Extensions
extension VolumeViewModel {
    init(volume: Volume) {
        identifier = volume.identifier
        title = volume.title
        coverURL = volume.coverURL
        publisherName = nil
    }
}

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

    // Búsqueda reactiva. Scroll infinito
	public func load(autoloadNextOn trigger: Observable<Void>) -> Observable<Int> {
		return doLoad(page: 1, nextPage: trigger)
	}

	private var items: [VolumeViewModel] = []
    private let webClient = WebClient()

	init(query: String) {
		self.query = query
	}

    // Carga la página solicitada y añade los resultados al array items
    // Retorna el número de página actual
	private func doLoad(page pageNumber: Int, nextPage trigger: Observable<Void>) -> Observable<Int> {
		// Se prepara el results (recurso)
        let r = Volume.search(with: query, page: pageNumber)
        // Se realiza la carga
        return webClient.load(resource: r)
            // Se extraen los resultados de la respuesta
            .map { response in
                return response.results.map(VolumeViewModel.init(volume:))
            }
            // Se cambia al thread (hilo) principal
            .observeOn(MainScheduler.instance)
            .do(onNext: { viewModels in
                self.items.append(contentsOf: viewModels)
                self.didLoadPage()
            })
            .flatMap { _ -> Observable<Int> in
                return Observable.concat([
                    Observable.just(pageNumber),
                    // Suscripción a una secuencia que nunca termina hasta que se genere un valor en la secuencia trigger
                    Observable.never().takeUntil(trigger),
                    // Resultado de cargar la siguiente página
                    self.doLoad(page: pageNumber + 1, nextPage: trigger)
                    ])
            }
        
        // Side effect
	}
}
