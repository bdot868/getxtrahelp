//
//  DocumentPicker.swift
//  SherApp
//
//  Created by Wdev3 on 20/01/21.
//  Copyright © 2021 Wdev3. All rights reserved.
//

import UIKit
import MobileCoreServices
//import UniformTypeIdentifiers

class DocumentPicker: NSObject,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    var viewController: UIViewController?
    var handler:((URL)->())?
    
    public func openDocumentPicker(pickerHandler:@escaping(URL)->()){
        handler = pickerHandler
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF as String)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
       
        viewController?.present(importMenu, animated: true, completion: nil)
    }

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        print("import result : \(myURL)")
        //let size = SherApp.shared.fileSize(forURL: myURL)
        if (self.handler != nil){
            self.handler!(myURL)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true, completion: nil)
    }
}
