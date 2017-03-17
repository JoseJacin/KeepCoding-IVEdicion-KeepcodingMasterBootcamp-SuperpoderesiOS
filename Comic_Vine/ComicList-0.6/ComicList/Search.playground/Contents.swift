//: Playground - noun: a place where people can play

import Foundation
import RxSwift
import PlaygroundSupport

import ComicVine

// Avoids sandbox error
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

// Executes indefinetly
PlaygroundPage.current.needsIndefiniteExecution = true

let disposeBag = DisposeBag()
let service = Service()

service.results(for: Volume.titles(withQuery: "batman"))
	.subscribe(onNext: {
		let volumes = $0
	})
	.addDisposableTo(disposeBag)

service.results(for: Volume.search(withQuery: "thanos", page: 1))
	.subscribe(onNext: {
		let volumes = $0
	})
	.addDisposableTo(disposeBag)
