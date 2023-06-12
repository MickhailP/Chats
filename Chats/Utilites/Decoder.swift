//
//  Decoder.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


class Decoder {

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
}
