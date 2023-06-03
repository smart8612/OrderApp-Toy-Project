//
//  SidebarCollectionViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/02.
//

import UIKit


final class SidebarCollectionViewController: UICollectionViewController {
    
    private var rootSplitViewController: RootSplitViewController? {
        splitViewController as? RootSplitViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(Self.generateLayout(), animated: false)
        clearsSelectionOnViewWillAppear = false
        dataSource.apply(snapshot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSideBarCell(at: rootSplitViewController?.selectedMenu ?? .restaurant)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let svc = rootSplitViewController else { return }
        svc.selectedMenu = menuItem
    }
    
    func selectSideBarCell(at tabItem: TabItem) {
        guard let indexPath = dataSource.indexPath(for: tabItem) else { return }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
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
    
    private lazy var dataSource = DataSource(collectionView: collectionView) { [cellReg] collectionView, indexPath, tabItem in
        collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: tabItem.item)
    }
    
    private var snapshot: Snapshot {
        var sn = Snapshot()
        sn.appendSections([.main])
        sn.appendItems(TabItem.allCases, toSection: .main)
        return sn
    }
    
}


// MARK: Types
extension SidebarCollectionViewController {
    
    typealias Cell = UICollectionViewListCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    
    typealias TabItem = RootSplitViewController.TabItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TabItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TabItem>
    
    struct Item: Hashable {
        var title: String
        var image: UIImage?
    }
    
    enum Section: Hashable {
        case main
    }
    
}
