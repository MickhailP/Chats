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
				try await checkAuthToken()

				guard let authData,
						let accessToken = authData.accessToken
				else {
					 throw ErrorMessage.authDataIsMissing
				}

				try await sendUpdateRequest(user: user, token: accessToken)

		  } catch {
				throw error
		  }
	 }


	 private func checkAuthToken() async throws {

		  do {
				let authData = try KeychainStorage.getCredentials()

				let currentDate = Date.now
				guard let expirationDate = authData?.date.addingTimeInterval(600) else {
					 throw ErrorMessage.authDataIsMissing
				}

				if currentDate < expirationDate {
					 self.authData = authData
				} else {
					 if let refreshToken = authData?.refreshToken,
						 let accessToken = authData?.accessToken {

						  try await refreshAccessToken(with: refreshToken, accessToken: accessToken) { newAuthData in
								self.authData = newAuthData
						  }
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
					 break

				case .failure(let error):
					 throw error
		  }
	 }


	 private func refreshAccessToken(with refreshToken: String, accessToken: String, completion: ((AuthData) async throws -> Void)) async throws {

		  guard let url = Endpoint.refreshToken.url else {
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

		  let request = networkService.configureRequest(url: url, httpMethod: "POST", token: accessToken, data: uploadData)

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


	 func getUserData() async throws -> User {

		  try await checkAuthToken()

		  guard let url = Endpoint.userInfo.url else {
				throw ErrorMessage.badURl
		  }

		  guard let authData,
				  let accessToken = authData.accessToken
		  else {
				throw ErrorMessage.authDataIsMissing
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "GET", token: accessToken, data: nil)

		
		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):

					 guard let userResponse: UserResponse = DataDecoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }
					 let user = userResponse.profileData

					 print(userResponse)
					 return user

				case .failure(let error):
					 print(error)
					 throw error
		  }
	 }
}


//MARK: - Verification
extension APIService {

	 func sendVerifyRequest(for phoneNumber: String) async  -> Result<VerificationCode, Error> {

		  guard let url = Endpoint.sendAuthCode.url else {
				return .failure( ErrorMessage.badURl)
		  }

		  let json = """
			 {
			 "phone": "\(phoneNumber)"
			 }
			 """

		  guard let uploadData = json.data(using: .utf8) else {
				return .failure( ErrorMessage.encodingError)
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "POST", token: nil, data: uploadData)

		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let decoded: VerificationCode = DataDecoder.decode(data) else {
						  return .failure( ErrorMessage.decodingError)
					 }

					 return .success(decoded)

				case .failure(let error):
					 return .failure(error)
		  }
	 }
}


//MARK: - Authorisation
extension APIService {

	 func sendAuthorisationRequest(for phoneNumber: String, with verificationCode: String) async -> Result<AuthData, Error> {

		  guard let url = Endpoint.checkAuthCode.url else {
				return .failure( ErrorMessage.badURl)
		  }

		  let json = """
				{
				"phone": "\(phoneNumber)",
				"code": "\(verificationCode)"
				}
				"""

		  guard let uploadData = json.data(using: .utf8) else {
				return .failure( ErrorMessage.encodingError)
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "POST", token: nil, data: uploadData)

		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = DataDecoder.decode(data) else {
						  return .failure( ErrorMessage.decodingError)
					 }
					 return .success(authData)

				case .failure(let error):
					 return .failure(error)
		  }
	 }
}


//MARK: - Registration
extension APIService {

	 func sendRegistrationRequest(for user: User) async -> Result<AuthData, Error> {

		  guard let url = Endpoint.register.url else {
				return .failure( ErrorMessage.badURl)
		  }

		  let json = """
				{
				"phone": "\(user.phone)",
				"name": "\(user.name)",
				"username": "\(user.username)"
				}
				"""

		  guard let uploadData = json.data(using: .utf8) else {
				return .failure(ErrorMessage.encodingError)
		  }

		  let request = networkService.configureRequest(url: url, httpMethod: "POST", token: nil, data: uploadData)

		  let result = await networkService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = DataDecoder.decode(data) else {
						  return .failure(ErrorMessage.decodingError)
					 }
					 return .success(authData)

				case .failure(let error):
					 return .failure(error)
		  }
	 }
}
