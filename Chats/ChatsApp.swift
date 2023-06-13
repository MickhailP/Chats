//
//  ChatsApp.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

@main
struct ChatsApp: App {
	 
	 @StateObject var authenticationService = AuthService(networkingService: NetworkService())

    var body: some Scene {
		  WindowGroup {
				ZStack {
					 switch authenticationService.authState {
						  case .auth:
								AuthView(viewModel: AuthViewModel(authService: authenticationService, regionCodeService: RegionCodesService()))
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
						  case .registration:
								RegistrationView(viewModel: RegistrationViewModel(authService: authenticationService, phoneNumber: authenticationService.phoneNumber))
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
						  case .authenticated:
								MainAppView()
									 .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
					 }
				}
				.animation(.easeInOut, value: authenticationService.authState)
		  }
    }
}
