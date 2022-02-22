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
            discoverCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            discoverCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            discoverCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            discoverCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
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
        
        let source = sources[indexPath.row]
        cell.setupCell(sourceData: source)
        return cell
    }
}

extension DiscoverNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Present TableView with news from source
        //let focusedImage = ImageViewController(image: sources[indexPath.item].image)
       // present(focusedImage, animated: true, completion: nil)
    }
}

extension DiscoverNewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 25, bottom: 20, right: 30)
    }
}
