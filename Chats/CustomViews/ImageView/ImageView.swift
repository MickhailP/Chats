//
//  ImageView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct ImageView: View {

	 @StateObject private var viewModel: ImageViewModel

	 //MARK: Init
	 init(imageUrl: String) {
		  _viewModel = StateObject(wrappedValue: ImageViewModel(imageUrl: imageUrl, networkService: NetworkService()))
	 }


	 // MARK: View
	 @ViewBuilder var body: some View {
		  if let image = viewModel.image {
				Image(uiImage: image)
					 .resizable()
					 .scaledToFit()
		  } else {
				ProgressView()
		  }
	 }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
		  ImageView(imageUrl: User.example.avatar ?? "")
    }
}
