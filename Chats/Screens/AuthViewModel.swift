//
//  AuthViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


final class AuthViewModel: ObservableObject {

	 @Published var countryNameAndFlag = "RU 🇷🇺"
	 @Published var countryMask: Int?
	 @Published var phoneNumber: Int?
	 @Published var verificationCode: Int?
	 

	 @Published private(set) var disablePhoneTextfield = false
	 @Published private(set) var verificationRequested = false


	 func requestVerificationCode(for number: Int?) {
		  disablePhoneTextfield = true
		  verificationRequested = true
	 }

	 func authorise() {

	 }

	 func saveAuthorizationData() {

	 }

	 func sendToRegistration() {

	 }


	 func changeMaskAndCode(for flag: String) {
		  countryNameAndFlag = flag
	 }

	 func resetUI() {
		  // CANCEL REQUEST
		  disablePhoneTextfield = false
		  verificationRequested = false

	 }
}
