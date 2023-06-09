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


	 static func getCredentials(completion: @escaping (Result<AuthData, ErrorMessage>) -> Void) {

		  let fetchedData = KeychainWrapper.standard.data(forKey: key)

		  guard let fetchedData else {
				completion(.failure(.authDataIsMissing))
				return
		  }

		  do {
				let decodedUser = try JSONDecoder().decode(AuthData.self, from: fetchedData)
				completion(.success(decodedUser))
		  } catch  {
				completion(.failure(.decodingError))
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
