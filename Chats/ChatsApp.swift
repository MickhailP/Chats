//
//  ChatsApp.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

@main
struct ChatsApp: App {

	 @StateObject var authenticationService: AuthService
	 @StateObject var networkMonitor = NetworkMonitor()
	 @State private var showNetworkAlert = false

	 init() {
		  let networkService = NetworkService()
		  let apiService = APIService(networkService: networkService)

		  _authenticationService = StateObject(wrappedValue: AuthService(networkingService: networkService, apiService: apiService))
	 }

    var body: some Scene {
		  WindowGroup {
				ZStack {
					 switch authenticationService.authState {
						  case .authentication:
								AuthView(viewModel: AuthViewModel(authService: authenticationService, regionCodeService: RegionCodesService()))
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
						  case .registration:
								RegistrationView(viewModel: RegistrationViewModel(authService: authenticationService, phoneNumber: authenticationService.phoneNumber))
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
						  case .authenticated:
								MainAppView(viewModel: MainAppViewModel(authService: authenticationService))
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
					 }
				}
				.environmentObject(authenticationService)
				.animation(.easeInOut, value: authenticationService.authState)
				.onChange(of: networkMonitor.isConnected) { connection in
					 showNetworkAlert = connection == false
					 
				}
				.alert("Network error", isPresented: $showNetworkAlert) {
					 Button("Ok") { }
				} message: {
					 Text("Seems you are offline.\n Check your internet connection")
				}
		  }
    }
}
