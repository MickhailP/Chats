//
//  ViewModifiers.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

struct HeadlineCapsule: ViewModifier {
	 func body(content: Content) -> some View {
		  content
				.padding()
				.font(.headline)
				.background(Color(.tertiarySystemBackground))
				.cornerRadius(25)
	 }
}

extension View {
	 func headlineCapsule() -> some View {
		  modifier(HeadlineCapsule())
	 }
}
