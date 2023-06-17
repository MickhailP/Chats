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

		  do {
				if let savedUser = PersistenceService.fetchUser() {

					 print("GET SAVED")
					 await MainActor.run {
						  completion(savedUser)
						  isLoading = false
					 }
				} else {
					 let fetchedUser = try await apiService.getUserData()

					 try PersistenceService.save(user: fetchedUser)
					 await MainActor.run {
						  print("GET FETCHED")
						  completion(fetchedUser)
						  isLoading = false
					 }
				}
		  } catch let error as ErrorMessage {
				await MainActor.run {
					 showError = true
					 errorMessage = error.rawValue
					 isLoading = false
				}
		  } catch {
				print(error)
				await MainActor.run {
					 showError = true
					 errorMessage = error.localizedDescription
					 isLoading = false
				}
		  }
	 }
}
