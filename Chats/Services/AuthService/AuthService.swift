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
	 var isVerified: Bool { get }
	 var shouldRegister: Bool { get set }


	 func verify(phoneNumber: String) async throws
	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws
	 func register(_ user: User) async throws
}


final class AuthService: AuthenticationProtocol, ObservableObject {

	 enum AuthState {
		  case authentication, registration, authenticated
	 }

	 @Published var authState: AuthState = .authentication

	 let networkingService: NetworkProtocol
	 let apiService: APIService

	 @Published var verificationCode: Int?
	 @Published var phoneNumber: String?  

	 @Published var authData: AuthData?
	 @Published var user: User?

	 @Published private (set) var isVerified = false
	 @Published var shouldRegister = false

	 
	 init(networkingService: NetworkProtocol, apiService: APIService) {
		  self.networkingService = networkingService
		  self.apiService = apiService
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
				throw ErrorMessage.badRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let decoded: VerificationCode = DataDecoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 await MainActor.run {
						  if decoded.isSuccess {
								isVerified = true
						  }
					 }

				case .failure(let failure):
					 throw failure
		  }
	 }


	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws {
		  await MainActor.run {
				self.phoneNumber = phoneNumber
		  }
		  
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
				throw ErrorMessage.badRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = DataDecoder.decode(data) else {
						  throw ErrorMessage.decodingError
					 }

					 print(authData)
					 await MainActor.run {
						  if let isUserExist = authData.isUserExists {
								if isUserExist == true {
									 handleAuthData(authData)
								} else {
									 authState = .registration
								}
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
				throw ErrorMessage.badRequest
		  }

		  let result = await networkingService.downloadDataResult(for: request)

		  switch result {
				case .success(let data):
					 guard let authData: AuthData = DataDecoder.decode(data) else {
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
		  authState = .authenticated
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


	 func getUserData() async throws -> User {

		  guard let phoneNumber else {
				throw ErrorMessage.phoneNumberMissing
		  }

		  if let savedUser = PersistenceService.fetchUser(by: phoneNumber) {
				return savedUser
		  } else {
				let fetchedUser = try await apiService.getUserData()

				try PersistenceService.save(user: fetchedUser)
				return fetchedUser
		  }
	 }
}
