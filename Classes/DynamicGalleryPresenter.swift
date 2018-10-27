//
//  DynamicGalleryPresenter.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 22/10/2018.
//

import UIKit
import SnapKit
import Kingfisher

final class DynamicGalleryPresenter: NSObject, PresenterProtocol {
    typealias V = DynamicGalleryView
    
    // MARK: - Properties
    
    unowned var view: V
    
    private var initPoint : CGPoint?
    private var lastContentOffset: CGPoint?
    private var addedImageViews = [UIZoomableImageView]()
    private (set) var currentPosition: Int = 1 {
        didSet {
            self.updateViewValue()
        }
    }
    
    var isOrientationLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
    }
    
    /// Fill default
    func fillValues() {
        guard let startingNumber = self.view.numberInArray else { return }
        let photo = self.view.photos[startingNumber]
        
        //self.view.authorLabel?.text = photo.author
        self.updateViewValue()
        self.setImage(for: self.view.imageView, url: photo.imageAddress)
        
        /// Add one more imageview by default
        if startingNumber >= 0 {
            self.addImageView(at: self.currentPosition + 1)
        }
    }
    
    /// Create next image and prepare it for usage, before reaching it
    func addImageView(at position: Int) {
        
        // If there is not internet connection, then prevent adding any imageview
        if !isInternetAvailable() { return }
        
        // Check if the image is the one before the last
        if !self.view.photos.indices.contains(self.view.numberInArray + position - 1) { return }
        
        let imageView = UIZoomableImageView()
        self.view.scrollView?.addSubview(imageView)
        
        // Adjust new view's frame center
        // Formula: x = y * (n+(n-1))
        // n - number of image in current sequence
        // x - image's x position by frame
        // y - default view.center.x
        let xPos = self.view.view.center.x * CGFloat(position + (position - 1))
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(xPos)
            make.centerY.equalToSuperview()
            let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        }
        
        imageView.delegate = self
        
        // Set image to download
        let resource = self.view.photos[self.view.numberInArray + position - 1].imageAddress
        self.setImage(for: imageView, url: resource)
        
        // Add to array
        self.addedImageViews.append(imageView)
        
        // Update scrollView frame
        self.view.scrollView?.contentSize = CGSize(width: self.view.view.frame.width * CGFloat(position),
                                                   height: self.view.view.frame.height)
    }
    
    func orientationDidChange() {
        
        /// Very first
        self.view.imageView?.snp.remakeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        })
        
        /// Dynamically added ones
        
        for (pos, image) in addedImageViews.enumerated() {
            let correction = pos + 2
            let xPos = self.view.view.center.y * CGFloat(correction + (correction - 1))
            image.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(xPos)
                make.centerY.equalToSuperview()
                let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
            })
        }
        
        // Update scrollView frame
        self.view.scrollView?.contentSize = CGSize(width: self.view.view.frame.height * CGFloat(addedImageViews.count + 1),
                                                   height: self.view.view.frame.width)
        
        // Update the scroll view scroll position to the appropriate page.
        let minX = self.view.view.frame.minX
        let minY = self.view.view.frame.height * CGFloat(currentPosition - 1)
        let offsetPoint = CGPoint(x: minY, y: minX)
        self.view.scrollView?.setContentOffset(offsetPoint, animated: true)
    }
    
    private func setImage(for imageView: UIZoomableImageView?, url: URL) {
        imageView?.kf.setImage(with: url,
                               options: [.transition(.fade(0.2))],
                               completionHandler: { (image, error, cacheType, url) in
                                // Prevent a situation when user got disconnected from net,
                                // and tapped onto the image. Neither will not be downloaded,
                                // nor allow user to dismiss the vc (coz of pan gesture to dismiss).
                                if image == nil && !isInternetAvailable() {
                                    self.view.vc.errorOccured("Error occured. Please try again.",
                                                              action: self.view.vc.dismiss(animated: true, completion: nil))
                                }
        })
    }
    
    /// Update value on the screen according to what is being shown e.g. author name
    private func updateViewValue() {
        if !self.view.photos.indices.contains(self.view.numberInArray + currentPosition - 1) {
            return
        }
        
        let authorName = self.view.photos[self.view.numberInArray + currentPosition - 1].footerLabelText
        self.view.authorLabel?.text = authorName
    }
    
}

// MARK: - UIScrollViewDelegate methods

extension DynamicGalleryPresenter: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let last = lastContentOffset else { return }
        
        // did swipe right
        if last.x < scrollView.contentOffset.x {
            if self.currentPosition != self.view.photos.count {
                currentPosition += 1
                if self.currentPosition >= (self.addedImageViews.count + 1) {
                    self.addImageView(at: self.currentPosition + 1)
                }
            }
        }   // did swipe left
        else if last.x > scrollView.contentOffset.x {
            if self.currentPosition != 1 {
                self.currentPosition -= 1
            }
        }
        
    }
}

// MARK: - UIZoomableImageViewDelegate methods

extension DynamicGalleryPresenter: UIZoomableImageViewDelegate {
    var viewWidth: CGFloat? {
        return self.view.view.bounds.width
    }
    
    var viewHeight: CGFloat? {
        return self.view.view.bounds.height
    }
    
    func setBackgroundColorWhileMovingVertically(_ alpha: CGFloat) {
        self.view.backgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
    func didReachDismissPosition() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.view.alpha = 0
        }, completion: { _ in
            self.view.vc.dismiss(animated: false, completion: nil)
        })
    }
}
