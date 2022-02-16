//
//  SideMenuViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import UIKit
import SideMenu

protocol SideMenuViewControllerDelegate: AnyObject {
    func menuViewController(_ controller: SideMenuViewController, didChangeMenuItem item: SideMenuItemType)
    func menuViewControllerCurrentActiveItem(_ controller: SideMenuViewController) -> SideMenuItemType
    func performClose(_ controller: SideMenuViewController)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    var tableView = UITableView()
    var header = UIView()
    
    let items = MenuItems()
    
    var width: CGFloat {
        return 323 + (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0)
    }
    
    var tableViewRect: CGRect {
        let size = self.view.frame.size
        let insets = UIApplication.shared.keyWindow?.safeAreaInsets
        
        return CGRect(x: 0, y: insets?.top ?? 0, width: width, height: size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame: tableViewRect)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        
        tableView.backgroundColor = .secondaryBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 48
        tableView.showsVerticalScrollIndicator = false
        
        setUpHeader()
        tableView.tableHeaderView = header
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SideMenuController.preferences.basic.menuWidth = width
        tableView.frame = tableViewRect
        
        if let activeSelectedItemType = delegate?.menuViewControllerCurrentActiveItem(self) {
            let preselectedIndexPath = items.getIndex(type: activeSelectedItemType)
            
            tableView.selectRow(at: IndexPath(row: preselectedIndexPath.row, section: preselectedIndexPath.section), animated: false, scrollPosition: .none)
        }
    }
    
    func setUpHeader() {
        let rect = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: 56)
        header = UIView(frame: rect)
        
        let closeButton = UIButton(type: .custom)
        let image = SystemAssets.xmark?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        closeButton.setImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        
        header.addSubview(closeButton)
        
        let paddingTopBottom: CGFloat = 8
        let paddingLeft: CGFloat = 275
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: header.topAnchor, constant: paddingTopBottom),
            closeButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -paddingTopBottom),
            closeButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: paddingLeft)
        ])
    }
    
    @objc func onCloseButtonTap() {
        delegate?.performClose(self)
    }
    
    func itemsForSection(_ section: Int) -> [SideMenuItem] {
        items.mainItems
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsForSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier,
                                                       for: indexPath) as? SideMenuTableViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        
        let model = itemsForSection(indexPath.section)[indexPath.row]
        
        cell.setUpWith(title: model.title, image: model.image, tintColor: model.tintColor)
        
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }
        
        let header = UIView()
        header.backgroundColor = .secondaryBackground
        
        let titleLabel = UILabel()
        
        header.addSubview(titleLabel)
        
        let paddingTopBottom: CGFloat = 16
        let paddingLeft: CGFloat = 23
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: paddingTopBottom),
            titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -paddingTopBottom),
            titleLabel.leftAnchor.constraint(equalTo: header.leftAnchor, constant: paddingLeft)
        ])
        
        titleLabel.text = "Session tools"
        titleLabel.font = UIFont.newsAppFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor.primaryInteractiveText
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = itemsForSection(indexPath.section)[indexPath.row]
        
        delegate?.menuViewController(self, didChangeMenuItem: model.type)
        delegate?.performClose(self)
    }
}
