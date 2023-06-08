//
//  AuthData.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct AuthData: Codable {
	 let refreshToken: String
	 let accessToken: String
	 let userID: Int
	 let isUserExists: Bool?
}
