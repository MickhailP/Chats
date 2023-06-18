//
//  RegistrationView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import SwiftUI


struct RegistrationView: View {

	 @StateObject var viewModel = RegistrationViewModel(authService: AuthService(networkingService: NetworkService()), phoneNumber: "+134511551155")

	 @FocusState private var focusField: Field?

	 enum Field {
		  case name, username
	 }

	 init(viewModel: RegistrationViewModel) {
		  _viewModel = StateObject(wrappedValue: viewModel)
	 }

	 var body: some View {
		  ZStack {
				ScrollView {
					 VStack {
						  header

						  registrationFields


						  Button {
								if !viewModel.isRegistering {
									 viewModel.registerPressed()
								}
						  } label: {
								Text("Register")
						  }
						  .bigGreenButton()
						  .disabled(viewModel.isRegistering)
						  .padding(.top, 50)
					 }
					 .regularShadow()
					 .padding(.top, 100)
				}
				.onTapGesture {
					 focusField = .none
				}
				.alert("Error", isPresented: $viewModel.showError, actions: {
					 Button("Ok", action: {})
				}, message: {
					 Text("\(viewModel.errorMessage)")
				})
				.padding(1)
				.background( Gradients.main())

				if viewModel.isRegistering {
					 LoadingView()
				}
		  }
	 }
}


//MARK: - Components
extension RegistrationView {

	 var header: some View {
		  VStack(spacing: 10) {
				Text("Register")
					 .font(.largeTitle)
					 .fontWeight(.bold)
				Text("Create your Account")
		  }
		  .foregroundColor(.white)
		  .padding(.bottom, 60)

	 }

	 var registrationFields: some View {
		  Group {
				VStack(alignment: .leading, spacing: 20) {
					 HStack {
						  Image(systemName: "iphone.gen2")

						  Text(viewModel.phoneNumber ?? "NA")
						  Spacer()
					 }
					 .padding()
					 .frame(maxWidth: .infinity)
					 .font(.headline)
					 .foregroundColor(.white)


					 Group {
						  HStack {
								Image(systemName: "person.fill")
								TextField("Name", text: $viewModel.name)
									 .focused($focusField, equals: .name)
									 .onSubmit {
										  focusField = .username
									 }
						  }

						  HStack {
								Image(systemName: "character.textbox")
								TextField("Username", text: $viewModel.username)
									 .focused($focusField, equals: .username)
									 .onSubmit {
										  viewModel.registerPressed()
									 }
									 .overlay(
										  ZStack{
												Image(systemName: viewModel.isUsernameValid ? "checkmark" : "xmark")
													 .foregroundColor(viewModel.isUsernameValid ? .green : .red)

										  }
												.font(.headline)
												. padding(.trailing, 30) , alignment: .trailing
									 )
						  }
					 }
					 .headlineCapsule()

				}
				.padding(.horizontal, 20)

				Text("Allowed symbols: A-z, a-z, 0-9, _ -")
					 .font(.footnote)
					 .foregroundColor(.secondary)
					 .frame(maxWidth: .infinity, alignment: .leading)
					 .padding(.horizontal, 20)
					 .padding(.top, 5)
		  }
	 }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
		  RegistrationView(viewModel: RegistrationViewModel(authService: AuthService(networkingService: NetworkService()), phoneNumber: "+134511551155"))
    }
}
