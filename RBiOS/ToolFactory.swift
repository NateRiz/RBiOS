//
//  ToolFactory.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class ToolFactory: NSObject {
    static var canvasBorderView: UIView?
    
    let toolCreationMapper: [Tool: ([Any]) -> BIToolContainerView] = [
        Tool.TEXTBOX: AddTextBox,
        Tool.IMAGE: AddImage
    ]
    
    static func SetCanvasBorderView(view: UIView){
        ToolFactory.canvasBorderView = view
    }
    
    static func AddTextBox(_: [Any]) -> BIToolContainerView{
        let label: BITextView = BITextView(frame: CGRect(x: 0, y: 0, width: 64, height: 32))
        label.text = "Text Box"
        let BITool = BIToolContainerView(child: label, parent: canvasBorderView!, frame: CGRect(x: 64, y: 32, width: 64, height: 32))
        return BITool
    }
    
    static func AddImage(args: [Any]) -> BIToolContainerView{
        let imageView = BIImageView(image: args[0] as? UIImage)
        let BITool = BIToolContainerView(child: imageView, parent: canvasBorderView!, frame: CGRect(x: 64, y: 96, width: 128, height: 128))
        imageView.frame.size = BITool.frame.size
        return BITool
    }
    
    func createTool(tool: Tool, args: [Any]) -> BIToolContainerView{
        return toolCreationMapper[tool]!(args) 
    }

    
}
