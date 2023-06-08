//
//  ChatsApp.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

@main
struct ChatsApp: App {
    var body: some Scene {
        WindowGroup {
				AuthView(viewModel: AuthViewModel())
        }
    }
}
