//
//  PopoverTableViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

/// A simple and reusable popover menu.
///
/// Example usage:
/// ```
///  let participantsController = PopoverTableViewController()
///
///  let menuItems = Array(session.participantUsernames.map {
///    PopoverMenuItem(title: $0, menuItemAction: nil)
///  })
///
///  participantsController.setMenuItemsAndReloadData(menuItems)
///
///  participantsController.modalPresentationStyle = .popover
///  participantsController.popoverPresentationController?.sourceView = navigationItem.titleView
///  participantsController.popoverPresentationController?.sourceRect = navigationItem.titleView?.bounds ?? .zero
///  participantsController.popoverPresentationController?.permittedArrowDirections = .up
///  participantsController.popoverPresentationController?.delegate = self
///
///  let contentHeight = menuItems.count > 4 ? 200 : menuItems.count * 50
///
///  participantsController.preferredContentSize = CGSize(width: 200, height: contentHeight)
///
///  present(participantsController, animated: true, completion: nil)
/// ```
///
/// Last person to read this could also remove it.
class PopoverTableViewController: UITableViewController {
    
    var menuItems: [PopoverMenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .primaryBackgrond
        
        tableView.register(PopoverTableViewCell.self, forCellReuseIdentifier: PopoverTableViewCell.identifier)
        tableView.rowHeight = 50
        tableView.layer.cornerRadius = 12
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    
    }
    
    func setMenuItemsAndReloadData(_ menuItems: [PopoverMenuItem]) {
        self.menuItems = menuItems
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopoverTableViewCell.identifier, for: indexPath) as? PopoverTableViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        let menuItem = menuItems[indexPath.row]
        cell.setUpWith(menuItem: menuItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        if let action = menuItem.menuItemAction {
            self.dismiss(animated: true, completion: action)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
