//
//  ImagePickerView.swift
//  PontoCom
//
//  Created by levi soares on 14/08/24.
//

import SwiftUI
 
struct ImagePickerView: UIViewControllerRepresentable {
 
    @Binding var image: UIImage?
 
    private let controller = UIImagePickerController()
 
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
 
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
        let parent: ImagePickerView
 
        init(parent: ImagePickerView) {
            self.parent = parent
        }
 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
 
    }
 
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
 
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
 
    }
 
}
