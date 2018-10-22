//
//  ViewProtocol.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import UIKit

internal protocol ViewProtocol: class {
    var view: UIView! { get set }
    var vc: UIViewController { get }
}

