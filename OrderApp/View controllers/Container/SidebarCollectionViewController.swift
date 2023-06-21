//
//  SidebarCollectionViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/02.
//

import UIKit


final class SidebarCollectionViewController: UICollectionViewController {
    
    private var rootViewController: RootViewController? {
        splitViewController?.parent as? RootViewController
    }
    
    init() { super.init(collectionViewLayout: Self.generateLayout()) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionView.setCollectionViewLayout(Self.generateLayout(), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Order"
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.apply(snapshot)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let selectedMenu = rootViewController?.selectedMenu else { return }
        selectSideBarCell(at: selectedMenu)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        rootViewController?.selectedMenu = menuItem
    }
    
    private func selectSideBarCell(at tabItem: TabItem) {
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
    
    typealias TabItem = RootViewController.TabItem
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
