//
//  EditProfileView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 14.06.2023.
//

import SwiftUI

struct EditProfileView: View {

	 @Environment(\.dismiss) var dismiss
	 @EnvironmentObject var authService: AuthService

	 @StateObject var viewModel: EditProfileViewModel

	 init(viewModel: EditProfileViewModel) {
		  _viewModel = StateObject(wrappedValue: viewModel)
	 }

	 @ViewBuilder
	 var body: some View {
		  if !viewModel.isLoading {
				Form {
					 headerSection

					 personalInformationSection

					 bioSection

					 socialMediaSection

				}
				.navigationTitle("Edit profile")
				.toolbar {
					 ToolbarItem(placement: .confirmationAction) {
						  Button("Done") {
								viewModel.submit() { newUser in
									 authService.user = newUser
								}
						  }
					 }
				}
				.sheet(isPresented: $viewModel.showImagePicker) {
					 ImagePicker(image: $viewModel.inputImage, imageName: $viewModel.imageName)
				}
				.alert("Success", isPresented: $viewModel.showSuccess) {
					 Button("OK") {
						  dismiss()
					 }
				} message: {
					 Text(viewModel.message)
				}
				.alert("Error", isPresented: $viewModel.showError, actions: {
					 Button("OK") { }
				}) {
					 Text(viewModel.errorMessage)
				}
		  } else {
				LoadingView()
		  }
	 }
}


//MARK: - View components
extension EditProfileView {

	 var headerSection: some View {
		  Section {
				HStack {
					 VStack {
						  AvatarImageView(uiImage: viewModel.inputImage, online: nil)
								.onTapGesture {
									 viewModel.showImagePicker = true
								}

						  Button {
								viewModel.showImagePicker = true
						  } label: {
								Text("Change")
									 .font(.caption)
						  }
					 }

					 VStack(spacing: 15) {
						  VStack(alignment: .leading, spacing: 5) {
								Text("Username:")
									 .font(.subheadline)
									 .foregroundColor(.secondary)
								Text(viewModel.user.username)

						  }


						  VStack(alignment: .leading, spacing: 5) {
								Text("Phone:")
									 .font(.subheadline)
									 .foregroundColor(.secondary)
								Text(viewModel.user.phone)
						  }
					 }
					 .padding(.horizontal, 20)
				}
		  }
	 }


	 var personalInformationSection: some View {
		  Section {
				HStack {
					 Text("Name:")
					 TextField("New name", text: $viewModel.name)
				}
				HStack {
					 Text("City:")
					 TextField("New city", text: $viewModel.city)
				}

				DatePicker("Birthday:", selection: $viewModel.birthday, displayedComponents: .date)


		  } header: {
				Text("Personal information")
		  } footer: {
				Text("Please enter in information ")
		  }
	 }


	 var bioSection: some View {
		  Section {
				TextEditor(text: $viewModel.status)
					 .frame(height: 100)


		  } header: {
				Text("About:")
		  } footer: {
				Text("Tell about yourself")
		  }
	 }

	 var socialMediaSection: some View {
		  Section {
				HStack {
					 Text("VK:")
					 TextField("URL", text: $viewModel.vk)
				}
				HStack {
					 Text("Instagram:")
					 TextField("URL", text: $viewModel.instagram)
				}

		  } header: {
				Text("Social media links:")
		  }
	 }
}

struct EditProfileView_Previews: PreviewProvider {
	 static var previews: some View {
		  EditProfileView(viewModel: EditProfileViewModel(user: User.example, apiService: APIService(networkService: NetworkService())))
				.onAppear()
	 }
}
