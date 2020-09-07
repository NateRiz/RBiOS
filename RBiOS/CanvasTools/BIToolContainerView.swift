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
    var offsetX:CGFloat = 0
    var offsetY:CGFloat = 0
    
    init(child: UIView, frame: CGRect) {
        super.init(frame: frame)
        childView = child
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
                setX(x: location!.x - offsetX)
                setY(y: location!.y - offsetY)
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
            self.childView!.frame.size.height = self.frame.size.height
            self.initialTouchDistance = touchDistance
        }
        
        (self.parentViewController as! CanvasViewController).propertiesPane.updatePosition()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesEnded(touches, with: event)
        self.initialTouchDistance = 0
        self.touchMode = .NONE
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
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
    
    func getCanvasPositon() -> (CGFloat, CGFloat) {
        return (self.frame.minX / UIScreen.pointsPerInch!, self.frame.minY / UIScreen.pointsPerInch!)
    }
    
    func getCanvasSize() -> (CGFloat, CGFloat) {
        return (self.frame.width / UIScreen.pointsPerInch!, self.frame.height / UIScreen.pointsPerInch!)
    }
    
    func setX(x: CGFloat){
        guard let _ = self.superview else {return}
        self.frame.origin.x = clamp(val: x, min: 0, max: self.superview!.bounds.size.width - self.frame.size.width)
    }
    
    func setY(y: CGFloat){
        guard let _ = self.superview else {return}
        self.frame.origin.y = clamp(val: y, min: 0, max: self.superview!.bounds.size.height - self.frame.size.height)
    }
    
    func setWidth(w: CGFloat){
        guard let _ = self.superview else {return}
        self.frame.size.width = clamp(val: w, min: 16, max: self.superview!.bounds.size.width)
        self.childView!.frame.size.width = self.frame.size.width
        if self.frame.maxX > self.superview!.bounds.size.width{
            setX(x: self.superview!.bounds.size.width - self.frame.size.width)
        }
    }
    
    func setHeight(h: CGFloat){
        guard let _ = self.superview else {return}
        self.frame.size.height = clamp(val: h, min: 16, max: self.superview!.bounds.size.height)
        self.childView!.frame.size.height = self.frame.size.height
        if self.frame.maxY > self.superview!.bounds.size.height{
            setY(y: self.superview!.bounds.size.height - self.frame.size.height)
        }
    }
}
