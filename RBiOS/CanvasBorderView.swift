//
//  CanvasBorderView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/18/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit
import UIScreenExtension

// For drawing the ruler
// Contains main canvas

class CanvasBorderView: UIView {

    var verticalLinePositions = [CGFloat]()
    var horizontalLinePositions = [CGFloat]()
    var measurementLabels = [UILabel]()
    var drawableCanvasView: DrawableCanvasView?
    
    init(canvas: DrawableCanvasView? = nil){
        super.init(frame: CGRect())
        guard let dcv = canvas else {return}
        self.addSubview(dcv)
        drawableCanvasView = dcv
        drawableCanvasView!.translatesAutoresizingMaskIntoConstraints = false
        drawableCanvasView!.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        drawableCanvasView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        drawableCanvasView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        drawableCanvasView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        drawableCanvasView!.layer.borderWidth = 1
        drawableCanvasView!.layer.borderColor = UIColor.lightGray.cgColor
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
        updateMeasurementLabels()
    }

    public func drawRuler(context: CGContext){
        context.setStrokeColor(UIColor.lightGray.cgColor)
        
        horizontalLinePositions.removeAll()
        verticalLinePositions.removeAll()
        
        let ticksPerInch: CGFloat = 4
        let pixelsPerTick = UIScreen.pointsPerInch! / ticksPerInch
        var ticksPerScreen =  floor(UIScreen.main.bounds.size.width / pixelsPerTick)
        
        for itr in stride(from: 1.0, to: ticksPerScreen, by: 1.0){
            let x = itr * pixelsPerTick
            var height:CGFloat = 8
            if Int(itr) % 4 == 0{
                height = 16
                horizontalLinePositions.append(x)
            }
            else if Int(itr) % 2 == 0{
                height = 12
            }
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: height))
        }
        
        ticksPerScreen =  floor(UIScreen.main.bounds.size.height / pixelsPerTick)
        
        for itr in stride(from: 1.0, to: ticksPerScreen, by: 1.0){
            let y = itr * pixelsPerTick
            var width:CGFloat = 8
            if Int(itr) % 4 == 0{
                width = 16
                verticalLinePositions.append(y)
            }
            else if Int(itr) % 2 == 0{
                width = 12
            }
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: width, y: y))
        }
        
        context.strokePath()
    }
    
    func updateMeasurementLabels(){
        while(!measurementLabels.isEmpty){
            measurementLabels.last?.removeFromSuperview()
            measurementLabels.removeLast()
        }
        
        let buffer:CGFloat = 2.0
        
        for (i, x) in horizontalLinePositions.enumerated(){
            let fontSize:CGFloat = 14.0
            let label = UILabel(frame: CGRect(x: x - fontSize, y: buffer, width: 16, height: 16))
            label.text = "\(i+1)"
            label.font = UIFont(name: label.font.fontName, size: fontSize)
            label.textColor = UIColor.lightGray
            addSubview(label)
            measurementLabels.append(label)
        }
        
        for (i, y) in verticalLinePositions.enumerated(){
            let fontSize:CGFloat = 14.0
            let label = UILabel(frame: CGRect(x: buffer, y: y - fontSize - buffer, width: 16, height: 16))
            label.text = "\(i+1)"
            label.font = UIFont(name: label.font.fontName, size: fontSize)
            label.textColor = UIColor.lightGray
            addSubview(label)
            measurementLabels.append(label)
        }
    }
    
}
