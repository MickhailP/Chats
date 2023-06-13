//
//  User.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import Foundation


struct User: Codable {

	 let phone, name, username: String

	 let birthday, city: String?
	 let vk, instagram: String?
	 let status, avatar: String?
	 let id: Int?
	 let last: String?
	 let online: Bool?
	 let created: String?
	 let completedTask: Int?
	 let avatars: Avatars?

	 
	 init(phone: String, name: String, username: String, birthday: String? = nil, city: String? = nil, vk: String? = nil, instagram: String? = nil, status: String? = nil, avatar: String? = nil, id: Int? = nil, last: String? = nil, online: Bool? = nil, created: String? = nil, completedTask: Int? = nil, avatars: Avatars? = nil) {
		  self.phone = phone
		  self.name = name
		  self.username = username
		  self.birthday = birthday
		  self.city = city
		  self.vk = vk
		  self.instagram = instagram
		  self.status = status
		  self.avatar = avatar
		  self.id = id
		  self.last = last
		  self.online = online
		  self.created = created
		  self.completedTask = completedTask
		  self.avatars = avatars
	 }
}

struct Avatars: Codable {
	 let avatar, bigAvatar, miniAvatar: String
}

extension User {
	 static let example = User(phone: "+1232122313", name: "Bron Joksa", username: "qweo123Joas", birthday: "2023-06-13", city: "Moscow", vk: "https://m.vk.com", instagram: "https://m.vk.com", status: "Lsoada ewrads asdeqr dqrqrq", avatar: "https://kartinkived.ru/wp-content/uploads/2021/12/avatarka-dlya-vatsapa-marshmellou.jpg", id: 12312, last: "2023-06-13T19:02:55.492Z", online: true, created: "2023-06-13T19:02:55.492Z", completedTask: 100, avatars: Avatars(avatar: "", bigAvatar: "", miniAvatar: ""))
}
