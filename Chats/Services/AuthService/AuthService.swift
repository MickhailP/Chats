//
//  AuthService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation
import Combine


protocol AuthenticationProtocol: AnyObject {
	 var networkingService: NetworkProtocol { get }

	 func verify(phoneNumber: String) throws
}




final class AuthService: AuthenticationProtocol, ObservableObject {

	 let networkingService: NetworkProtocol

	 @Published var verificationCode: Int?
	 @Published var isUserExist:Bool?

	 init(networkingService: NetworkProtocol) {
		  self.networkingService = networkingService
	 }


	 func verify(phoneNumber: String) throws {

		  guard let url = URL(string: "https://plannerok.ru/api/v1/users/send-auth-code/") else {
				throw ErrorMessage.badURl
		  }

		  let json = """
		  {
		  "phone": "\(phoneNumber)"
		  }
		  """

		  guard let request = configureTokenFreeRequest(httpMethod: "POST", url: url, json: json) else {
				throw ErrorMessage.barRequest
		  }


		  Task {
				let result = await networkingService.downloadDataResult(for: request)

				switch result {
					 case .success(let data):
						  if let decoded: VerificationCode = Decoder.decode(data) {

								await MainActor.run {
									if decoded.isSuccess {

										 isUserExist = true
									} else {
										 isUserExist = true
									}
								}
						  }
					 case .failure(let failure):
						  throw failure
				}
		  }
	 }

	 func authoriseUser(with phone: String, verificationCode: String) {


	 }



	 private func configureTokenFreeRequest(httpMethod: String, url: URL, json: String ) -> URLRequest? {

		  var request = URLRequest(url: url)
		  request.httpMethod = httpMethod
		  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		  if let uploadData = json.data(using: .utf8)  {
				request.httpBody = uploadData
				return request
		  }
		  return nil
	 }
}
