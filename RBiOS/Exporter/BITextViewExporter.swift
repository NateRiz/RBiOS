//
//  BITextViewExporter.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/26/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class BITextViewExporter: NSObject {
    
    var rdl = ""
    
    func write(views: [BIToolContainerView], rdl: String){
        self.rdl = rdl
        for (i, elem) in views.enumerated() {
            _writeBITextView(view: elem, idx: i)
        }
    }
    
    func _writeBITextView(view: BIToolContainerView, idx: Int) {
        let buffer:CGFloat = view.frame.width * 0.25
        let biTextView = view.childView as! BITextView
        let (left, top) = view.getCanvasPositon()
        let (width, height) = view.getCanvasSize()
        let lines = biTextView.text.components(separatedBy: "\n")
        
        rdl.append(contentsOf:
            """
            <Textbox Name=\"Textbox\(idx)\">
            <rd:DefaultName>Textbox\(idx)</rd:DefaultName>
            <CanGrow>true</CanGrow>
            <KeepTogether>true</KeepTogether>
            <Paragraphs>\n
            """)
        for line in lines { _writeBITextViewSingleLine(str: line, view: biTextView)}
        rdl.append(contentsOf:
            """
            </Paragraphs>
            <Top>\(top)in</Top>
            <Left>\(left)in</Left>
            <Height>\(height)in</Height>
            <Width>\(width + buffer)in</Width>
            <ZIndex>1</ZIndex>
            <Style>
            <Border>
            <Style>None</Style>
            </Border>
            <PaddingLeft>2pt</PaddingLeft>
            <PaddingRight>2pt</PaddingRight>
            <PaddingTop>2pt</PaddingTop>
            <PaddingBottom>2pt</PaddingBottom>
            </Style>
            </Textbox>\n
            """)
    }
    
    func _writeBITextViewSingleLine(str: String, view: BITextView){
        rdl.append(contentsOf:
            """
            <Paragraph>
            <TextRuns>
            <TextRun>
            <Value>\((str == "" ? " " : str))</Value>\n
            """)
        let isItalic = view.font!.fontDescriptor.symbolicTraits.contains(.traitItalic)
        let isBold = view.font!.fontDescriptor.symbolicTraits.contains(.traitBold)
        rdl.append(contentsOf:
            """
            <Style>
            \(isItalic ? "<FontStyle>Italic</FontStyle>" : "")
            <FontSize>\(Int(view.font!.pointSize))pt</FontSize>
            \(isBold ? "<FontWeight>Bold</FontWeight>" : "")
            </Style>\n
            """)
        rdl.append(contentsOf:
            """
        </TextRun>
        </TextRuns>
        <Style />
        </Paragraph>\n
        """)
    }
}
