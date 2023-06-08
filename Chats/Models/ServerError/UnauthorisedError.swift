//
//  UnauthorisedError.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct UnauthorisedError: Error, Codable {
	 // Status code 401
	 let detail, body: String
}
