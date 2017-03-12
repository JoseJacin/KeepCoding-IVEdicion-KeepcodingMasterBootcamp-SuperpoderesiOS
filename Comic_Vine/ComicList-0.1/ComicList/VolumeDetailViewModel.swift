//
//  VolumeDetailViewModel.swift
//  ComicList
//
//  Created by Guille Gonzalez on 07/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking
import RxSwift

// FIXME: This is a fake implementation

final class VolumeDetailViewModel {

	/// Determines if the volume is saved in the user's comic list
	var isSaved: Observable<Bool> {
		return Observable.just(true)
	}

	/// The volume information
	private(set) var volume: VolumeViewModel

    private let webClient = WebClient()
    
	/// The volume description
	private(set) lazy var about: Observable<String?> = self.webClient
        .load(resource: Volume.detail(withIdentifier: self.volume.identifier))
        .map { $0.results[0].description }
        // Se eliminan las etiquetas de html de la descripción
        .map { description in
            return description?.replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression,
                range: nil
            )
        }
        // Catch en caso en que ocurra un error, pero además se pueden realizar cosas con el error
        //.catchError {
        //
        //}
        // Catch en caso en que ocurra un error
        .catchErrorJustReturn("Error de la pradera")
        // Cuando alguien se suscribe, retorna un observable con el valor que le hemos pasado por parámetro
        // En este caso lo que provoca es que la descripción se oculte mientras se descarga la descripción del volume
        .startWith(nil)
        // El observerOn y el sharedReplay se ejecutan si el Observer es del tipo Driver
        .observeOn(MainScheduler.instance)
        // Evita que se haga la petición 2 veces. El parámetro es el tamaño del buffer en el que se guardarán tantos elementos como valor tenga dicho parámetro
        .shareReplay(1)

	/// The issues for this volume
	private(set) var issues: Observable<[IssueViewModel]> = Observable.just([
		IssueViewModel(title: "Lorem fistrum", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg")),
		IssueViewModel(title: "Quietooor ahorarr", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/0/9116/1299822-296612.jpg")),
		IssueViewModel(title: "Apetecan", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/5/57845/1333458-cover.jpg")),
		IssueViewModel(title: "Rodrigor mamaar", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/5/56213/1386494-thanos_imperative__4.jpg")),
		IssueViewModel(title: "Benemeritaar", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1452486-thanos_imperative_5.jpg")),
		IssueViewModel(title: "Caballo blanco caballo negroorl", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1503818-thanos_imperative_6.jpg")),
		IssueViewModel(title: "Quietooor diodeno", coverURL: URL(string: "http://static.comicvine.com/uploads/scale_small/3/39027/4609736-4608485-cgxpqgqw0aao_8t+-+copy.jpg"))
	])

	/// Adds or removes the volume from the user's comic list
	func addOrRemove(){
		// TODO: implement
	}

	init(volume: VolumeViewModel) {
		self.volume = volume
	}
}
