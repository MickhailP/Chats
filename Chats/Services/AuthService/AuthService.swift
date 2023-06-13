//
//  AuthService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation
import Combine


protocol AuthenticationProtocol: AnyObject {
	 var networkingService: NetworkProtocol { get }
	 var isAuthorized: Bool { get }
	 var shouldRegister: Bool { get set }

	 func verify(phoneNumber: String) async throws
	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws
	 func register(_ user: User) async throws
}


final class AuthService: AuthenticationProtocol, ObservableObject {

	 let networkingService: NetworkProtocol

	 @Published var verificationCode: Int?
	 @Published var isUserExist:Bool?

	 @Published var authData: AuthData?

	 @Published private (set) var isVerified = false
	 @Published private (set) var isAuthorized = false
	 @Published var shouldRegister = false

	 init(networkingService: NetworkProtocol) {
		  self.networkingService = networkingService
	 }


	 func verify(phoneNumber: String) async throws {

		  guard let url = Endpoint.sendAuthCode.url else {
				throw ErrorMessage.badURl
		  }

		  let json = """
		  {
		  "phone": "\(phoneNumber)"
		  }
		  """

		  guard let request = configureTokenFreeRequest(httpMethod: "POST", url: url, json: json) else {
				throw ErrorMessage.barRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let decoded: VerificationCode = Decoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 await MainActor.run {
						  if decoded.isSuccess {
								isVerified = true
						  } else {
								isVerified = false
						  }
					 }

				case .failure(let failure):
					 throw failure
		  }
	 }

	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws {
		  guard let url = Endpoint.checkAuthCode.url else {
				throw ErrorMessage.badURl
		  }

		  let json = """
				{
				"phone": "\(phoneNumber)",
				"code": "\(verificationCode)"
				}
				"""

		  guard let request = configureTokenFreeRequest(httpMethod: "POST", url: url, json: json) else {
				throw ErrorMessage.barRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = Decoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 await MainActor.run {
						  if let isUserExist = authData.isUserExists,
								isUserExist == true {
								handleAuthData(authData)
						  } else {
								shouldRegister = true
						  }
					 }
				case .failure(let error):
					 throw error
		  }
	 }


	 func register(_ user: User) async throws {
		  guard let url = Endpoint.register.url else {
				throw ErrorMessage.badURl
		  }

		  let json = """
				{
				"phone": "\(user.phone)",
				"name": "\(user.name)",
				"username": "\(user.username)"
				}
				"""

		  guard let request = configureTokenFreeRequest(httpMethod: "POST", url: url, json: json) else {
				throw ErrorMessage.barRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = Decoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 await MainActor.run {
						  handleAuthData(authData)
					 }
				case .failure(let error):
					 throw error
		  }
	 }


	 private func handleAuthData(_ data: AuthData) {
		  KeychainStorage.saveCredentials(data)
		  authData = data
		  isAuthorized = true
		  print(authData)
	 }


	 private func configureTokenFreeRequest(httpMethod: String, url: URL, json: String ) -> URLRequest? {

		  var request = URLRequest(url: url)
		  request.httpMethod = httpMethod
		  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		  if let uploadData = json.data(using: .utf8)  {
				request.httpBody = uploadData
				return request
		  }
		  return nil
	 }
}
