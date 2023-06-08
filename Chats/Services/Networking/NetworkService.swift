//
//  NetworkingService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation
import UIKit

final class NetworkService: NetworkProtocol {

	 func downloadDataResult(for request: URLRequest) async -> Result<Data, Error> {
		  do {
				let (data, response) = try await URLSession.shared.data(for: request)
				let handledData = try handleResponse(response, content: data)
				return .success(handledData)
		  } catch {
				print("There was an error during data fetching! ", error.localizedDescription)
				return .failure(error)
		  }
	 }
}


