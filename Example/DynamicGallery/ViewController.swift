//
//  ViewController.swift
//  DynamicGallery
//
//  Created by deelzeek on 10/22/2018.
//  Copyright (c) 2018 deelzeek. All rights reserved.
//

import UIKit
import DynamicGallery

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var tableView: UITableView?
    lazy var photos: [PhotoViewModel] = {
        var photos = [PhotoViewModel]()
        
        for i in 1...5 {
            let photo = Photo(id: i)
            let photoViewModel = PhotoViewModel(with: photo)
            photos.append(photoViewModel)
        }
        
        return photos
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
    }
}

// MARK: - UITableViewDelegate and Datasource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = "Photo \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNum = indexPath.row
        let vc = DynamicGalleryViewController(photos: self.photos, numberInArray: rowNum)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}

