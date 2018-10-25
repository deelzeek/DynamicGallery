//
//  PhotoViewModel.swift
//  DynamicGallery_Example
//
//  Created by Dilz Osmani on 25/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import DynamicGallery

struct PhotoViewModel: DynamiceGalleryPhoto {
    
    // MARK: - Properties
    
    let photo: Photo!
    
    var footerLabelText: String {
        return photo.author
    }
    
    var imageAddress: URL {
        return URL(string: "https://picsum.photos/1000/1000?image=\(photo.id)")!
    }
    
    // MARK: - Init
    
    init(with photo: Photo) {
        self.photo = photo
    }
}
