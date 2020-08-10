//
//  ToolFactory.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class ToolFactory: NSObject {

    let toolCreationMapper: [Tool: () -> UIView] = [
        Tool.TEXTBOX: AddTextBox
    ]
    
    static func AddTextBox() -> BITextView{
        let label: BITextView = BITextView(frame: CGRect(x: 64, y: 32, width: 64, height: 32))
        label.text = "Text Box"
        return label
    }
    
    func createTool(tool: Tool) -> UIView{
        return toolCreationMapper[tool]!()
    }

    
}
