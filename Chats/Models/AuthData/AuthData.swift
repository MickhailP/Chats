//
//  AuthData.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct AuthData: Codable {
	 let date: Date

	 let refreshToken, accessToken: String?
	 let userID: Int?
	 let isUserExists: Bool?
}


//MARK: - Codable
extension AuthData {

	 enum CodingKeys: String, CodingKey {
		  case date
		  case refreshToken
		  case accessToken
		  case userID
		  case isUserExists
	 }

	 init(from decoder: Decoder) throws {
		  let container = try decoder.container(keyedBy: CodingKeys.self)
		  date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date.now
		  refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
		  accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
		  userID = try container.decodeIfPresent(Int.self, forKey: .userID)
		  isUserExists = try container.decodeIfPresent(Bool.self, forKey: .isUserExists)
	 }

	 func encode(to encoder: Encoder) throws {
		  var container = encoder.container(keyedBy: CodingKeys.self)
		  try container.encode(date, forKey: .date)
		  try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
		  try container.encodeIfPresent(accessToken, forKey: .accessToken)
		  try container.encodeIfPresent(userID, forKey: .userID)
		  try container.encodeIfPresent(isUserExists, forKey: .isUserExists)
	 }
}
