//
//  ImagePicker.swift
//  Chats
//
//  Created by Миша Перевозчиков on 14.06.2023.
//

import PhotosUI
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {

	 @Binding var image: UIImage?
	 @Binding var imageName: String?

	 func makeUIViewController(context: Context) -> PHPickerViewController {
		  var config = PHPickerConfiguration()
		  config.filter = .images

		  let picker = PHPickerViewController(configuration: config)

		  picker.delegate = context.coordinator
		  return picker
	 }

	 func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

	 }

	 func makeCoordinator() -> Coordinator {
		  Coordinator(self)
	 }
}


//MARK: - Coordinator
final class Coordinator: NSObject, PHPickerViewControllerDelegate {

	 var parent: ImagePicker

	 init(_ parent: ImagePicker) {
		  self.parent = parent
	 }

	 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		  picker.dismiss(animated: true)

		  guard let provider = results.first?.itemProvider else { return }

		  if provider.canLoadObject(ofClass: UIImage.self) {
				provider.loadObject(ofClass: UIImage.self) { image, _ in
					 self.parent.image = image as? UIImage

					 let assetIdentifier = results.first?.assetIdentifier
					 let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier ?? ""], options: nil)
					 if let asset = assetResult.firstObject {
						  let imageName = PHAssetResource.assetResources(for: asset).first?.originalFilename
						  self.parent.imageName = imageName
					 }
				}
		  }
	 }
}
