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

	 func convertToDate() -> Date? {
		  let dateFormatter = DateFormatter()
		  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		  if let date = dateFormatter.date(from: self) {
				return date
		  } else {
				return nil
		  }
	 }

	 func convertFromDashedDate() -> Date? {
		  let dateFormatter = DateFormatter()
		  dateFormatter.dateFormat = "yyyy-MM-dd"

		  if let date = dateFormatter.date(from: self) {
				return date
		  } else {
				return nil
		  }
	 }
}
