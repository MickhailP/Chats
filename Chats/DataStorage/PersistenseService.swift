//
//  PersistenceService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 16.06.2023.
//

import Foundation

final class PersistenceService {

	 static private let defaults = UserDefaults.standard

	 enum SaveKeys {
		  static let user = "com.Chats/user"
	 }


	 static func fetchUser(by phone: String) -> User? {
		  
		  guard let fetched = defaults.data(forKey: SaveKeys.user + phone) else {
				return nil
		  }

		  guard let user: User = DataDecoder.decode(fetched) else {
				return nil
		  }
		  return user
	 }
	 

	 static func save(user: User) throws {
		  do {
				let encoded = try JSONEncoder().encode(user)
				UserDefaults.standard.set(encoded, forKey: SaveKeys.user + user.phone)

		  } catch  {
				throw ErrorMessage.encodingError
		  }
	 }
}
