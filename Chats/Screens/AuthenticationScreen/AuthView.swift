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

				if !viewModel.isLoading {
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
				} else {
					 ProgressView()
						  .scaleEffect(2)
						  .padding()
				}

				Spacer()
		  }
		  .onTapGesture {
				focusField = .none
		  }
		  .overlay(alignment: .bottom) {
				Button {
					 withAnimation {
						  viewModel.sendToRegistration()
					 }
				} label: {
					 Text("Don't have an account? Create one.")
						  .fontWeight(.bold)
				}
				.tint(.white)
		  }
		  .padding()
		  .background(
				LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
					 .edgesIgnoringSafeArea(.all)
		  )
		  .confirmationDialog("Select country", isPresented: $viewModel.showCountriesVariants, actions: {
				ForEach(Array(viewModel.countriesVariants.keys), id: \.self) { country in
					 Button {
						  viewModel.changeMaskAndCode(for: country)
						  viewModel.cancellables.removeAll()
						  focusField = .phone
					 } label: {
						  if let countryData = viewModel.getCountryData(for: country) {
								Text("\(countryData.name) \(countryData.flag)  \(countryData.mask)")
						  }
					 }
				}
		  }, message: {
				Text("Seems there are some duplicates with your country code. Please, select one.")
		  })
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
					 .opacity(opacityForVerificationCodeField())
					 .keyboardType(.numberPad)
					 .focused($focusField, equals: .code)
					 .disabled(viewModel.isLoading)
		  }
	 }


	 var phoneNumberTextField: some View {
		  HStack {
				HStack {
					 Menu(viewModel.countryNameAndFlag) {
						  ForEach(Array(viewModel.countries.keys), id: \.self) { countryCode in
								Button {
									 viewModel.changeMaskAndCode(for: countryCode)
								} label: {
									 //CHANGE TO COUNTRY DATA
									 if let countryData = viewModel.getCountryData(for: countryCode) {
										  Text("\(countryData.name) \(countryData.flag)  \(countryData.mask)")
									 }
								}
						  }
					 }

					 Text("+")
					 TextField("000", text: $viewModel.countryMask, onEditingChanged: { isBegin in
						  if isBegin {
								viewModel.subscribeOnCountryMask()
								print(viewModel.cancellables.count)
						  } else {
								print(viewModel.cancellables.count)
								viewModel.cancellables.removeAll()
						  }
					 })
						  .frame(maxWidth: 60)
						  .keyboardType(.phonePad)
						  .multilineTextAlignment(.trailing)
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
						  withAnimation {
								viewModel.requestVerificationCode(for: viewModel.phoneNumber)
								focusField = .code
						  }
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
						  withAnimation {
								viewModel.authorise()
								focusField = .none
						  }
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


//MARK: - VerificationCode field opacity
extension AuthView {

	 private func opacityForVerificationCodeField() -> Double {
		  if viewModel.verificationRequested && viewModel.isLoading {
				return 0.6
		  } else if viewModel.verificationRequested {
				return 1
		  } else {
				return 0
		  }
	 }
}


//MARK: - Preview
struct AuthView_Previews: PreviewProvider {
	 static var previews: some View {
		  let network = NetworkService()
		  let authService = AuthService(networkingService: network, apiService: APIService(networkService: network))
		  AuthView(viewModel: AuthViewModel(authService: authService, regionCodeService: RegionCodesService()))
	 }
}
