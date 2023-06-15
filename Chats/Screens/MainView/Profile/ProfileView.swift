//
//  ProfileView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct ProfileView: View {

	 @Environment(\.colorScheme) var colorScheme


	 let user: User

	 let corner: CGFloat = 10

	 @State private var profileText = "Enter your bio..."

	 var body: some View {
		  NavigationView {

				ZStack {
					 Gradients.main()
						  .opacity(colorScheme == .dark ? 0.5 : 0.3)

					 ScrollView {
						  VStack {

								AvatarImageView(base64: user.avatar, online: user.online)

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
				Text(user.name)
					 .font(.title)
				Text(user.username)
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
						  Text("\(user.completedTask ?? 0) tasks")
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
						  if let date = user.last?.convertToDate() {
								let dateSting = date.convertToDayMonthTimeFormat()
								Text(dateSting)
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
					 if let date = user.created?.convertToDate() {
						  let dateSting = date.convertToShortDate()
						  Text(dateSting)
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
				Text("📱" + user.phone)
				Text("📍 \(user.city ?? "NA") ")
				Text("🎁 \(user.birthday ?? "NA") ")
				Text("🐒 zodiak ")

		  }
		  .padding()
		  .frame(maxWidth: .infinity, alignment: .leading)
	 }


	 var aboutMe: some View {
		  VStack(spacing: 5) {
				Text("About me")
					 .font(.headline)
					 .frame(maxWidth: .infinity, alignment: .leading)


				Text(user.status ?? "")
					 .padding(5)
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
				Group {
					 HStack {
						  Image(systemName: "person.fill.viewfinder")
						  if let urlString = user.vk,
							  let url = URL(string: urlString ){
								Link("VK", destination: url)
						  }
					 }
					 HStack {
						  Image(systemName: "person.fill.viewfinder")
						  if let urlString = user.instagram,
							  let url = URL(string: urlString ) {
								Link("Instagram", destination: url)
						  }
					 }
				}
				.font(.footnote)
		  }
		  .padding()
	 }
}

//MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
	 static var previews: some View {
		  ProfileView(user: User.example)
	 }
}
