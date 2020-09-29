//
//  PropertiesPaneView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/6/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class PropertiesPaneView: UIView, UITextFieldDelegate{

    var selectedTool: BIToolContainerView?
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var xInput: UITextField!
    @IBOutlet weak var yInput: UITextField!
    @IBOutlet weak var zInput: UITextField!
    @IBOutlet weak var widthInput: UITextField!
    @IBOutlet weak var heightInput: UITextField!
    
    //Properties specific to each BITool
    @IBOutlet weak var fontBuffer: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontStack: UIStackView!
    @IBOutlet weak var fontSizeInput: UITextField!
    @IBOutlet weak var boldLabel: UIButton!
    @IBOutlet weak var italicsLabel: UIButton!
    var textView: BITextView?
    
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        xInput.delegate = self
        yInput.delegate = self
        zInput.delegate = self
        widthInput.delegate = self
        heightInput.delegate = self
        fontSizeInput.delegate = self
        boldLabel.layer.borderWidth = 1
        italicsLabel.layer.borderWidth = 1
    }
    
    func setSelectedTool(selected: BIToolContainerView){
        selectedTool = selected
        title.text = "\((selected.childView as! BITool).name) Properties"
        resetProperties()
        if selected.childView! is BITextView { setupTextViewProperties() }
    }
    
    func resetProperties(){
        fontBuffer.isHidden = true
        fontLabel.isHidden = true
        fontStack.isHidden = true
        updatePosition()
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
    
    func setupTextViewProperties(){
        textView = selectedTool!.childView as? BITextView
        fontBuffer.isHidden = false
        fontLabel.isHidden = false
        fontStack.isHidden = false
        fontSizeInput.text = String(format: "%.0f", (selectedTool!.childView! as! UITextView).font!.pointSize)
        if textView!.font!.fontDescriptor.symbolicTraits.contains(.traitBold){
            boldLabel.layer.borderColor = UIColor.black.cgColor
        }
        else{
            boldLabel.layer.borderColor = UIColor.white.cgColor
        }
        if textView!.font!.fontDescriptor.symbolicTraits.contains(.traitItalic){
            italicsLabel.layer.borderColor = UIColor.black.cgColor
        }
        else{
            italicsLabel.layer.borderColor = UIColor.white.cgColor
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTextFields(textField)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFields(textField)
    }
    
    func updateTextFields(_ textField: UITextField){
        guard let tool = selectedTool else {return}
        tool.setX(x: CGFloat(truncating: NumberFormatter().number(from: xInput.text!) ?? 0) * UIScreen.pointsPerInch!)
        tool.setY(y: CGFloat(truncating: NumberFormatter().number(from: yInput.text!) ?? 0) * UIScreen.pointsPerInch!)
        tool.setWidth(w: CGFloat(truncating: NumberFormatter().number(from: widthInput.text!) ?? 0) * UIScreen.pointsPerInch!)
        tool.setHeight(h: CGFloat(truncating: NumberFormatter().number(from: heightInput.text!) ?? 0) * UIScreen.pointsPerInch!)
        if let textView = selectedTool!.childView! as? BITextView{
            if let fontSize = NumberFormatter().number(from: fontSizeInput.text!) {
                textView.font = textView.font?.withSize(CGFloat(truncating: fontSize))
                textView.textViewDidChange(textView)
            }
        }
        
    }

    @IBAction func deleteTool(_ sender: Any) {
        (parentViewController as! CanvasViewController).deleteSelectedTool()
    }
    
    @IBAction func setTextBold(_ sender: Any) {
        if textView!.font!.fontDescriptor.symbolicTraits.contains(.traitBold){
            textView!.font = textView!.font!.without(.traitBold)
            boldLabel.layer.borderColor = UIColor.white.cgColor
        }
        else {
            textView!.font = textView!.font!.with(.traitBold)
            boldLabel.layer.borderColor = UIColor.black.cgColor

        }
        textView!.textViewDidChange(textView!)
    }
    @IBAction func setTextItalics(_ sender: Any) {
        if textView!.font!.fontDescriptor.symbolicTraits.contains(.traitItalic){
            textView!.font = textView!.font!.without(.traitItalic)
            italicsLabel.layer.borderColor = UIColor.white.cgColor
        }
        else {
            textView!.font = textView!.font!.with(.traitItalic)
            italicsLabel.layer.borderColor = UIColor.black.cgColor
        }
        textView!.textViewDidChange(textView!)
    }
    
}
