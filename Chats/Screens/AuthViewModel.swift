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
	 @Published var countryMask: Int?
	 @Published var phoneNumber: Int?
	 @Published var verificationCode = 133337


	 @Published private(set) var verificationRequested = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 
	 init(authService: AuthenticationProtocol) {
		  self.authService = authService
	 }

	 func requestVerificationCode(for number: Int?) {

		  guard let phoneNumber, let countryMask else {
				showError.toggle()
				errorMessage = "Phone number is empty!"
				return
		  }


		  verificationRequested = true
		  let phoneToRegister = "+" + "\(countryMask)" + "\(phoneNumber)"

		  do {
				try authService.verify(phoneNumber: phoneToRegister)
		  } catch let error as ErrorMessage {
				showError.toggle()
				errorMessage = error.rawValue
		  } catch {
				showError.toggle()
				errorMessage = ErrorMessage.unknown.rawValue
		  }
	 }

	 func authorise() {

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
	 }
}
