//
//  NotFoundError.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct NotFoundError: Error, Decodable {
	 // StatusCode = 404
	 let message: String
}
