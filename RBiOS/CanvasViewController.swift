//
//  CanvasViewController.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {


    var canvasUIElements = [BIToolContainerView]()
    var selectedView: BIToolContainerView?
    let toolFactory: ToolFactory = ToolFactory()
    var authoringToolsView = AuthoringToolsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        authoringToolsView = self.storyboard?.instantiateViewController(withIdentifier: "AuthoringToolsVC") as! AuthoringToolsViewController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
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
        self.view.addSubview(createdUIElement)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addSelectedToolToCanvas(tool: authoringToolsView.selectedTool, args: authoringToolsView.args)
        authoringToolsView.resetSelectedTool()
        print(authoringToolsView.selectedTool)
    }
}

/*
 TODO
 -Create view to sit on top of BITools that send touch callbacks to normal controllers
 -dragging shouldnt snap to middle
 -dragging shouldnt allow bitools to go above toolbar
 -resizing should be smoother
*/
