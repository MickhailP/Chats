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

	 static func getCredentials() -> AuthData? {
		  if let myCredentialsString = KeychainWrapper.standard.string(forKey: Self.key) {
				return AuthData.Decoder.decode(myCredentialsString)
		  } else {
				return nil
		  }
	 }

	 static func saveCredentials(_ credentials: AuthData) -> Bool {
		  if KeychainWrapper.standard.set(Decoder.encode(credentials), forKey: Self.key) {
				return true
		  } else {
				return false
		  }
	 }
}
