//
//  Photo.swift
//  DynamicGallery_Example
//
//  Created by Dilz Osmani on 25/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct Photo {
    
    // MARK: - Properties
    
    let id: Int
    let width: Int = 0
    let height: Int = 0
    let author: String = "Author"
    let format: String = "jpeg"
    
    // MARK: - Init
    
    init(id: Int) {
        self.id = id
    }
}
