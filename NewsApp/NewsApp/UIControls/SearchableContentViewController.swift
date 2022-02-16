//
//  SearchableContentViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

@objc protocol Searchable: UISearchBarDelegate {
    var isSearching: Bool { get set }
    func searchBegan(searchBar: UISearchBar)
    func searchEnded(searchBar: UISearchBar)
    func searchTextChanged(searchBar: UISearchBar, searchText: String)
}

/**
 Holds searchable content in a table view, and responds to UISearchBar and UIKeyboard events
 
 A SearchableContentViewController subclass:
 - Is the dataSource/delegate of searchableTableView (outletted in this class), which displays the searchable content for the page
 - Owns a UISearchBar, and is its UISearchBar's delegate
 - Overrides searchBegan, searchEnded, and/or searchTextChange as necessary to respond to search-related events
*/
class SearchableContentViewController: KeyboardObservingViewController {
    
    //the table view displaying the searchable content of this page
    @IBOutlet weak var searchableTableView: UITableView!

    //flag to track whether or not this view controller is in 'search mode' (necessary to declare this here rather than from Searchable extension)
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //don't display empty rows in table
        searchableTableView?.tableFooterView = UIView(frame: .zero)
        //searchableTableView will be adjusted to accommodate the onscreen keyboard
        
        if searchableTableView != nil {
            contentScrollView = searchableTableView
        }
    }
}

// MARK: - Search-related Methods
extension SearchableContentViewController: Searchable {
    //UISearchBarDelegate methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        searchBegan(searchBar: searchBar)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
        searchEnded(searchBar: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextChanged(searchBar: searchBar, searchText: searchText)
    }
    
    //Override these from SearchableContentViewController subclasses
    func searchBegan(searchBar: UISearchBar) {}
    func searchEnded(searchBar: UISearchBar) {}
    func searchTextChanged(searchBar: UISearchBar, searchText: String) { fatalError("SearchableContentViewController subclass must override searchTextChanged method") }
}
