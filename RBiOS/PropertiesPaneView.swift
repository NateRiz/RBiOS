//
//  PropertiesPaneView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/6/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class PropertiesPaneView: UIView, UITextFieldDelegate {

    var selectedTool: BIToolContainerView?
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var xInput: UITextField!
    @IBOutlet weak var yInput: UITextField!
    @IBOutlet weak var zInput: UITextField!
    @IBOutlet weak var widthInput: UITextField!
    @IBOutlet weak var heightInput: UITextField!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setSelectedTool(selected: BIToolContainerView){
        selectedTool = selected
        title.text = "\((selected.childView as! BITool).name) Properties"
        
    }
    
    func updatePosition(){
        guard let _ = selectedTool else { return }
        let (x, y) = selectedTool!.getCanvasPositon()
        let (w, h) = selectedTool!.getCanvasSize()
        xInput.text = String(format: "%.3f", x)
        yInput.text = String(format: "%.3f", y)
        zInput.text = "0"
        widthInput.text = String(format: "%.3f", w)
        heightInput.text = String(format: "%.3f", h)
    }
}
