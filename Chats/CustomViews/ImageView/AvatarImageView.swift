//
//  AvatarImageView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct AvatarImageView: View {

	 let uiImage: UIImage?
	 let base64: String?
	 let online: Bool?

	 init(uiImage: UIImage?, online: Bool?) {
		  self.uiImage = uiImage
		  self.online = online
		  self.base64 = nil
	 }

	 init(base64: String?, online: Bool?) {
		  self.base64 = base64
		  self.online = online
		  self.uiImage = ImageConverter().convertBase64ToImage(base64String: base64)
	 }

	 var body: some View {
		  ZStack {
				Circle()
					 .fill(Color(uiColor: .secondarySystemBackground))
					 .regularShadow()
				Circle()
					 .strokeBorder(.white, lineWidth: 3)

				imageView
					 .clipShape(Circle())
					 .padding(3)

					 .overlay{
						  if let online {
								Circle()
									 .fill( online ? .green : .red)
									 .frame(maxWidth: 15)
									 .offset(x: 35, y: 35)
									 .shadow(radius: 10)
						  }
					 }

		  }
		  .frame(maxWidth: 100, maxHeight: 100)
	 }
}

extension AvatarImageView {

	 @ViewBuilder var imageView: some View {
		  if let uiImage {
				Image(uiImage: uiImage)
					 .resizable()
					 .scaledToFill()
		  } else {
				Image(systemName: "person")
					 .resizable()
					 .scaledToFit()
					 .padding()
		  }
	 }
}


struct AvatarImageView_Previews: PreviewProvider {
	 static var previews: some View {
		  AvatarImageView(uiImage: ImageConverter().convertBase64ToImage(base64String: User.example.avatar ?? ""), online: User.example.online)
	 }
}
