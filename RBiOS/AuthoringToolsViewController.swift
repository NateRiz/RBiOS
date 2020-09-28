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

class AuthoringToolsViewController: UIViewController {

    var selectedTool: Tool = Tool.NONE
    var args = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        args.removeAll()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectToolBox(_ sender: Any) {
        selectedTool = Tool.TEXTBOX
        closeView()
    }
    
    @IBAction func selectImage(_ sender: Any) {
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
}
