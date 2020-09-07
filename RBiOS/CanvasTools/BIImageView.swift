//
//  BIImageView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 8/11/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit

class BIImageView: UIImageView, BITool {

    var name: String = "Image"
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

