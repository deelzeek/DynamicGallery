//
//  DynamicGalleryViewController.swift
//  DynamicGallery
//
//  Created by Dilz Osmani on 22/10/2018.
//

import UIKit
import SnapKit

internal protocol DynamicGalleryView: ViewProtocol {
    var footerView: UIView? { get set }
    var authorLabel: UILabel? { get set }
    var imageView: UIZoomableImageView? { get set }
    var backgroundView: UIView? { get set }
    var scrollView: UIScrollView? { get set }
    
    var photos: [DynamiceGalleryPhoto]! { get set }
    var numberInArray: Int! { get }
}

open class DynamicGalleryViewController: UIViewController, TemplateViewController {
    typealias P = DynamicGalleryPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    weak var footerView: UIView?
    weak var authorLabel: UILabel?
    weak var imageView: UIZoomableImageView?
    weak var backgroundView: UIView?
    weak var scrollView: UIScrollView?
    
    /// Input
    var photos: [DynamiceGalleryPhoto]!
    var numberInArray: Int!
    
    // MARK: Inits
    
    public init(photos: [DynamiceGalleryPhoto], numberInArray: Int = 0) {
        self.photos = photos
        self.numberInArray = numberInArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    /// Hide status bar for full screen
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// Adjust orientation changes
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.presenter.orientationDidChange()
    }
    
    // MARK: - UI setup
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.backgroundColor = .black
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.backgroundView = backgroundView
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.scrollView = scrollView
        self.scrollView?.delegate = presenter
        
        let imageView = UIZoomableImageView()
        self.scrollView?.addSubview(imageView)
        imageView.delegate = presenter
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            let _ = self.presenter.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        }
        self.imageView = imageView
        
        let footerView = UIView()
        self.view.addSubview(footerView)
        footerView.backgroundColor = self.navigationController?.navigationBar.tintColor
        footerView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60.0)
        }
        self.footerView = footerView
        
        let authorLabel = UILabel()
        self.footerView?.addSubview(authorLabel)
        authorLabel.textColor = UIColor.white
        authorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.authorLabel = authorLabel
        
        // Fill values
        self.presenter.fillValues()
    }
    
}

// MARK: - View extension

extension DynamicGalleryViewController : DynamicGalleryView {
    var vc: UIViewController {
        return self
    }
}
