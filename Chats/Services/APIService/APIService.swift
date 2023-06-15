//
//  APIService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 15.06.2023.
//

import Foundation


final class APIService {

	 let networkService: NetworkProtocol

	 var authData: AuthData? 


	 init(networkService: NetworkProtocol) {
		  self.networkService = networkService
	 }


	 func updateUserOnServer(user: UserUpdate) async throws {

		  do {
				let tokenIsValid = try checkAuthToken()

				guard let authData,
						let accessToken = authData.accessToken,
						let refreshToken = authData.refreshToken
				else {
					 throw ErrorMessage.authDataIsMissing
				}

				if tokenIsValid {
					 try await sendUpdateRequest(user: user, token: accessToken)
				} else {
					 try await refreshAccessToken(with: refreshToken) { authData in

						  guard let newToken = authData.accessToken else {
								throw ErrorMessage.tokenIsMissing
						  }

						  try await sendUpdateRequest(user: user, token: newToken)
					 }
				}

		  } catch {
				throw error
		  }
	 }


	 private func sendUpdateRequest(user: UserUpdate, token: String) async throws {

		  guard let url = Endpoint.userInfo.url else {
				throw ErrorMessage.badURl
		  }

		  guard let uploadData = DataDecoder().convertObjectToJSON(user) else {
				throw ErrorMessage.encodingError
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "PUT", token: token, data: uploadData)

		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success:
					 saveUser()

				case .failure(let error):
					 throw error
		  }
	 }


	 private func checkAuthToken() throws -> Bool {

		  do {
				let authData = try KeychainStorage.getCredentials()

				let currentDate = Date.now
				let expirationDate = currentDate.addingTimeInterval(600)

				if currentDate < expirationDate {
					 self.authData = authData
					 return true
				} else  {
					 return false
				}
		  } catch {
				throw error
		  }
	 }


	 private func refreshAccessToken(with refreshToken: String, completion: ((AuthData) async throws -> Void)) async throws {

		  guard let url = Endpoint.userInfo.url else {
				throw ErrorMessage.badURl
		  }

		  let json = """
			 {
			 "refresh_token": "\(refreshToken)"
			 }
			 """

		  guard let uploadData = json.data(using: .utf8) else {
				throw ErrorMessage.encodingError
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "POST", token: refreshToken, data: uploadData)

		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):

					 guard let authData: AuthData = DataDecoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 KeychainStorage.saveCredentials(authData)

					 try await completion(authData)

				case .failure(let error):
					 throw error
		  }
	 }


	 private func saveUser() {

	 }
}
