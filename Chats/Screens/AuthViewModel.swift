//
//  AuthViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


final class AuthViewModel: ObservableObject {

	 let authService: AuthenticationProtocol

	 @Published var countryNameAndFlag = "RU 🇷🇺"
	 @Published var countryMask = ""
	 @Published var phoneNumber = ""
	 @Published var verificationCode = "133337"


	 @Published private(set) var verificationRequested = false
	 @Published private(set) var isLoading = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 var formattedNumber: String? {
		  if let phoneNumber = Int(phoneNumber), let countryMask = Int(countryMask) {
				let phoneToRegister = "+" + "\(countryMask)" + "\(phoneNumber)"
				return phoneToRegister
		  } else {
				return nil
		  }
	 }

	 
	 init(authService: AuthenticationProtocol) {
		  self.authService = authService

		  if let regionCode = Locale.current.regionCode {
				countryNameAndFlag = regionCode
		  }
	 }

	 func requestVerificationCode(for number: String) {
		  isLoading = true
		  verificationRequested = true

		  guard let formattedNumber else {
				showError.toggle()
				errorMessage = "Phone number is empty!"
				isLoading = false
				return
		  }

		  Task {
				do {
					 try await authService.verify(phoneNumber: formattedNumber)
					 await MainActor.run {
						  isLoading = false
					 }
				} catch let error as ErrorMessage {
					 await MainActor.run {
						  showError.toggle()
						  errorMessage = error.rawValue
						  isLoading = false
					 }
				}
				catch let error as ValidationError {
					 await MainActor.run {
						  showError = true
						  isLoading = false
						  errorMessage = error.detail.first?.msg ?? "Validation error"
					 }
				}
				catch {
					 await MainActor.run {
						  showError.toggle()
						  errorMessage = ErrorMessage.unknown.rawValue
						  isLoading = false
					 }
				}
		  }
	 }

	 
	 func authorise() {
		  isLoading = true

		  guard let formattedNumber else {
				showError.toggle()
				errorMessage = "Phone number is empty!"
				isLoading = false
				return
		  }

		  verificationCode = ""

		  Task {
				do {
					 try await authService.authoriseUser(phoneNumber: formattedNumber, verificationCode: verificationCode)
					 await MainActor.run {
						  isLoading = false
					 }
				}
				catch let error as ErrorMessage {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.rawValue
						  isLoading = false
					 }
				}
				catch let error as NotFoundError {
					 await MainActor.run {
						  showError = true
						  isLoading = false
						  errorMessage = error.detail.message
					 }
				}
				catch {
					 await MainActor.run {
						  showError = true
						  isLoading = false
						  errorMessage = ErrorMessage.unknown.rawValue
					 }
				}
		  }
	 }


	 func saveAuthorizationData() {

	 }

	 func sendToRegistration() {

	 }

	 func countryName(countryCode: String) -> String? {
		  let current = Locale(identifier: "en_US")
		  return current.localizedString(forRegionCode: countryCode)
	 }

	 func changeMaskAndCode(for flag: String) {
		  countryNameAndFlag = flag
	 }

	 func resetUI() {
		  // CANCEL REQUEST

		  verificationRequested = false
		  verificationCode = ""
	 }
}
