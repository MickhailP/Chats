//
//  KeychainStorage.swift
//  Chats
//
//  Created by Миша Перевозчиков on 09.06.2023.
//

import Foundation
import SwiftKeychainWrapper

enum KeychainStorage {
	 static let key = "credentials"


	 static func getCredentials() throws -> AuthData? {

		  let fetchedData = KeychainWrapper.standard.data(forKey: key)

		  guard let fetchedData else {
			throw ErrorMessage.authDataIsMissing
		  }

		  do {
				let decodedUser = try JSONDecoder().decode(AuthData.self, from: fetchedData)
				return decodedUser
		  } catch  {
				throw ErrorMessage.decodingError
		  }
	 }


	 static func saveCredentials(_ data: AuthData) {
		  do {
				let encoded = try JSONEncoder().encode(data)
				KeychainWrapper.standard.set(encoded, forKey: key)
		  } catch {
				print(error)
		  }
	 }
}
