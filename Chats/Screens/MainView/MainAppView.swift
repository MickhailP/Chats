//
//  MainAppView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct MainAppView: View {

	 @StateObject var viewModel: MainAppViewModel

	 @EnvironmentObject var authService: AuthService

	 init(viewModel: MainAppViewModel) {
		  _viewModel = StateObject(wrappedValue: viewModel)
	 }


    var body: some View {
		  TabView {
				ChatsView()
					 .tabItem {
						  Label("Chats", systemImage: "message")
					 }
				ProfileView(viewModel: ProfileViewModel(authService: authService))
					 .tabItem {
						  Label("Profile", systemImage: "person.circle")
					 }
		  }
		  .task {
				await viewModel.fetchUserData()
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
		  //TODO: FIX
		  MainAppView(viewModel: MainAppViewModel(authService: AuthService(networkingService: NetworkService(), apiService: APIService(networkService: NetworkService()))))
    }
}
