//
//  UIViewController+Error.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import UIKit

internal extension UIViewController {
    func noConnection() {
        self.createAlertView("No internet connection.")
    }
    
    func errorOccured(_ msg: String) {
        self.createAlertView(msg)
    }
    
    func errorOccured(_ msg: Error) {
        self.createAlertView(msg.localizedDescription)
    }
    
    func errorOccured(_ msg: String, action: @autoclosure @escaping () -> Void) {
        self.createAlertView(msg, closure: action())
    }
    
    private func createAlertView(_ msg: String) {
        let alertVC = UIAlertController.init(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func createAlertView(_ msg: String, closure: @autoclosure @escaping () -> Void) {
        let alertVC = UIAlertController.init(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .default, handler: { _ in
            closure()
        })
        
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
