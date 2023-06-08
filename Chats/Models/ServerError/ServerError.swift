//
//  ServerError.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation

struct ServerError: LocalizedError, Codable {
	 public var code: Int
	 public var error: String?

	 public var errorDescription: String? {
		  return error
	 }
}
