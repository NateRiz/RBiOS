//
//  CanvasBorderView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/18/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit
import UIScreenExtension


class CanvasBorderView: UIView {

    
    init(){
        super.init(frame: CGRect())
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ frame: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        drawRuler(context: context)
    }

    public func drawRuler(context: CGContext){
        context.setStrokeColor(UIColor.lightGray.cgColor)
        
        let ticksPerInch: CGFloat = 4
        let pixelsPerTick = UIScreen.pointsPerInch! / ticksPerInch
        var ticksPerScreen =  floor(UIScreen.main.bounds.size.width / pixelsPerTick)
        
        for itr in stride(from: 1.0, to: ticksPerScreen, by: 1.0){
            let x = itr * pixelsPerTick
            var height:CGFloat = 16
            if Int(itr) % 4 == 0{
                height = 32
            }
            else if Int(itr) % 2 == 0{
                height = 24
            }
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: height))
        }
        
        ticksPerScreen =  floor(UIScreen.main.bounds.size.height / pixelsPerTick)
        
        for itr in stride(from: 1.0, to: ticksPerScreen, by: 1.0){
            let y = itr * pixelsPerTick
            var width:CGFloat = 16
            if Int(itr) % 4 == 0{
                width = 32
            }
            else if Int(itr) % 2 == 0{
                width = 24
            }
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: width, y: y))
        }
        
        context.strokePath()
        
    }
}
