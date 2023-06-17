//
//  ProfileView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct ProfileView: View {

	 @Environment(\.colorScheme) var colorScheme
	 @EnvironmentObject var authService: AuthService

	 @State private var profileText = "Enter your bio..."

	 let corner: CGFloat = 10

	 @State private var showError = false
	 @State private var errorMessage = ""

	 var body: some View {
		  NavigationView {

				ZStack {
					 Gradients.main()
						  .opacity(colorScheme == .dark ? 0.5 : 0.3)

					 ScrollView {
						  VStack {

								AvatarImageView(base64: authService.user?.avatar, online: authService.user?.online)
									 .padding(.top, 30)

								header

								metricsSection

								personalDataSection

								aboutMe

								socialMediaSection
						  }
						  .padding(.horizontal, 20)
						  .frame(maxWidth: .infinity)
					 }
					 .frame(maxWidth: .infinity)
					 .background(.ultraThinMaterial)
				}
				.navigationBarHidden(true)

				.overlay(alignment: .topTrailing) {
					 NavigationLink {
						  if let user = authService.user {
								EditProfileView(viewModel: EditProfileViewModel(user: user, apiService: APIService(networkService: NetworkService())))
						  }
					 } label: {
						  Image(systemName: "square.and.pencil")
								.foregroundColor(.black)
								.font(.title3)
								.padding(15)
					 }
					 .labelStyle(.iconOnly)
				}
		  }
	 }
}

//MARK: - View components
extension ProfileView {
	 
	 var header: some View {
		  VStack(spacing: 5) {
				Text(authService.user?.name ?? "Unknown")
					 .font(.title)
				Text(authService.user?.username ?? "Unknown")
					 .foregroundColor(.secondary)
		  }
		  .padding()
		  .regularShadow()
	 }


	 var metricsSection: some View {
		  HStack(spacing: 15) {

				VStack(spacing: 5) {
					 Group {
						  Text("Completed")
						  Text("\(authService.user?.completedTask ?? 0) tasks")
								.padding(5)
								.background(Color.green)
								.clipShape(Capsule())
					 }
					 .frame(maxWidth: .infinity, alignment: .center)
				}
				.padding(10)
				.foregroundColor(.white)
				.background(Color.black)
				.cornerRadius(corner)


				VStack(alignment: .leading, spacing: 5) {
					 Group {
						  Text("Last visit")
								.foregroundColor(.secondary)
						  if let date = authService.user?.last?.convertToDate() {
								let dateSting = date.convertToDayMonthTimeFormat()
								Text(dateSting)
									 .padding(.vertical, 5)
						  } else {
								Text("Unknown")
									 .padding(.vertical, 5)
						  }
					 }
					 .frame(maxWidth: .infinity, alignment: .leading)
				}

				.padding(10)
				.grayRoundedContainer()

				VStack(alignment: .leading, spacing: 5) {
					 
					 Text("Created")
						  .foregroundColor(.secondary)
					 if let date = authService.user?.created?.convertToDate() {
						  let dateSting = date.convertToShortDate()
						  Text(dateSting)
								.padding(.vertical, 5)
					 }
					 else {
						  Text("Unknown")
								.padding(.vertical, 5)
					 }
				}
				.padding(10)
				.grayRoundedContainer()
		  }
		  .font(.subheadline)
		  .regularShadow()
	 }


	 var personalDataSection: some View {
		  VStack(alignment: .leading, spacing: 10) {
				Text("📱 +" + (authService.user?.phone ?? "Unknown"))
				Text("📍 \(authService.user?.city ?? "Unknown")")
				Text("🎁 \(authService.user?.birthday ?? "Unknown")")
				Text(getZodiacSignAndName(from: authService.user?.birthday) ?? "Unknown")

		  }
		  .padding()
		  .frame(maxWidth: .infinity, alignment: .leading)
	 }


	 var aboutMe: some View {
		  VStack(spacing: 5) {
				Text("About me")
					 .font(.headline)
					 .frame(maxWidth: .infinity, alignment: .leading)


				Text(authService.user?.status ?? "")
					 .padding(5)
					 .fixedSize(horizontal: false, vertical: true)
					 .frame(maxWidth: .infinity, alignment: .leading)
					 .foregroundColor(.secondary)
					 .grayRoundedContainer()
					 .regularShadow()
		  }
		  .padding()
	 }


	 var socialMediaSection: some View {
		  VStack(alignment: .leading, spacing: 10) {
				HStack {
					 Text("Social media")
						  .font(.headline)
					 Spacer()
				}

				HStack {
					 Image(systemName: "person.fill.viewfinder")
					 Text("VK")
					 if let urlString = authService.user?.vk,
						 let url = URL(string: urlString ){
						  Link(urlString, destination: url)
					 }
				}

				HStack {
					 Image(systemName: "person.fill.viewfinder")
					 Text("Instagram")
					 if let urlString = authService.user?.instagram,
						 let url = URL(string: urlString ) {
						  Link(urlString, destination: url)
					 }
				}
		  }
		  .padding()
	 }
}

//MARK: - Zodiac
extension ProfileView {

	 private func getZodiacSignAndName(from birthday: String?) -> String?{

		  if let birthday,
			  let date = birthday.convertFromDashedDate(),
			  let sign = ZodiacAPI.getZodiacSign(for: date) {

				let signAndName = "\(sign.rawValue) \(sign.zodiacName)"
				return signAndName
		  }
		  return nil
	 }
}

//MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
	 static var previews: some View {
		  //		  ProfileView(user: Binding.constant(User.example))
		  ProfileView()

	 }
}
