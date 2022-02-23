//
//  DiscoverNewsCollectionView.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import UIKit

class DiscoverNewsCollectionView: UICollectionView {
    
    convenience init(frame: CGRect) {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        viewLayout.minimumLineSpacing = 23
        
        self.init(frame: frame, collectionViewLayout: viewLayout)
        
        register(DiscoverNewsCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverNewsCollectionViewCell.cellIdentifier)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .primaryBackgrond
    }
}
