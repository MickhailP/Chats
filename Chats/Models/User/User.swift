//
//  User.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import Foundation


struct User: Codable {

	 let phone, name, username: String

	 let birthday, city: String
	 let vk, instagram: String
	 let status, avatar: String
	 let id: Int
	 let last: String
	 let online: Bool
	 let created: String
	 let completedTask: Int
	 let avatars: Avatars
}

struct Avatars: Codable {
	 let avatar, bigAvatar, miniAvatar: String
}
