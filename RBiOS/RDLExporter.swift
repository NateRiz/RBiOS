//
//  RDLExporter.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/16/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit
import Foundation

class RDLExporter: NSObject {

    var rdl = ""
    var ui = [BIToolContainerView]()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    func generate(ui: [BIToolContainerView]){
        rdl = ""
        self.ui = ui
        _writeHeader()
        _writeBody()
        _writeFooter()
        print(rdl)
    }
    
    func _writeHeader(){
        rdl.append(contentsOf: header)
    }
    
    func _writeFooter(){
        rdl.append(contentsOf: footer1)
        _embedBIImageView()
        rdl.append(contentsOf: footer2)
    }
    
    func _writeBody(){
        for (i, elem) in ui.enumerated(){
            if elem.childView is BITextView{ _writeBITextView(view: elem, idx: i) }
            else if elem.childView is BIImageView{ _writeBIImageView(view: elem, idx: i)}
        }
    }
    
    func _writeBIImageView(view: BIToolContainerView, idx: Int) {
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
    
    func _embedBIImageView(){
        var doesReportContainImages = false
        for elem in ui {
            if elem.childView is BIImageView{
                doesReportContainImages = true
                break
            }
        }
        
        if (!doesReportContainImages) { return }
        
        rdl.append(contentsOf: "<EmbeddedImages>\n")
        for (i, elem) in ui.enumerated(){
            if elem.childView is BIImageView{ _embedBIImageViewHelper(view: elem, idx: i)}
        }
        rdl.append(contentsOf: "</EmbeddedImages>\n")
        
    }
    
    
    func _embedBIImageViewHelper(view: BIToolContainerView, idx: Int) {
        let biImageView = view.childView as! BIImageView
        let imageData:Data = biImageView.image!.pngData()!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

        rdl.append(contentsOf: // TODO: Take embededimageS out of this. only allows one image.
        """
        <EmbeddedImage Name="Image\(idx)">
        <MIMEType>image/\(imageData.fileExtension)</MIMEType>
        <ImageData>\(strBase64)</ImageData>
        </EmbeddedImage>\n
        """)
    }
    
    func _writeBITextView(view: BIToolContainerView, idx: Int) {
        let buffer:CGFloat = view.frame.width * 0.25
        rdl.append(contentsOf:
        """
        <Textbox Name=\"Textbox\(idx)\">
        <rd:DefaultName>Textbox\(idx)</rd:DefaultName>
        <CanGrow>true</CanGrow>
        <KeepTogether>true</KeepTogether>
        <Paragraphs>\n
        """)
        let biTextView = view.childView as! BITextView
        let (left, top) = view.getCanvasPositon()
        let (width, height) = view.getCanvasSize()
        let lines = biTextView.text.components(separatedBy: "\n")
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
        """
        )
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
    
    
    let header =
    """
    <?xml version="1.0" encoding="utf-8"?>
    <Report MustUnderstand="df" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:df="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition/defaultfontfamily">
    <rd:ReportUnitType>Inch</rd:ReportUnitType>
    <rd:ReportID>9971557c-fed0-4627-8d7b-50a2b567c3f3</rd:ReportID>
    <df:DefaultFontFamily>Segoe UI</df:DefaultFontFamily>
    <AutoRefresh>0</AutoRefresh>
    <ReportSections>
    <ReportSection>
    <Body>
    <ReportItems>\n
    """
    
    let footer1 =
    """
    </ReportItems>
    <Height>2.25in</Height>
    <Style>
    <Border>
    <Style>None</Style>
    </Border>
    </Style>
    </Body>
    <Width>6in</Width>
    <Page>
    <PageFooter>
    <Height>0.45in</Height>
    <PrintOnFirstPage>true</PrintOnFirstPage>
    <PrintOnLastPage>true</PrintOnLastPage>
    <Style>
    <Border>
    <Style>None</Style>
    </Border>
    </Style>
    </PageFooter>
    <LeftMargin>1in</LeftMargin>
    <RightMargin>1in</RightMargin>
    <TopMargin>1in</TopMargin>
    <BottomMargin>1in</BottomMargin>
    <Style />
    </Page>
    </ReportSection>
    </ReportSections>
    <ReportParametersLayout>
    <GridLayoutDefinition>
    <NumberOfColumns>4</NumberOfColumns>
    <NumberOfRows>2</NumberOfRows>
    </GridLayoutDefinition>
    </ReportParametersLayout>\n
    """
}

let footer2 =
    """
    </Report>\n
    """
