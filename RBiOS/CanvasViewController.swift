//
//  CanvasViewController.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var propertiesPane: PropertiesPaneView!

    var canvasUIElements = [BIToolContainerView]()
    var selectedView: BIToolContainerView?
    var toolFactory: ToolFactory = ToolFactory()
    var authoringToolsView = AuthoringToolsViewController()
    var rdlExporter = RDLExporter()
    let drawableCanvasView = UIView()
    var canvasBorderView = CanvasBorderView()
    let snapVerticalLine = LineView(frame: CGRect(x: 0, y: 0, width: 1, height: UIScreen.main.bounds.size.height), isVertical: true)
    let snapHorizontalLine = LineView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1), isVertical: false)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        authoringToolsView = self.storyboard?.instantiateViewController(withIdentifier: "AuthoringToolsVC") as! AuthoringToolsViewController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.canvasBorderView = CanvasBorderView(canvas: drawableCanvasView)
        self.view.addSubview(canvasBorderView)
        self.canvasBorderView.translatesAutoresizingMaskIntoConstraints = false
        canvasBorderView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        canvasBorderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        canvasBorderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        canvasBorderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bringSubviewToFront(propertiesPane)
        self.view.addSubview(snapVerticalLine)
        self.view.addSubview(snapHorizontalLine)
        self.view.bringSubviewToFront(snapVerticalLine)
        self.view.bringSubviewToFront(snapHorizontalLine)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setSelectedTool(selectedView: nil)
        propertiesPane.isHidden = true
    }
    
    func addSelectedToolToCanvas(tool: Tool, args: [Any]) {
        if tool == Tool.NONE { return }
        let createdUIElement: BIToolContainerView = toolFactory.createTool(tool: tool, args: args)
        canvasUIElements.append(createdUIElement)
        self.drawableCanvasView.addSubview(createdUIElement)
    }
    
    func setSelectedTool(selectedView: BIToolContainerView?){
        if let selectedUI = selectedView{
            self.selectedView = selectedUI
            propertiesPane.setSelectedTool(selected: selectedUI)
            propertiesPane.isHidden = false
        }
        
        for ui in canvasUIElements{
            if selectedView == nil || ui != selectedView{
                ui.resetSelectedTool()
            }
        }
    }
    
    @IBAction func openAuthoringTools(_ sender: Any) {
        self.present(authoringToolsView, animated: true, completion: nil)
    }
    
    @IBAction func Export(_ sender: Any) {
        rdlExporter.generate(ui: canvasUIElements)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addSelectedToolToCanvas(tool: authoringToolsView.selectedTool, args: authoringToolsView.args)
        authoringToolsView.resetSelectedTool()
        print(authoringToolsView.selectedTool)
    }
    
    func deleteSelectedTool(){
        propertiesPane.isHidden = true
        canvasUIElements.remove(at: canvasUIElements.firstIndex(of: selectedView!)! )
        selectedView!.removeFromSuperview()
    }
    
    func updateToolPosition(){
        guard let selected = self.selectedView else {return}
        snapToCanvasElements(selected: selected)
        self.canvasBorderView.updateToolPosition(x: selected.frame.minX, y: selected.frame.minY)
    }
    
    func snapToCanvasElements(selected: BIToolContainerView){
        let marginToSnap: CGFloat = 6
        func closeEnoughToSnap(a: CGFloat, b: CGFloat) -> Bool {return abs(a-b) <= marginToSnap}
        let minX = selected.frame.minX
        let maxX = selected.frame.maxX
        let minY = selected.frame.minY
        let maxY = selected.frame.maxY
        
        var snappedVertical: BIToolContainerView?
        var vSnapLeft: Bool = false
        var snappedHorizontal: BIToolContainerView?
        var hSnapTop: Bool = false
        
        for ui in canvasUIElements{
            if ui == selected {continue}
            if(snappedVertical == nil){
                if (closeEnoughToSnap(a: minX, b: ui.frame.minX)){selected.frame.origin.x = ui.frame.minX; snappedVertical = ui; vSnapLeft = true}
                if (closeEnoughToSnap(a: minX, b: ui.frame.maxX)){selected.frame.origin.x = ui.frame.maxX; snappedVertical = ui; vSnapLeft = true}
                if (closeEnoughToSnap(a: maxX, b: ui.frame.minX)){selected.frame.origin.x = ui.frame.minX-selected.frame.width; snappedVertical = ui; vSnapLeft = false}
                if (closeEnoughToSnap(a: maxX, b: ui.frame.maxX)){selected.frame.origin.x = ui.frame.maxX-selected.frame.width; snappedVertical = ui; vSnapLeft = false}
            }
            if(snappedHorizontal == nil){
                if (closeEnoughToSnap(a: minY, b: ui.frame.minY)){selected.frame.origin.y = ui.frame.minY; snappedHorizontal = ui; hSnapTop = true}
                if (closeEnoughToSnap(a: minY, b: ui.frame.maxY)){selected.frame.origin.y = ui.frame.maxY; snappedHorizontal = ui; hSnapTop = true}
                if (closeEnoughToSnap(a: maxY, b: ui.frame.minY)){selected.frame.origin.y = ui.frame.minY-selected.frame.height; snappedHorizontal = ui; hSnapTop = false}
                if (closeEnoughToSnap(a: maxY, b: ui.frame.maxY)){selected.frame.origin.y = ui.frame.maxY-selected.frame.height; snappedHorizontal = ui; hSnapTop = false}
            }
        }
        
        snapVerticalLine.isHidden = true
        snapHorizontalLine.isHidden = true
        
        if let ui = snappedVertical{
            print(selected.frame, ui.frame, vSnapLeft, selected.frame.minX, max(selected.frame.midY, ui.frame.midY), abs(ui.frame.midY-selected.frame.midY))
            snapVerticalLine.isHidden = false
            let x = CanvasBorderView.canvasOffset + (vSnapLeft ? selected.frame.minX : selected.frame.maxX)
            let y = CanvasBorderView.canvasOffset * 2 + navBar.frame.height + min(selected.frame.midY, ui.frame.midY)
            snapVerticalLine.frame = CGRect(x: x, y: y, width: 1, height: abs(ui.frame.midY-selected.frame.midY))
        }
        if let ui = snappedHorizontal{
            snapHorizontalLine.isHidden = false
            let x = CanvasBorderView.canvasOffset + min(selected.frame.midX, ui.frame.midX)
            let y = CanvasBorderView.canvasOffset * 2 + navBar.frame.height + (hSnapTop ? selected.frame.minY : selected.frame.maxY)
            snapHorizontalLine.frame = CGRect(x: x, y: y, width: abs(ui.frame.midX-selected.frame.midX), height: 1)
        }
    }
}



/*
 TODO
 - login
 - datasets
 - menu on select ( delete, font, size, etc)
 - export rdl to file
 - ruler grid lines
*/

