//
//  Endpoints.swift
//  Chats
//
//  Created by Миша Перевозчиков on 09.06.2023.
//

import Foundation

enum Endpoint {
	 case sendAuthCode
	 case checkAuthCode
	 case register
	 case userInfo
	 case refreshToken
	 case checkJWT
}


extension Endpoint {

	 var scheme: String { "https" }

	 var host: String { "plannerok.ru" }

	 var path: String {
		  switch self {
				case .sendAuthCode:
					return "/api/v1/users/send-auth-code/"
				case .checkAuthCode:
				return "api/v1/users/check-auth-code/"
				case .register:
					 return "/api/v1/users/register/"
				case .userInfo:
					 return "/api/v1/users/me/"
				case .refreshToken:
					 return "/api/v1/users/refresh-token/"
				case .checkJWT:
					 return "/api/v1/users/check-jwt/"
		  }
	 }

	 var queryItems: [String: String]? {
		  nil
	 }
}


extension Endpoint {
	 var url: URL? {
		  var components = URLComponents()
		  components.scheme = scheme
		  components.host = host
		  components.path = path

		  let queryItems = queryItems?.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }

		  components.queryItems = queryItems

		  return components.url
	 }
}
