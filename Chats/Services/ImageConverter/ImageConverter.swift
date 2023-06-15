//
//  ImageConverter.swift
//  Chats
//
//  Created by Миша Перевозчиков on 15.06.2023.
//

import Foundation
import UIKit


final class ImageConverter {

	 func convertBase64ToImage(base64String: String?) -> UIImage? {
		  if let base64String,
			  let imageData = Data(base64Encoded: base64String) {
				return UIImage(data: imageData)
		  }
		  return nil
	 }


	 func convertImageToBase64String(img: UIImage) -> String? {
		  if let imageData = img.jpegData(compressionQuality: 1)?.base64EncodedString() {
				return imageData
		  }
		  return nil
	 }
}
