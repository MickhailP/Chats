//
//  Gradients.swift
//  Chats
//
//  Created by Миша Перевозчиков on 13.06.2023.
//

import SwiftUI

struct Gradients {

	 static func main() -> some View {
		  LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
	 }
}
