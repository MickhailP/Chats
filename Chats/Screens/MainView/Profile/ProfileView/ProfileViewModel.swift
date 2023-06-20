//
//  ProfileViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 18.06.2023.
//

import Foundation

final class ProfileViewModel: ObservableObject {

	 let authService: AuthService

	 @Published var isLoading = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 init(authService: AuthService) {
		  self.authService = authService
	 }


	 func refreshUserData() {
		  isLoading = true

		  Task {

				defer {
					 Task {
						  await MainActor.run {
								isLoading = false
						  }
					 }
				}

				do {
					 let user = try await authService.getUserData()
					 try saveToUserDefaults(user)

					 await MainActor.run {
						  authService.user = user
					 }
				} catch let error as ErrorMessage {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.rawValue
					 }
				} catch {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.localizedDescription
					 }
				}
		  }
	 }

	 func getZodiacSignAndName(from birthday: String?) -> String?{

		  if let birthday,
			  let date = birthday.convertFromDashedDate(),
			  let sign = ZodiacAPI.getZodiacSign(for: date) {

				let signAndName = "\(sign.rawValue) \(sign.zodiacName)"
				return signAndName
		  }
		  return nil
	 }

	 private func saveToUserDefaults(_ user: User) throws {
		  try PersistenceService.save(user: user)
	 }
}
