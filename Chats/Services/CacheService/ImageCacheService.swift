//
//  ImageCacheService.swift
//  Chats
//
//  Created by Миша Перевозчиков on 11.05.2023.
//

import Foundation
import UIKit

final class ImageCacheService {

	static let shared = ImageCacheService()
	private init () { }


	private var imageCache: NSCache<NSString, UIImage> = {
		var cache = NSCache<NSString, UIImage>()
		cache.countLimit = 200
		cache.totalCostLimit = 1024 * 1024 * 100 //100 MB
		return cache
	}()


	func add(key: String, value: UIImage) {
		imageCache.setObject(value, forKey: key as NSString)
	}


	func get(key: String) -> UIImage? {
		imageCache.object(forKey: key as NSString)
	}


	func clearImageCache() {
		imageCache.removeAllObjects()
		print("cache cleared")
	}
}

