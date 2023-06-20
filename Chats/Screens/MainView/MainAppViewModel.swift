//
//  MainAppViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 15.06.2023.
//

import Foundation

final class MainAppViewModel: ObservableObject {

	 private let authService: AuthenticationProtocol

	 @Published private(set) var isLoading = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""


	 init(authService: AuthenticationProtocol) {
		  self.authService = authService
	 }

	 
	 func fetchUserData() async {
		  await MainActor.run {
				isLoading = true
		  }

		  defer {
				Task  {
					 await MainActor.run {
						  isLoading = false
					 }
				}
		  }

		  
		  do {
				let user = try await authService.getUserData()
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
