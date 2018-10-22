//
//  TemplateViewController.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import Foundation

internal protocol TemplateViewController: class {
    associatedtype P
    var presenter: P { get set }
}
