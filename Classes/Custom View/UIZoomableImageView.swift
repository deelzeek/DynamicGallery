//
//  UIZoomableImageView.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 23/10/2018.
//

import UIKit

internal enum Zoom {
    case zoomIn, zoomOut
}

internal protocol UIZoomableImageViewDelegate: class {
    var viewWidth: CGFloat? { get }
    var viewHeight: CGFloat? { get }
    
    func setBackgroundColorWhileMovingVertically(_ alpha: CGFloat)
    func didReachDismissPosition()
}

internal class UIZoomableImageView: UIImageView {
    
    // MARK: - Properties
    
    private var initPoint : CGPoint?
    private var pinchZoomIsProcessing: Bool = false
    private var isOrientationLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    /// input
    weak var delegate: UIZoomableImageViewDelegate?
    
    // Recognizers
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHangler(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    // MARK: - Inits
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configRecognizers() {
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(pinchGestureRecognizer)
        
    }
    
    // MARK: - Pan Gesture regonizer handler
    
    @objc private func panGestureHangler(_ sender: UIPanGestureRecognizer) {
        guard let picture = sender.view, let superview = self.superview else { return }
        
        let translation = sender.translation(in: superview)
        
        switch sender.state {
        case .began:
            panGestureDidStart(point: picture.center)
        case .changed:
            panGestureDidChange(point: translation, view: picture)
        case .ended:
            panGestureDidEnd(picture)
        case .cancelled, .failed, .possible:
            break
        }
    }
    
    private func panGestureDidStart(point: CGPoint) {
        self.initPoint = point
    }
    
    private func panGestureDidChange(point: CGPoint, view: UIView) {
        /// Move item around
        view.center = CGPoint(x: initPoint!.x + point.x, y: initPoint!.y + point.y)
        
        // Get distance change from initial center
        let verticalDistance: CGFloat = getVerticalDistanceFromCenter(for: view) + 50.0
        
        // If over 100, then for every +1 point reduce alpha for background
        if 100.0...200.0 ~= Double(verticalDistance) {
            let alphaValue: CGFloat = 1.0 - (verticalDistance.truncatingRemainder(dividingBy: 100.0) / 100.0)
            self.delegate?.setBackgroundColorWhileMovingVertically(alphaValue)
        }
    }
    
    private func panGestureDidEnd(_ view: UIView) {
        let verticalDistance: CGFloat = getVerticalDistanceFromCenter(for: view)
        
        // If alpha has reached 0, and user let it go on that moment -> dismiss
        if verticalDistance >= 200 {
            self.delegate?.didReachDismissPosition()
            return
        }
        
        /// Animate picture back to init position
        UIView.animate(withDuration: 0.2, animations: {
            // Return to original centre
            view.center = self.initPoint!
            self.delegate?.setBackgroundColorWhileMovingVertically(1.0)
            self.layoutIfNeeded()
        })
        
    }
    
    private func getVerticalDistanceFromCenter(for view: UIView) -> CGFloat {
        guard let superview = self.superview else { return 0 }
        let y = superview.center.y
        let viewY = view.center.y
        
        if viewY == 0 {
            return 0
        }
        
        return (viewY >= y) ? (viewY - y) : (y - viewY)
    }
    
    // MARK: - Pinch Gesture regonizer handler
    
    @objc private func pinchGestureHandler(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
            
            self.pinchZoomIsProcessing = true
            return
        }
        
        if gestureRecognizer.state == .ended {
            
            // Update zoom value
            self.pinchZoomIsProcessing = false
            
            UIView.animate(withDuration: 0.2) {
                gestureRecognizer.view?.transform = CGAffineTransform.identity
            }
        }
    }
    
}

extension UIZoomableImageView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer === self.panGestureRecognizer && otherGestureRecognizer === self.pinchGestureRecognizer) || (gestureRecognizer === self.pinchGestureRecognizer && otherGestureRecognizer === self.panGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.panGestureRecognizer {
            if self.pinchZoomIsProcessing {
                return true
            } else {
                if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
                    let velocity = recognizer.velocity(in: recognizer.view)
                    return abs(velocity.y) > abs(velocity.x)
                }
                
            }
        }
        
        return true
    }
}
