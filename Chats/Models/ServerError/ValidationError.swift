//
//  ValidationError.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct ValidationError: Error, Decodable {
	 // Status code 422

	 let detail: [Detail]
}

struct Detail: Decodable {
	 let loc: [String]
	 let msg, type: String
}
