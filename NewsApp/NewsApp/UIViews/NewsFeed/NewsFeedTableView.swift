//
//  NewsFeedTableView.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import UIKit

class NewsFeedTableView: UITableView {
   
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(NewsFeedTableViewCell.self, forCellReuseIdentifier: NewsFeedTableViewCell.reuseIdentifier)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .primaryBackgrond
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
