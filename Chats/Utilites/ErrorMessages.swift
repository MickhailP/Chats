//
//  ErrorMessages.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


enum ErrorMessage: String, Error {
	 case badURl = "URL is invalid"
	 case invalidData = "Data is missing"
	 case badRequest = "Request is not correct"

	 case verificationError = "Phone number didn't verified"
	 case phoneNumberMissing = "Phone number is missed"

	 case encodingError = "Encoding error"
	 case decodingError = "Decoding error"

	 case unableFetchFromDataBase = "Failed to load data from storage."
	 case authDataIsMissing = "Failed to load auth data"

	 case tokenIsMissing = "Token is missing"

	 case unableConvertImageData = "Failed to convert image for uploading format"

	 case unknown = "Unknown error"
}
