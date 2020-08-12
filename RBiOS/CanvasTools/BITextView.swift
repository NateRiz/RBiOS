//
//  BITextField.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/8/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class BITextView: UITextView, BITool, UITextViewDelegate{
    
    var touchMode = 0
    var touchDistance: CGFloat = 0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.isScrollEnabled = false
        self.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.count == 1{
            self.touchMode = 1
        }
        else if touches.count == 2{
            self.touchMode = 0
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            let left = (loc1.x < loc2.x ? loc1 : loc2)
            let right = (loc1.x < loc2.x ? loc2 : loc1)
            let up = (loc1.y < loc2.y ? loc1 : loc2)
            let down = (loc1.y < loc2.y ? loc2 : loc1)
            
            if left.x <= self.frame.midX && right.x >= self.frame.midX{
                self.touchMode = 2
                self.touchDistance = abs(right.x-left.x)
            }
            else if up.y <= self.frame.midY && down.y >= self.frame.midY{
                self.touchMode = 3
                self.touchDistance = abs(right.y-left.y)
            }
        }
        else{
            self.touchMode = 0
        }
        self.setSelfAsSelectedTool()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if self.touchMode == 1{
            let touch = touches.first;
            let location = touch?.location(in: self.superview);
            if(location != nil)
            {
                self.frame.origin = CGPoint(x: location!.x-self.frame.size.width/2, y: location!.y-self.frame.size.height/2);
            }
        }
        else if self.touchMode == 2{
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            self.frame.size.width = max(16, self.frame.width + (abs(loc1.x-loc2.x) - self.touchDistance))
        }
        else if self.touchMode == 3{
            let touch1 = touches[touches.index(touches.startIndex, offsetBy: 0)]
            let touch2 = touches[touches.index(touches.startIndex, offsetBy: 1)]
            let loc1 = touch1.location(in: self.superview);
            let loc2 = touch2.location(in: self.superview);
            self.frame.size.height = max(16, self.frame.height + (abs(loc1.y-loc2.y) - self.touchDistance))
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textViewDidChange(_ textView: UITextView) {
        self.sizeToFit()
    }
    

}

