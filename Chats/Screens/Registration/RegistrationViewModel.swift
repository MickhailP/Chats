//
//  RegistrationViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import Foundation
import Combine


final class RegistrationViewModel: ObservableObject {

	 let authService: AuthenticationProtocol

	 let phoneNumber: String?

	 @Published var name = ""
	 @Published var username = ""

	 @Published var isRegistering = false
	 @Published var isUsernameValid = false

	 @MainActor @Published var showError = false
	 @MainActor @Published private(set) var errorMessage = ""

	 var cancellables = Set<AnyCancellable>()


	 init(authService: AuthenticationProtocol, phoneNumber: String?) {
		  self.authService = authService
		  self.phoneNumber = phoneNumber
		  subscribeOnUsername()
	 }


	 func registerPressed() {
		  isRegistering = true

		  guard let phoneNumber else {
				return
		  }

		  let user = User(phone: phoneNumber, name: name, username: username)

		  Task {

				defer {
					 Task {
						  await MainActor.run {
								isRegistering = false
						  }
					 }
				}

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
		  }
	 }

	 private func subscribeOnUsername() {
		  $username
				.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
				.map { text -> Bool in
					 print(text.isValidUserName())

					 if text.isValidUserName() {
						  return true
					 } else {
						  return false
					 }
				}
				.sink(receiveValue: { [weak self] (isValid) in
					 self?.isUsernameValid = isValid
				})
				.store(in: &cancellables)
	 }
}
