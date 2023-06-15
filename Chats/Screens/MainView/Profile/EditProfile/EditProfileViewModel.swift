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
	 
	 @Published var name = ""
	 @Published var birthday = Date.now
	 @Published var city = ""
	 @Published var status = "Enter new bio..."
	 @Published var vk = ""
	 @Published var instagram = ""

	 @Published var showImagePicker = false
	 @Published var inputImage: UIImage?
	 @Published var imageName: String?

	 @Published var showError = false
	 @Published private(set) var errorMessage = ""

	 @Published var showSuccess = false
	 @Published private(set) var message = ""

	 
	 init(user: User, apiService: APIService) {
		  self.user = user
		  self.apiService = apiService
		  self.imageName = ""

		  if let imageData = user.avatar {
				self.inputImage = ImageConverter().convertBase64ToImage(base64String: imageData)
		  }
	 }
	 
	 
	 func submit() {
		  guard let updatedUser = createUpdatedUser() else {
				showError = true
				errorMessage = ErrorMessage.unableConvertImageData.rawValue
				return
		  }

		  Task {
				do {
					 try await apiService.updateUserOnServer(user: updatedUser)

					 await MainActor.run {
						  showSuccess = true
						  message = "Data has been saved"
					 }
				}
				catch let error as ErrorMessage{
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


	 private func createUpdatedUser() -> UserUpdate? {

		  guard let inputImage,
				  let imageName,
				  let imageData = ImageConverter().convertImageToBase64String(img: inputImage)
		  else {
				return nil
		  }

		  let newAvatar = Avatar(filename: imageName, base64: imageData)
		  let updatedUser = UserUpdate(name: user.name,
												 username: user.username,
												 birthday: birthday.convertToDashedDate(),
												 city: city,
												 vk: vk,
												 instagram: instagram,
												 status: status,
												 avatar: newAvatar)
		  return updatedUser
	 }
}
