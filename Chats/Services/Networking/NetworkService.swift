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
	 
	 
	 func fetchImage(from urlString: String) async -> UIImage? {
		  
		  guard let url = URL(string: urlString) else {
				return nil
		  }
		  
		  do {
				let (data, response) = try await URLSession.shared.data(from: url)
				try handleResponse(response)
				return UIImage(data: data)
				
		  } catch {
				print("There was an error! ", error.localizedDescription)
				return nil
		  }
	 }

	 func configureRequest(url: URL, httpMethod: String, token: String?, data: Data?) -> URLRequest {
		  var request = URLRequest(url: url)

		  request.httpMethod = httpMethod
		  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		  if let token {
				request.setValue(token, forHTTPHeaderField: "Authorization")
		  }

		  if let data {
				request.httpBody = data
		  }

		  return request
	 }
}


