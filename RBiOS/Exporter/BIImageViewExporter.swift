//
//  BIImageViewExporter.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/26/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class BIImageViewExporter: NSObject {

    
    func write(views: [BIToolContainerView], rdl: inout String){
        for (i, elem) in views.enumerated() {
            _writeBIImageView(rdl: &rdl, view: elem, idx: i)
        }
    }
    
    func _writeBIImageView(rdl: inout String, view: BIToolContainerView, idx: Int) {
        let (left, top) = view.getCanvasPositon()
        let (width, height) = view.getCanvasSize()
        rdl.append(contentsOf:
            """
            <Image Name="Image\(idx)">
            <Source>Embedded</Source>
            <Value>Image\(idx)</Value>
            <Sizing>FitProportional</Sizing>
            <Top>\(top)in</Top>
            <Left>\(left)in</Left>
            <Height>\(height)in</Height>
            <Width>\(width)in</Width>
            <ZIndex>1</ZIndex>
            <Style>
            <Border>
            <Style>None</Style>
            </Border>
            </Style>
            </Image>\n
            """)
    }
    
    func embed(views: [BIToolContainerView], rdl: inout String){
        var doesReportContainImages = false
        for elem in views {
            if elem.childView is BIImageView{
                doesReportContainImages = true
                break
            }
        }
        
        if (!doesReportContainImages) { return }
        
        rdl.append(contentsOf: "<EmbeddedImages>\n")
        for (i, elem) in views.enumerated(){
            if elem.childView is BIImageView{ _embedBIImageViewHelper(rdl: &rdl, view: elem, idx: i)}
        }
        rdl.append(contentsOf: "</EmbeddedImages>\n")
        
    }
    
    
    func _embedBIImageViewHelper(rdl: inout String, view: BIToolContainerView, idx: Int) {
        let biImageView = view.childView as! BIImageView
        let imageData:Data = biImageView.image!.pngData()!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        rdl.append(contentsOf:
            """
            <EmbeddedImage Name="Image\(idx)">
            <MIMEType>image/\(imageData.fileExtension)</MIMEType>
            <ImageData>\(strBase64)</ImageData>
            </EmbeddedImage>\n
            """)
    }
}
