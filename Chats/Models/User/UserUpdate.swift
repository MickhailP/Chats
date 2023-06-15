//
//  UserUpdate.swift
//  Chats
//
//  Created by Миша Перевозчиков on 15.06.2023.
//

import Foundation

struct UserUpdate: Codable {
	 let name, username, birthday, city: String
	 let vk, instagram, status: String
	 let avatar: Avatar
}

// MARK: - Avatar
struct Avatar: Codable {
	 let filename, base64: String
}
