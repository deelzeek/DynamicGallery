//
//  DynamicGalleryPhoto.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import Foundation

public protocol DynamiceGalleryPhoto {
    var author: String { get set }
    var originalImageAddress: URL { get }
}
