//
//  LoadingView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 17.06.2023.
//

import SwiftUI

struct LoadingView: View {

	 var body: some View {
		  VStack(spacing: 20) {
					 ProgressView()
						  .tint(.blue)
						  .scaleEffect(2)


				Text("Loading content...")
		  }
		  .frame(maxWidth: .infinity, maxHeight: .infinity)
		  .background(.ultraThickMaterial)
		  .ignoresSafeArea()
	 }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
