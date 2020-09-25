//
//  LineView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/24/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    static let lineWidth = 2
    static let systemBlue = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
    var isVertical: Bool = true;


    init(frame: CGRect, isVertical: Bool = true, color: UIColor = .black){
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundColor = color
        self.isVertical = isVertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
