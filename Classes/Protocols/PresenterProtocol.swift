//
//  PresenterProtocol.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import Foundation

internal protocol PresenterProtocol: NSObjectProtocol {
    associatedtype V
    var view: V { get set }
}
