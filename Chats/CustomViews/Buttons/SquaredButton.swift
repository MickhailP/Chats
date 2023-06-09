//
//  SquaredButton.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

struct SquaredButton: View {
	 let buttonTitle: String
	 let action: () -> Void

    var body: some View {
		  Button {
				action()
		  } label: {
				Text(buttonTitle)
					 .frame(maxHeight: 35)
		  }
		  .buttonStyle(.borderedProminent)
		  .tint(.green)
		  .shadow(radius: 5, x: 5, y: 5)
	 }
}

struct SquaredButton_Previews: PreviewProvider {
    static var previews: some View {
		  SquaredButton(buttonTitle: "ASDSD") {
				
		  }
    }
}
