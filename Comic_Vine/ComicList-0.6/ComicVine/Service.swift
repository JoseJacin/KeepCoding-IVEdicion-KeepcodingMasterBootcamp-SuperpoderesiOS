//
//  Service.swift
//  ComicList
//
//  Created by Guille Gonzalez on 09/02/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

import Networking

public enum ServiceError: Error {
	case badStatus(Int, String)
}

/// ComicVine service.
public final class Service {

	private let client: WebClient

	public init(configuration: Configuration = Configuration.default) {
		client = WebClient(defaultParameters: [
			"format": configuration.format,
			"api_key": configuration.apiKey
		])
	}

	public func results<M: JSONDecodable>(for resource: Resource<Response<M>>) -> Observable<[M]> {
		return response(for: resource).map { response in
			guard response.succeeded else {
				throw ServiceError.badStatus(response.status, response.message)
			}

			return response.results
		}
	}

	private func response<M: JSONDecodable>(for resource: Resource<Response<M>>) -> Observable<Response<M>> {
		return client.load(resource: resource)
	}
}
