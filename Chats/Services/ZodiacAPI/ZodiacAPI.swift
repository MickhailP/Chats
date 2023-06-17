//
//  ZodiacAPI.swift
//  Chats
//
//  Created by Миша Перевозчиков on 17.06.2023.
//

import Foundation

final class ZodiacAPI {
	 static func getZodiacSign(for date: Date) -> ZodiacSign? {
		  let calendar = Calendar.current
		  let month = calendar.component(.month, from: date)
		  let day = calendar.component(.day, from: date)

		  guard let sign = ZodiacSign(rawValue: (month, day)) else {
				return nil
		  }

		  return sign
	 }
}


//MARK: - ZodiacSign
enum ZodiacSign: String {
	 case aquarius = "♒️"
	 case pisces = "♓️"
	 case aries = "♈️"
	 case taurus = "♉️"
	 case gemini = "♊️"
	 case cancer = "♋️"
	 case leo = "♌️"
	 case virgo = "♍️"
	 case libra = "♎️"
	 case scorpio = "♏️"
	 case sagittarius = "♐️"
	 case capricorn = "♑️"

	 init?(rawValue: (Int, Int)) {
		  let (month, day) = rawValue

		  switch month {
				case 1:
					 if day >= 20 { self = .aquarius }
					 else { self = .capricorn }
				case 2:
					 if day >= 19 { self = .pisces }
					 else { self = .aquarius }
				case 3:
					 if day >= 21 { self = .aries }
					 else { self = .pisces }
				case 4:
					 if day >= 20 { self = .taurus }
					 else { self = .aries }
				case 5:
					 if day >= 21 { self = .gemini }
					 else { self = .taurus }
				case 6:
					 if day >= 21 { self = .cancer }
					 else { self = .gemini }
				case 7:
					 if day >= 23 { self = .leo }
					 else { self = .cancer }
				case 8:
					 if day >= 23 { self = .virgo }
					 else { self = .leo }
				case 9:
					 if day >= 23 { self = .libra }
					 else { self = .virgo }
				case 10:
					 if day >= 23 { self = .scorpio }
					 else { self = .libra }
				case 11:
					 if day >= 22 { self = .sagittarius }
					 else { self = .scorpio }
				case 12:
					 if day >= 22 { self = .capricorn }
					 else { self = .sagittarius }
				default:
					 return nil
		  }
	 }
}


//MARK: - ZodiacName
extension ZodiacSign {

	 var zodiacName: String {
		  switch self {
				case .aquarius: return "Aquarius"
				case .pisces: return "Pisces"
				case .aries: return "Aries"
				case .taurus: return "Taurus"
				case .gemini: return "Gemini"
				case .cancer: return "Cancer"
				case .leo: return "Leo"
				case .virgo: return "Virgo"
				case .libra: return "Libra"
				case .scorpio: return "Scorpio"
				case .sagittarius: return "Sagittarius"
				case .capricorn: return "Capricorn"
		  }
	 }
}
