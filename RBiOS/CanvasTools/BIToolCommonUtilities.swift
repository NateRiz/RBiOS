//
//  BIToolCommonUtilities.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

protocol BITool{
    func setSelfAsSelectedTool()
    func resetSelectedTool()
}

extension BITool where Self: UIView {
    func setSelfAsSelectedTool(){
        (self.parentViewController as! CanvasViewController).setSelectedTool(selectedView: self)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func resetSelectedTool(){
        self.layer.borderWidth = 0
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
