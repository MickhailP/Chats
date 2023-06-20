//
//  EditProfileViewModel.swift
//  Chats
//
//  Created by Миша Перевозчиков on 14.06.2023.
//

import Foundation
import UIKit

final class EditProfileViewModel: ObservableObject {

	 let apiService: APIService
	 
	 @Published var user: User
	 
	 @Published var name: String
	 @Published var birthday = Date.now
	 @Published var city: String
	 @Published var status: String
	 @Published var vk: String
	 @Published var instagram: String

	 @Published var showImagePicker = false
	 @Published var inputImage: UIImage?
	 @Published var imageName: String?

	 @Published var isLoading = false

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 @Published var showSuccess = false
	 @Published private(set) var message = ""

	 
	 init(user: User, apiService: APIService) {
		  self.user = user
		  self.apiService = apiService

		  self.name = user.name
		  self.birthday = user.birthday?.convertFromDashedDate() ?? Date.now
		  self.city = user.city ?? ""
		  self.status = user.status ?? ""
		  self.vk = user.vk ?? ""
		  self.instagram = user.instagram ?? ""

		  if let imageData = user.avatar {
				self.inputImage = ImageConverter().convertBase64ToImage(base64String: imageData)
		  }
	 }
	 
	 
	 func submit(completion: @escaping ((User) -> Void)) {
		  isLoading = true


		  guard let updatedUser = createUpdatedUser() else {
				isLoading = false
				showError = true
				errorMessage = ErrorMessage.unableConvertImageData.rawValue
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
					 try await apiService.updateUserOnServer(user: updatedUser)

					 let newUser = updateCurrentUserData(with: updatedUser)
					 try saveToUserDefaults(newUser)

					 await MainActor.run {
						  showSuccess = true
						  message = "Data has been saved"
						  completion(newUser)
					 }
				}
				catch let error as ErrorMessage{
					 await MainActor.run {
						  showError = true
						  errorMessage = error.rawValue
					 }
				} catch let error as ValidationError {
					 await MainActor.run {
						  print(error)
						  showError = true
						  errorMessage = error.detail.first?.msg ?? error.localizedDescription
					 }
				}
				catch {
					 await MainActor.run {
						  showError = true
						  errorMessage = error.localizedDescription
					 }
				}
		  }
	 }


	 private func createUpdatedUser() -> UserUpdate? {

		  let imageData = ImageConverter().convertImageToBase64String(img: inputImage)

		  let newAvatar = Avatar(filename: imageName ?? "" , base64: imageData ?? "")

		  let updatedUser = UserUpdate(name: name,
												 username: user.username,
												 birthday: birthday.convertToDashedDate(),
												 city: city,
												 vk: vk,
												 instagram: instagram,
												 status: status,
												 avatar: newAvatar)
		  return updatedUser
	 }


	 private func updateCurrentUserData(with update: UserUpdate) -> User {
		  User(phone: user.phone,
				 name: update.name,
				 username: user.username,
				 birthday: update.birthday,
				 city: update.city,
				 vk: update.vk,
				 instagram: update.instagram,
				 status: update.status,
				 online: user.online)
	 }


	 private func saveToUserDefaults(_ user: User) throws {
		  try PersistenceService.save(user: user)
	 }
}
