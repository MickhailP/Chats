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
	 
	 var user: User? { get set }
	 var phoneNumber: String? { get set }
	 var isVerified: Bool { get }

	 func verify(phoneNumber: String) async throws
	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws
	 func register(_ user: User) async throws
	 func getUserData() async throws -> User
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

	 
	 init(networkingService: NetworkProtocol, apiService: APIService) {
		  self.networkingService = networkingService
		  self.apiService = apiService
	 }


	 func verify(phoneNumber: String) async throws {

		  let result = await apiService.sendVerifyRequest(for: phoneNumber)

		  switch result {
				case .success(let verification):

					 await MainActor.run {
						  if verification.isSuccess {
								isVerified = true
						  }
					 }
				case .failure(let error):
					 throw error
		  }
	 }


	 func authoriseUser(phoneNumber: String, verificationCode: String) async throws {

		  await MainActor.run {
				self.phoneNumber = phoneNumber
		  }

		  let result = await apiService.sendAuthorisationRequest(for: phoneNumber, with: verificationCode)

		  switch result {
				case .success(let authData):

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

		  let result = await apiService.sendRegistrationRequest(for: user)

		  switch result {
		  case .success(let authData):
				await MainActor.run {
					 handleAuthData(authData)
				}
		  case .failure(let error):
				throw error
		  }
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

	 private func handleAuthData(_ data: AuthData) {
		  KeychainStorage.saveCredentials(data)
		  authData = data
		  authState = .authenticated
	 }
}
