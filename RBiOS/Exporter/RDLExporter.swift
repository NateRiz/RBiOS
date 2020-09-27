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
    let textViewExporter = BITextViewExporter()
    let imageViewExporter = BIImageViewExporter()
    
    
    func generate(ui: [BIToolContainerView]) {
        rdl = ""
        _writeHeader()
        _writeBody()
        _writeFooter()
        print(rdl)
    }
    
    func _writeHeader() {
        rdl.append(contentsOf: header)
    }
    
    func _writeFooter() {
        rdl.append(contentsOf: footer1)
        imageViewExporter.embed(views: self.ui.filter{$0.childView is BIImageView}, rdl: self.rdl)
        rdl.append(contentsOf: footer2)
    }
    
    func _writeBody() {
        textViewExporter.write(views: self.ui.filter{$0.childView is BITextView}, rdl: self.rdl)
        imageViewExporter.write(views: self.ui.filter{$0.childView is BIImageView}, rdl: self.rdl)
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
