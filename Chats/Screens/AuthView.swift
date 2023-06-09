//
//  AuthView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import SwiftUI

struct AuthView: View {

	 @StateObject var viewModel: AuthViewModel

	 @FocusState private var focusField: Field?

	 enum Field {
		  case mask, phone, code
	 }
	 
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
								focusField = .mask
						  }
					 } label: {
						  Text("Edit number")
								.font(.callout)
					 }
					 .tint(.white)
				}

				Spacer()
		  }
		  .onTapGesture {
				focusField = .none
		  }
		  .padding()
		  .background(
				LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
					 .edgesIgnoringSafeArea(.all)
		  )
		  .alert(isPresented: $viewModel.showError) {
				Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
		  }
	 }
}

//MARK: - View components
extension AuthView {

	 var phoneNumberAndVerificationCodeSection: some View {
		  Group {
				phoneNumberTextField

				TextField("Verification code", text: $viewModel.verificationCode)
					 .headlineCapsule()
					 .shadow(radius: 10, x: 5, y: 5)
					 .opacity(viewModel.verificationRequested ? 1 : 0)
					 .keyboardType(.numberPad)
					 .focused($focusField, equals: .code)
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
					 TextField("000", text: $viewModel.countryMask)
						  .frame(maxWidth: 60)
						  .keyboardType(.phonePad)
						  .focused($focusField, equals: .mask)

				}
				.padding(.horizontal, 5)
				.disabled(viewModel.verificationRequested)


				TextField("Phone number", text: $viewModel.phoneNumber)
					 .disabled(viewModel.verificationRequested)
					 .keyboardType(.phonePad)
					 .focused($focusField, equals: .phone)

		  }
		  .headlineCapsule()
		  .opacity(viewModel.verificationRequested ? 0.6 : 1)
		  .shadow(radius: 10, x: 5, y: 5)
	 }

	 @ViewBuilder func authorizationButtons() -> some View {
		  if !viewModel.verificationRequested {
				Button {
					 if !viewModel.isLoading {
						  viewModel.requestVerificationCode(for: viewModel.phoneNumber)
						  focusField = .code
					 }
				} label: {
					 Text("Send verification code")
						  .frame(maxHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.tint(.green)
				.shadow(radius: 5, x: 5, y: 5)

		  } else {
				Button {
					 if !viewModel.isLoading {
						  viewModel.authorise()
						  focusField = .none
					 }
				} label: {
					 Text("Authorise")
						  .frame(maxHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.tint(.green)
				.shadow(radius: 5, x: 5, y: 5)
		  }
	 }
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
	 static var previews: some View {
		  let network = NetworkService()
		  let authService = AuthService(networkingService: network)
		  AuthView(viewModel: AuthViewModel(authService: authService))
	 }
}
