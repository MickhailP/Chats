//
//  Decoder.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


final class DataDecoder {

	class func decode<T: Decodable> (_ data: Data) -> T? {

		  let decoder = JSONDecoder()
		  decoder.keyDecodingStrategy = .convertFromSnakeCase

		 do {
			  let decoded = try decoder.decode(T.self, from: data)
			  return decoded
		 } catch {
			  print(error)
			  print(error.localizedDescription)
			  return nil
		 }
	 }

	 func convertObjectToJSON<T: Encodable>(_ object: T) -> Data? {
		  let encoder = JSONEncoder()
		  encoder.outputFormatting = .prettyPrinted

		  do {
				let jsonData = try encoder.encode(object)
				return jsonData
		  } catch {
				print("Failed to convert object to JSON: \(error.localizedDescription)")
				return nil
		  }
	 }
}
