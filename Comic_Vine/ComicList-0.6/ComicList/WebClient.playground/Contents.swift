//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import PlaygroundSupport

import Networking

// Avoids sandbox error
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

// Executes indefinetly
PlaygroundPage.current.needsIndefiniteExecution = true

let imageURL = URL(string: "http://cdn2.estamosrodando.com/biografias/8/7/chiquito-de-la-calzada-360533.jpg")!
let resource = Resource(url: imageURL) { UIImage(data: $0) }
let otherResource = resource.addingParameters(["foo": "bar"])

print(otherResource.request)

let client = WebClient()
let disposeBag = DisposeBag()

client.load(resource: resource)
	.subscribe(onNext: {
		let image = $0
	})
	.addDisposableTo(disposeBag)
