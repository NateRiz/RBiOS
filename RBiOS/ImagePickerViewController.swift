//
//  ImagePickerViewController.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/9/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var image: UIImage?
    var parentView: AuthoringToolsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setParent(parentView: AuthoringToolsViewController){
        self.parentView = parentView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = nil
        if let possibleImage = info[.editedImage] as? UIImage {
            image = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            image = possibleImage
        } else {
            return
        }
        
        print("Uploading image to PBI: ", image!.size)
        
        self.parentView!.args.append(image as Any)
        print("Dis")
        self.dismiss(animated: true, completion: {
            self.parentView!.closeView()
        })

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
