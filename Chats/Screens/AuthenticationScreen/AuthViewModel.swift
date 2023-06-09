//
//  AuthViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation
import Combine


final class AuthViewModel: ObservableObject {

	 let authService: AuthenticationProtocol
	 let regionCodeService: RegionCodesService
	 

	 @Published var countries: [String: String]
	 @Published var countryNameAndFlag = ""
	 @Published var countryMask = ""

	 @Published var phoneNumber = ""
	 @Published var verificationCode = ""

	 @Published private(set) var verificationRequested = false
	 @Published private(set) var isLoading = false
	 @Published private(set) var isAuthorisation = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 @Published var showCountriesVariants = false
	 @Published private(set) var countriesVariants: [String: String] = [:]

	 var cancellables = Set<AnyCancellable>()

	 var formattedNumber: String? {
		  if let phoneNumber = Int(phoneNumber), let countryMask = Int(countryMask) {
				let number = "+" + "\(countryMask)" + "\(phoneNumber)"

				return number
		  } else {
				return nil
		  }
	 }

	 
	 init(authService: AuthenticationProtocol, regionCodeService: RegionCodesService) {
		  self.authService = authService
		  self.regionCodeService = regionCodeService
		  countries = regionCodeService.countryCodes

		  setLocalCountry()
	 }

	 
	 func requestVerificationCode(for number: String) {
		  isLoading = true
		  verificationRequested = true



		  guard let formattedNumber else {
				showError.toggle()
				errorMessage = "Phone number is empty!"
				verificationRequested = false
				isLoading = false
				return
		  }

		  Task {

				defer {
					 Task {
						  await MainActor.run {
								isLoading = false
						  }
					 }
				}


				do {
					 try await authService.verify(phoneNumber: formattedNumber)
				}
				catch let error as ErrorMessage {
					 await MainActor.run {
						  showError.toggle()
						  errorMessage = error.rawValue
						  resetUI()
					 }
				}
				catch let error as ValidationError {
					 await MainActor.run {
						  showError.toggle()
						  errorMessage = error.detail.first?.msg ?? "Validation error"
						  resetUI()
					 }
				}
				catch {
					 await MainActor.run {
						  showError.toggle()
						  errorMessage = error.localizedDescription
						  resetUI()
					 }
				}
		  }
	 }

	 
	 func authorise() {
		  isLoading = true
		  isAuthorisation = true

		  if authService.isVerified {

				guard let formattedNumber else {
					 showError.toggle()
					 errorMessage = "Phone number is empty!"
					 resetUI()
					 return
				}

				Task {
					 defer {
						  Task {
								await MainActor.run {
									 isLoading = false
								}
						  }
					 }

					 do {
						  try await authService.authoriseUser(phoneNumber: formattedNumber, verificationCode: verificationCode)
					 }
					 catch let error as ErrorMessage {
						  await MainActor.run {
								resetUI()
								showError = true
								errorMessage = error.rawValue
						  }
					 }
					 catch let error as NotFoundError {
						  await MainActor.run {
								resetUI()
								showError = true
								errorMessage = error.detail.message
						  }
					 }
					 catch {
						  await MainActor.run {
								resetUI()
								showError = true
								errorMessage = error.localizedDescription

						  }
					 }
				}
		  } else {
				resetUI()

				showError = true
				errorMessage = ErrorMessage.verificationError.rawValue
		  }
	 }


	 func changeMaskAndCode(for key: String) {
		  if let countryData = getCountryData(for: key) {
				countryNameAndFlag = "\(countryData.name) \(countryData.flag)"
				countryMask = countryData.mask
		  }
	 }


	 func getCountryData(for key: String) -> (name: String, flag: String, mask: String)? {
		  if let flag = regionCodeService.countryCodeToFlag(key),
			  let mask = countries[key] {
				 return  (key, flag, mask)
		  }
		  return nil
	 }


	 func resetUI() {
		  isLoading = false
		  verificationRequested = false
		  verificationCode = ""
	 }


	 private func setLocalCountry() {
		  if let regionCode = Locale.current.regionCode {
				changeMaskAndCode(for: regionCode)
		  }
	 }


	 func subscribeOnCountryMask() {
		  $countryMask
				.dropFirst(1)
				.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
				.sink { [weak self] countryMask in
					 guard let self = self else { return }

					 let filteredCountries = self.countries.filter({ $0.value == countryMask })

					 if filteredCountries.count > 1 {
								self.showCountriesVariants = true
								self.countriesVariants = filteredCountries
					 } else {
						  guard let key = self.countries.first(where: { $0.value == countryMask })?.key else {
								return
						  }

						  self.changeMaskAndCode(for: key)
					 }
				}
				.store(in: &cancellables)
	 }
}
