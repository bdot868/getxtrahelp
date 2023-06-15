//
//  ImagePicker.swift
//  Shift
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 Differenz System. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePicker: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var imgName: String?
    var handler:((UIImage,URL?)->())?
    var picker = UIImagePickerController()
    var viewController: UIViewController?
    var isAllowsEditing: Bool = true {
        didSet {
            self.setAllowsEditing()
        }
    }
    var selectedUrl: URL?
    
    override init() {
        super.init()
        
        picker = UIImagePickerController.init()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    func setAllowsEditing() {
        picker.allowsEditing = isAllowsEditing
    }
    
    func pickImage(_ sender:Any,_ pickertitle : String,pickerHandler:@escaping(UIImage,URL?)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //self.choosePhoto()
                let actionSheet = UIAlertController.init(title: pickertitle, message: nil, preferredStyle: .actionSheet)
                let camera = UIAlertAction.init(title: "Take Photo", style: .default) { (action) in
                    self.takePhoto()
                }
                let library = UIAlertAction.init(title: "Choose Photo", style: .default) { (action) in
                    self.choosePhoto()
                }
                let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                    
                }
                
                actionSheet.addAction(camera)
                actionSheet.addAction(library)
                actionSheet.addAction(cancel)
                
                if let popoverController = actionSheet.popoverPresentationController {
                    if let view = sender as? UIView {
                        popoverController.sourceView = view
                        popoverController.sourceRect = view.bounds
                    }
                }
                self.viewController?.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    func pickImageFromCamera(_ sender:Any,pickerHandler:@escaping(UIImage,URL?)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.takePhoto()
            }
        }
    }
    func pickImageFromGallary(_ sender:Any,pickerHandler:@escaping(UIImage,URL?)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.choosePhoto()
            }
        }
    }
    
    func takePhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            let vc = UIApplication.topViewController(base: self.viewController)
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    func choosePhoto() {
        DispatchQueue.main.async {
            self.picker.sourceType = .photoLibrary
            self.viewController?.present(self.picker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        } else {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if #available(iOS 11.0, *) {
            if let imgname = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                imgName = imgname.lastPathComponent
                self.selectedUrl = imgname
            } else {
                
                let imgName = UUID().uuidString
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)

                if  let data = image.jpegData(compressionQuality: 0.6) as? NSData {
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    print(photoURL)
                    self.selectedUrl = photoURL
                }
                /*saveImage(image: image) { (error) in
                    print(error ?? "Error while saving the image captured from camera.")
                }*/
            }
        } else {
            // Fallback on earlier versions
        }
        
        picker.dismiss(animated: true) {
            if (self.handler != nil){
                if let myurl = self.selectedUrl {
                    self.handler!(image, myurl)
                } else {
                    self.handler!(image, nil)
                }
            }
        }
    }
    
    func saveImage(image: UIImage, completion: @escaping (Error?) -> ()) {
       UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(path:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        debugPrint(path) // That's the path you want
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
        }
    }
}
