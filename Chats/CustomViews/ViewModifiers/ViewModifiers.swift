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


struct GreenButton: ViewModifier {

	 func body(content: Content) -> some View {
		  content
				.buttonStyle(.borderedProminent)
				.tint(.green)
				.controlSize(.large)
				.shadow(radius: 5, x: 5, y: 5)
	 }
}

struct RegularShadow: ViewModifier {

	 func body(content: Content) -> some View {
		  content
				.shadow(radius: 10, x: 5, y: 5)
	 }
}

struct GrayRoundedContainer: ViewModifier {

	 func body(content: Content) -> some View {
		  content
				.background(
					 RoundedRectangle(cornerRadius: 8)
						  .fill(Color(uiColor: .secondarySystemBackground
))

				)
				.overlay(
					 RoundedRectangle(cornerRadius: 8)
						  .stroke(Color.gray, lineWidth: 1)
				)
	 }
}


extension View {

	 func headlineCapsule() -> some View {
		  modifier(HeadlineCapsule())
	 }

	 func regularShadow() -> some View {
		  modifier(RegularShadow())
	 }

	 func grayRoundedContainer() -> some View {
		  modifier(GrayRoundedContainer())
	 }
}

extension Button {

	 func bigGreenButton() -> some View {
		  modifier(GreenButton())
	 }
}
