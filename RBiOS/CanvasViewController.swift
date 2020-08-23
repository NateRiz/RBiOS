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
    
    var canvasUIElements = [BIToolContainerView]()
    var selectedView: BIToolContainerView?
    var toolFactory: ToolFactory = ToolFactory()
    var authoringToolsView = AuthoringToolsViewController()
    var rdlExporter = RDLExporter()
    let drawableCanvasView = DrawableCanvasView()
    var canvasBorderView = CanvasBorderView()

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
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setSelectedTool(selectedView: nil)
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
        }
        
        for ui in canvasUIElements{
            if selectedView == nil || ui != selectedView{
                ui.resetSelectedTool()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
}



/*
 TODO
 - dragging shouldnt allow bitools to go above toolbar
 - login
 - datasets
 - menu on select ( delete, font, size, etc)
 - export rdl to file
 - ruler grid lines
*/

