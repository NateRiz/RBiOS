//
//  ToolFactory.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class ToolFactory: NSObject {

    let toolCreationMapper: [Tool: ([Any]) -> UIView] = [
        Tool.TEXTBOX: AddTextBox,
        Tool.IMAGE: AddImage
    ]
    
    static func AddTextBox(_: [Any]) -> BITextView{
        let label: BITextView = BITextView(frame: CGRect(x: 64, y: 32, width: 64, height: 32))
        label.text = "Text Box"
        return label
    }
    
    static func AddImage(args: [Any]) -> UIView{
        let imageView = BIImageView(image: args[0] as? UIImage)
        imageView.frame = CGRect(x: 64, y: 96, width: 128, height: 128)
        return imageView
    }
    
    func createTool(tool: Tool, args: [Any]) -> UIView{
        return toolCreationMapper[tool]!(args) 
    }

    
}
