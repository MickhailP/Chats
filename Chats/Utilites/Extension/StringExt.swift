//
//  StringExt.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.06.2023.
//

import Foundation

extension String {

	 func isValidUserName() -> Bool {
		  let stringFormat = "^[A-Za-z0-9-_]{5,}$"
		  let stringPredicate = NSPredicate(format: "SELF MATCHES %@", stringFormat)
		  return stringPredicate.evaluate(with: self)
	 }
}
