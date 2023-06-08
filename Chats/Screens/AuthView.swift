//
//  AuthView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

struct AuthView: View {

	 @StateObject var viewModel: AuthViewModel
	 
	 var body: some View {
		  VStack(spacing: 20) {
				Spacer()

				Text("Login")
					 .font(.largeTitle)
					 .fontWeight(.bold)
					 .foregroundColor(.white)

				phoneNumberAndVerificationCodeSection

				VStack(spacing: 15) {

					 authorizationButtons()
					 
					 Button {
						  withAnimation {
								viewModel.resetUI()
						  }
					 } label: {
						  Text("Edit number")
								.font(.callout)
					 }
					 .tint(.white)
				}

				Spacer()
		  }
		  .padding()
		  .background(
				LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
					 .edgesIgnoringSafeArea(.all))
	 }
}

//MARK: - View components
extension AuthView {

	 var phoneNumberAndVerificationCodeSection: some View {
		  Group {
				phoneNumberTextField

				TextField("Verification code", value: $viewModel.phoneNumber, format: .number)
					 .headlineCapsule()
					 .shadow(radius: 10, x: 5, y: 5)
					 .opacity(viewModel.verificationRequested ? 1 : 0)
		  }
	 }


	 var phoneNumberTextField: some View {
		  HStack {
				HStack {
					 Menu(viewModel.countryNameAndFlag) {
						  ForEach(0..<100, id: \.self) { _  in
								Button {
									 viewModel.changeMaskAndCode(for: "RU 🇷🇺")
								} label: {
									 //CHANGE TO COUNTRY DATA
									 Text("RU 🇷🇺 +7")
								}
						  }
					 }
					 Text("+")
					 TextField("000", value: $viewModel.countryMask, format: .number)
						  .frame(maxWidth: 40)
				}
				.padding(.horizontal, 5)
				.disabled(viewModel.disablePhoneTextfield)


				TextField("Phone number", value: $viewModel.phoneNumber, format: .number)
					 .disabled(viewModel.disablePhoneTextfield)
		  }
		  .headlineCapsule()
		  .opacity(viewModel.disablePhoneTextfield ? 0.6 : 1)
		  .shadow(radius: 10, x: 5, y: 5)
	 }

	 @ViewBuilder func authorizationButtons() -> some View {
		  if  !viewModel.verificationRequested {
				SquaredButton(buttonTitle: "Send verification code") {
					 withAnimation {
						  viewModel.requestVerificationCode(for: viewModel.phoneNumber)
					 }
				}
		  } else {
				SquaredButton(buttonTitle: "Authorise") {
					 withAnimation {
						  viewModel.authorise()
					 }
				}
		  }
	 }
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
	 static var previews: some View {
		  AuthView(viewModel: AuthViewModel())
	 }
}
