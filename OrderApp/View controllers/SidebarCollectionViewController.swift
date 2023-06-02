//
//  SidebarCollectionViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/02.
//

import UIKit


final class SidebarCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(Self.generateLayout(), animated: false)
        clearsSelectionOnViewWillAppear = false
        dataSource.apply(snapshot)
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let svc = splitViewController as? RootSplitViewController else { return }
        svc.selectedMenu = menuItem
    }
    
    private static func generateLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private let cellReg = CellRegistration { cell, indexPath, item in
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = item.image
        cell.contentConfiguration = config
    }
    
    private lazy var dataSource = DataSource(collectionView: collectionView) { [cellReg] collectionView, indexPath, menuItem in
        collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: menuItem.item)
    }
    
    private var snapshot: Snapshot {
        var sn = Snapshot()
        sn.appendSections([.main])
        sn.appendItems(items, toSection: .main)
        return sn
    }
    
    private var items: [MenuItem] { MenuItem.allCases }
    
}


// MARK: Types
extension SidebarCollectionViewController {
    
    typealias Cell = UICollectionViewListCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    typealias MenuItem = RootSplitViewController.MenuItem
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MenuItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MenuItem>
    
    struct Item: Hashable {
        var title: String
        var image: UIImage?
    }
    
    enum Section: Hashable {
        case main
    }
    
}
