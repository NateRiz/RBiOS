//
//  AuthoringToolsViewController.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

enum Tool {
    case NONE
    case TEXTBOX
    case IMAGE
}

class AuthoringToolsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cells = [String: () -> Void]()
    var selectedTool: Tool = Tool.NONE
    var args = [Any]()
    var toolNames = ["Text Box", "Image"]
    var imageMap = ["Text Box":"textbox", "Image":"photo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cells["Text Box"] = _selectToolBox
        cells["Image"] = _selectImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        args.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthoringToolCell", for: indexPath as IndexPath) as! AuthoringToolsCollectionViewCell
        
        let name = self.toolNames[indexPath.row]
        cell.label.text = name
        if #available(iOS 13.0, *) { cell.icon.image = UIImage(systemName: imageMap[name]!)}
        else { /* Fallback on earlier versions */ }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cells[toolNames[indexPath.row]]!()
    }
    
    
    func _selectToolBox(){
        selectedTool = Tool.TEXTBOX
        closeView()
    }
    
    func _selectImage() {
        selectedTool = Tool.IMAGE
        let vc = ImagePickerViewController()
        vc.setParent(parentView: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    func resetSelectedTool() {
        selectedTool = Tool.NONE
    }
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        closeView()
    }
}
