//
//  DiscoverNewsViewController.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 18.02.22.
//

import Foundation
import UIKit

class DiscoverNewsViewController: UIViewController {
    private let sources = NewsSourceDescriptor.parseFromJson()
    private let discoverCollectionView = DiscoverNewsCollectionView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(discoverCollectionView)
        
        discoverCollectionView.dataSource = self
        discoverCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            discoverCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            discoverCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            discoverCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            discoverCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension DiscoverNewsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverNewsCollectionViewCell.cellIdentifier, for: indexPath) as? DiscoverNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(sourceData: sources[indexPath.row])
        
        return cell
    }
}

extension DiscoverNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Present TableView with news from source
        NSLog("sourceView")
    }
}

extension DiscoverNewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}
