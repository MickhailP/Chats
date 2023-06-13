//
//  MainAppView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct MainAppView: View {

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

		  }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
