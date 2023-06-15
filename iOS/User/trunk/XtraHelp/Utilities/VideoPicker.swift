//
//  VideoPicker.swift
//  FitnessDiary
//
//  Created by Harshad on 17/06/20.
//  Copyright © 2020 Harshad. All rights reserved.
//

import UIKit

class VideoPicker: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var imgName: String?
    var handler:((NSData,URL)->())?
    var picker = UIImagePickerController()
    var viewController: UIViewController?
    var isAllowsEditing: Bool = true {
        didSet {
            self.setAllowsEditing()
        }
    }
    
    override init() {
        super.init()
        
        picker = UIImagePickerController.init()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    func setAllowsEditing() {
        picker.allowsEditing = isAllowsEditing
    }
    
    func pickImage(_ sender:Any,Title : String,pickerHandler:@escaping(NSData,URL)->()) {
        
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
                
                
                let actionSheet = UIAlertController.init(title: Title, message: nil, preferredStyle: .actionSheet)
                let camera = UIAlertAction.init(title: "Take Video", style: .default) { (action) in
                    self.takeVideo()
                }
                let library = UIAlertAction.init(title: "Choose Video", style: .default) { (action) in
                    self.chooseVideo()
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
    
    func takeVideo() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.mediaTypes = ["public.movie"]
            picker.allowsEditing = true
            picker.videoMaximumDuration = 60
            let vc = UIApplication.topViewController(base: self.viewController)
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    func chooseVideo() {
        DispatchQueue.main.async {
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = ["public.movie"]
            self.picker.allowsEditing = true
            self.picker.videoMaximumDuration = 60
            self.viewController?.present(self.picker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        /*let image: UIImage!
        if picker.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        } else {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if #available(iOS 11.0, *) {
            if let imgname = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                imgName = imgname.lastPathComponent
            } else {
                /*saveImage(image: image) { (error) in
                 print(error ?? "Error while saving the image captured from camera.")
                 }*/
            }
        } else {
            // Fallback on earlier versions
        }*/
        if let fileURL =  info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            do {
                let video = try NSData(contentsOf: fileURL, options: .mappedIfSafe)
                print("movie saved")
                picker.dismiss(animated: true) {
                    if (self.handler != nil){
                        self.handler!(video, fileURL)
                    }
                }
            } catch {
                print(error)
            }
        } else {
            picker.dismiss(animated: true) {
                
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

