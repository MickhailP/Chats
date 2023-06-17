//
//  MainAppView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct MainAppView: View {

	 @StateObject var viewModel = MainAppViewModel(apiService: APIService(networkService: NetworkService()))
	 @EnvironmentObject var authService: AuthService


    var body: some View {
		  TabView {
				ChatsView()
					 .tabItem {
						  Label("Chats", systemImage: "message")
					 }
				ProfileView()
					 .tabItem {
						  Label("Profile", systemImage: "person.circle")
					 }
					 .task {
						  await viewModel.fetchUserData { user in
								authService.user = user
						  }
					 }
		  }
		  .alert("Error", isPresented: $viewModel.showError, actions: {
				Button("Ok") { }
		  }, message: {
				Text(viewModel.errorMessage)
		  })
	 }
}


struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
