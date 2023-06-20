//
//  RegistrationView.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import SwiftUI


struct RegistrationView: View {

	 @StateObject var viewModel: RegistrationViewModel

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
						  .robotoRegularFont(size: 18)
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
					 .robotoBoldFont(size: 35)
				Text("Create your Account")
					 .robotoRegularFont(size: 20)
		  }
		  .foregroundColor(.white)
		  .padding(.bottom, 60)

	 }

	 @ViewBuilder
	 var registrationFields: some View {
		  VStack(alignment: .leading, spacing: 20) {

				phoneLabel

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
										  .robotoRegularFont(size: 18)
										  . padding(.trailing, 30) , alignment: .trailing
								)
					 }
				}
				.headlineCapsule()

		  }
		  .padding(.horizontal, 20)

		  Text("Allowed symbols: A-z, a-z, 0-9, _ -")
				.robotoRegularFont(size: 12)
				.foregroundColor(.secondary)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal, 20)
				.padding(.top, 5)

	 }

	 var phoneLabel: some View {
		  HStack {
				Image(systemName: "iphone.gen2")

				Text(viewModel.phoneNumber ?? "NA")
				Spacer()
		  }
		  .padding()
		  .frame(maxWidth: .infinity)
		  .robotoBoldFont(size: 17)
		  .foregroundColor(.white)
	 }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
		  RegistrationView(viewModel: RegistrationViewModel(authService: AuthService(networkingService: NetworkService(), apiService: APIService(networkService: NetworkService())), phoneNumber: "+134511551155"))
    }
}
