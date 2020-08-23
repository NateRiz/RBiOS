//
//  BIToolContainerView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/14/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class BIToolContainerView: UIView {
    
    var touchMode:TouchMode = .NONE
    var initialTouchDistance: CGFloat = 0
    var childView: UIView?
    var parentView: UIView?
    var offsetX:CGFloat = 0
    var offsetY:CGFloat = 0
    
    init(child: UIView, parent: UIView, frame: CGRect) {
        super.init(frame: frame)
        childView = child
        parentView = parent
        addSubview(childView!)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.touchMode != .NONE { return }
        if touches.count == 1{
            let loc = touches.first!.location(in: self.superview)
            offsetX = loc.x - self.frame.minX
            offsetY = loc.y - self.frame.minY
            self.touchMode = .DRAG
        }
        else if touches.count == 2{
            self.touchMode = .NONE
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            let left = (loc1.x < loc2.x ? loc1 : loc2)
            let right = (loc1.x < loc2.x ? loc2 : loc1)
            let up = (loc1.y < loc2.y ? loc1 : loc2)
            let down = (loc1.y < loc2.y ? loc2 : loc1)
            
            if left.x <= self.frame.midX && right.x >= self.frame.midX{
                self.touchMode = .HRESIZE
                self.initialTouchDistance = abs(right.x-left.x)
            }
            else if up.y <= self.frame.midY && down.y >= self.frame.midY{
                self.touchMode = .VRESIZE
                self.initialTouchDistance = abs(right.y-left.y)
            }
        }
        else{
            self.touchMode = .NONE
        }
        self.setSelfAsSelectedTool()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if self.touchMode == .DRAG{
            let touch = touches.first;
            let location = touch?.location(in: self.superview);
            if(location != nil)
            {
                let clampedX = min(max(0, location!.x - offsetX), parentView!.bounds.size.width - self.frame.size.width)
                let clampedY = min(max(0, location!.y - offsetY), parentView!.bounds.size.height - self.frame.size.height)
                print("w\(parentView!.bounds.size.width) h\(parentView!.bounds.size.height) &\(location!.y-offsetY), \(parentView!.bounds.size.height - self.frame.size.height), \(self.frame.size.height)")
                self.frame.origin = CGPoint(x: clampedX, y: clampedY);
            }
        }
        else if self.touchMode == .HRESIZE{
            if touches.count < 2 { return }
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            let touchDistance = abs(loc1.x-loc2.x)
            self.frame.size.width = max(16, self.frame.size.width + touchDistance - self.initialTouchDistance)
            self.childView!.frame.size.width = self.frame.size.width
            //self.center = CGPoint(x: (loc1.x+loc2.x)/2, y: self.frame.origin.y)
            self.initialTouchDistance = touchDistance
        }
            
        else if self.touchMode == .VRESIZE{
            if touches.count < 2 { return }
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            let touchDistance = abs(loc1.y-loc2.y)
            self.frame.size.height = max(16, self.frame.size.height + touchDistance - self.initialTouchDistance)
            //self.center = CGPoint(x: self.frame.origin.x, y: (loc1.y+loc2.y)/2)
            self.childView!.frame.size.height = self.frame.size.height

            self.initialTouchDistance = touchDistance
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesEnded(touches, with: event)
        self.initialTouchDistance = 0
        self.touchMode = .NONE
    }
    
    func setSelfAsSelectedTool(){
        (self.parentViewController as! CanvasViewController).setSelectedTool(selectedView: self)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func resetSelectedTool(){
        self.layer.borderWidth = 0
    }
    
}
