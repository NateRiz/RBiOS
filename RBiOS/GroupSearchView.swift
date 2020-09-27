//
//  GroupSearchView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/27/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class GroupSearchView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.isHidden = true
    }
    
}
