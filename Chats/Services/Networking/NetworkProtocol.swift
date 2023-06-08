//
//  NetworkProtocol.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

protocol NetworkProtocol: AnyObject {

	 func downloadDataResult(for request: URLRequest) async -> Result<Data, Error>
}


extension NetworkProtocol {

	 /// Check if URLResponse have good status code, if it's not, it will throw an error
	 /// - Parameter response: URLResponse from dataTask
	 func handleResponse(_ response: URLResponse, content: Data) throws -> Data {

		  guard let response = response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
		  }

		  let statusCode = response.statusCode

		  if statusCode >= 200 && statusCode <= 300 {
				return content
		  } else {
				switch statusCode {
					 case 401:
						  throw try JSONDecoder().decode(UnauthorisedError.self, from: content)
					 case 404:
						  throw try JSONDecoder().decode(NotFoundError.self, from: content)
					 case 422:
						  throw try JSONDecoder().decode(ValidationError.self, from: content)

					 default:
						  throw ServerError(code: statusCode)
				}
		  }
	 }
}
