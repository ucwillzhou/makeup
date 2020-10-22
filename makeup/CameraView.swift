//
//  CameraView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @State private var isShowingImagePicker = false
    @State private var showCamera = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var bareFaceImage = UIImage()

    
    var body: some View {
        VStack() {
            
            Image(uiImage: bareFaceImage)
            .resizable()
            .scaledToFill()
                .frame(width:250, height: 250)
                .border(Color.black, width: 1)
                .clipped()
                .padding()
            
                HStack(spacing: 40) {
                    
                    Button(action: {
                        self.isShowingImagePicker.toggle()
                        self.sourceType = .photoLibrary
                        print("Upload was tapped")
                        
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 40.0))
                            .foregroundColor(.gray)
                    }
                        
                    .sheet(isPresented: $isShowingImagePicker, content: {
                        ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$bareFaceImage)
                    })
                    
                    Button(action: {
                        print("Camera Was Tapped")
                        self.sourceType = .camera
                        self.showCamera.toggle()
                    }) {
                        Image(systemName: "camera.circle")
                            .font(.system(size: 40.0))
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $showCamera, content: {
                        ImagePickerView(isPresented: self.$showCamera, selectedImage: self.$bareFaceImage)
                    })

            }
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    
    
    @Binding private var isPresented: Bool
    @Binding private var selectedImage: UIImage
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    
    func makeUIViewController(context:
        UIViewControllerRepresentableContext<ImagePickerView>) ->
        UIViewController {
        
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                print(selectedImageFromPicker)
                self.parent.selectedImage = selectedImageFromPicker
            }
            
            self.parent.isPresented = false
        }
        
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}

struct DummyView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<DummyView>) -> UIButton {
        let button = UIButton()
        button.setTitle("DUMMY", for: .normal)
        button.backgroundColor = .white
        return button
    }
    
    func updateUIView(_ uiView: DummyView.UIViewType, context: UIViewRepresentableContext<DummyView>) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

