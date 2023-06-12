//
//  RegistrationViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import Foundation

final class RegistrationViewModel: ObservableObject {

	 let authService: AuthenticationProtocol

	 let phoneNumber: String
	 @Published var name = ""
	 @Published var username = ""

	 @Published var isRegistering = false

	 @MainActor @Published var showError = false
	 @MainActor @Published private(set) var errorMessage = ""


	 init(authService: AuthenticationProtocol, phoneNumber: String) {
		  self.authService = authService
		  self.phoneNumber = phoneNumber
	 }


	 func registerPressed() {
		  isRegistering = true

		  let user = User(phone: phoneNumber, name: name, username: username)

		  Task {
				do {
					 try await authService.register(user)
				}
				catch let error as ValidationError {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.detail[0].msg
					 }
				}
				catch let error as ErrorMessage {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.rawValue
					 }
				}
				catch {
					 await MainActor.run {
						  showError = true
						  errorMessage = ErrorMessage.unknown.rawValue
					 }
				}
				await MainActor.run {
					 isRegistering = false
				}
		  }
	 }
}
