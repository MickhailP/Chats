//
//  MainAppViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 15.06.2023.
//

import Foundation

final class MainAppViewModel: ObservableObject {

	 let apiService: APIService

	 @Published var isLoading = false

	 @Published var showError = false
	 @Published var errorMessage = ""

	 init(apiService: APIService) {
		  self.apiService = apiService
	 }

	 func fetchUserData(completion: @escaping ((User) -> Void)) async {
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
				if let savedUser = PersistenceService.fetchUser() {
					 await MainActor.run {
						  completion(savedUser)
					 }
				} else {
					 let fetchedUser = try await apiService.getUserData()

					 try PersistenceService.save(user: fetchedUser)
					 await MainActor.run {
						  completion(fetchedUser)
					 }
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
