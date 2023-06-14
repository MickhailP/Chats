//
//  AvatarImageView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct AvatarImageView: View {

	 let avatarURL: String?
	 let online: Bool?

	 var body: some View {
		  ZStack {
				Circle()
					 .fill(Color(uiColor: .secondarySystemBackground))
					 .regularShadow()
				Circle()
					 .strokeBorder(.white, lineWidth: 3)


				ImageView(imageUrl: avatarURL)
					 .frame(maxWidth: 100)
					 .clipShape(Circle())
					 .padding(3)

					 .overlay{
						  Circle()
								.fill( online ?? false ? .green : .red)
								.frame(maxWidth: 15)
								.offset(x: 35, y: 35)
								.shadow(radius: 10)

					 }
		  }
		  .frame(maxWidth: 100, maxHeight: 100)
	 }
}

struct AvatarImageView_Previews: PreviewProvider {
	 static var previews: some View {
		  AvatarImageView(avatarURL: User.example.avatar, online: User.example.online)
	 }
}
