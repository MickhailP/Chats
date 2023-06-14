//
//  DateExt.swift
//  Chats
//
//  Created by Миша Перевозчиков on 14.06.2023.
//

import Foundation

extension Date {

	 func convertToDayMonthTimeFormat() -> String {
		  let dateFormatter = DateFormatter()
		  dateFormatter.dateFormat = "d MMM, h:mm"

		  return dateFormatter.string(from: self)
	 }

	 func convertToShortDate() -> String {
		  let dateFormatter = DateFormatter()
		  dateFormatter.dateFormat = "dd.MM.yy"

		  return dateFormatter.string(from: self)
	 }
}


