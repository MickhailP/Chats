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
