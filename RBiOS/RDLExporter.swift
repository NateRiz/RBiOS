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
        rdl.append(contentsOf: footer)
    }
    
    func _writeBody(){
        for (i, elem) in ui.enumerated(){
            if elem.childView is BITextView{ _writeBITextView(view: elem, idx: i) }
        }
    }
    
    func _writeBITextView(view: BIToolContainerView, idx: Int){
        rdl.append(contentsOf:
        """
        <Textbox Name=\"Textbox\(idx)\">
        <rd:DefaultName>Textbox\(idx)</rd:DefaultName>
        <CanGrow>true</CanGrow>
        <KeepTogether>true</KeepTogether>
        <Paragraphs>\n
        """)
        let biTextView = view.childView as! BITextView
        let left = view.frame.origin.x / UIScreen.pointsPerInch!
        let top = view.frame.origin.y / UIScreen.pointsPerInch!
        let width = view.frame.width / UIScreen.pointsPerInch!
        let height = view.frame.height / UIScreen.pointsPerInch!
        print(left, top)
        let lines = biTextView.text.components(separatedBy: "\n")
        for line in lines { _writeBITextViewSingleLine(str: line)}
        rdl.append(contentsOf:
        """
        </Paragraphs>
        <Top>\(top)in</Top>
        <Left>\(left)in</Left>
        <Height>\(width)in</Height>
        <Width>\(height)in</Width>
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
    
    func _writeBITextViewSingleLine(str: String){
        rdl.append(contentsOf:
        """
        <Paragraph>
        <TextRuns>
        <TextRun>
            <Value>\((str == "" ? " " : str))</Value>
        <Style />
        </TextRun>
        </TextRuns>
        <Style />
        </Paragraph>\n
        """
        )
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
    
    let footer =
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
    </ReportParametersLayout>
    </Report>\n
    """
}
