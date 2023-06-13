//
//  AuthData.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct AuthData: Codable {
	 let refreshToken, accessToken: String?
	 let userID: Int?
	 let isUserExists: Bool?

	 enum CodingKeys: String, CodingKey {
		  case refreshToken
		  case accessToken
		  case userID
		  case isUserExists
	 }
}

extension AuthData {
	 static func encoded(data: AuthData) -> String? {
		  do {
				let credentialsData = try JSONEncoder().encode(data)
				return String(data: credentialsData, encoding: .utf8)!
		  } catch  {
				print(error)
				return nil
		  }
	 }

	 static func decode(_ credentialsString: String) -> Self? {
		  let jsonData = credentialsString.data(using: .utf8)
		  do {
				return try JSONDecoder().decode((Self.self), from: jsonData!)
		  } catch {
				return nil
		  }
	 }
}
