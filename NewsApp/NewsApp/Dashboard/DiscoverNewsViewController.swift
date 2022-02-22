//
//  DiscoverNewsViewController.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 18.02.22.
//

import Foundation
import UIKit

class DiscoverNewsViewController: UIViewController {
    
    private var sources = NewsSourceDescriptor.parseFromJson()
    
    let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        viewLayout.minimumLineSpacing = 23
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .primaryGray
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DiscoverNewsCardCell.self, forCellWithReuseIdentifier: DiscoverNewsCardCell.cellIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverNewsCardCell.cellIdentifier, for: indexPath) as? DiscoverNewsCardCell else {
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

//MARK: UICollectionViewCell
class DiscoverNewsCardCell: UICollectionViewCell {
    static var cellIdentifier = "imageCell"
    
    private var logo = UIImageView()
    private var name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(sourceData: Source) {
        logo.image = UIImage(imageLiteralResourceName: sourceData.image)
        name.text = sourceData.name
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6.0
        contentView.layer.masksToBounds = true
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        contentView.addSubview(logo)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.textColor = .black
        name.font = UIFont.newsAppFont(ofSize: 13, weight: .medium)
        contentView.addSubview(name)
    }
   
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            logo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            logo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            logo.widthAnchor.constraint(equalToConstant: 70),
            logo.heightAnchor.constraint(equalToConstant: 70),
            name.topAnchor.constraint(equalTo: logo.bottomAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
