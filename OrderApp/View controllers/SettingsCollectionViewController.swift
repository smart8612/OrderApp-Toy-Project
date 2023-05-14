//
//  SettingsCollectionViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import UIKit
import Combine


final class SettingsCollectionViewController<ViewModelType: SettingPresentable>: UICollectionViewController {
    
    private let viewModel: ViewModelType
    weak var settingDelegate: (any SettingPresentableDelegate)?
    
    private var subscription: Cancellable?
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.listLayout())
    }
    
    init?(coder: NSCoder, viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureSubscriber()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        subscription?.cancel()
    }
    
    private func configureSubscriber() {
        subscription = NotificationCenter.default.publisher(
            for: UserDefaults.didChangeNotification
        ).sink { [weak self] _ in
            self?.updateStatus()
        }
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let currentSnapshot = dataSource.snapshot()
            let section = currentSnapshot.sectionIdentifiers[indexPath.section]
            
            let cell = collectionView.dequeueConfiguredReusableSupplementary(
                using: (kind == UICollectionView.elementKindSectionHeader) ? self.headerRegistration:self.footerRegistration,
                for: indexPath
            )
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = (kind == UICollectionView.elementKindSectionHeader) ? section.title:section.description
            cell.contentConfiguration = contentConfig
            
            return cell
        }
        
        return dataSource
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if item.isGroup {
            settingDelegate?.provideSettingViewController(of: item) { item, vc in
                vc.title = item.title
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        (cell: UICollectionViewListCell, indexPath: IndexPath, item: Item) in
        var contentConfigure = cell.defaultContentConfiguration()
        contentConfigure.text = item.title
        cell.contentConfiguration = contentConfigure
        
        var cellAccessories: [UICellAccessory] = []
        
        if item.isGroup == true {
            cellAccessories.append(.disclosureIndicator())
        }
        
        if item.isChecked == true {
            cellAccessories.append(.checkmark())
        }
        
        if let supplementaryTitle = item.description {
            cellAccessories.append(.label(text: supplementaryTitle))
        }
        
        cell.accessories = cellAccessories
    }
    
    private let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
        elementKind: UICollectionView.elementKindSectionHeader
        , handler: { (_, _, _) in })
    
    private let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
        elementKind: UICollectionView.elementKindSectionFooter
        , handler: { (_, _, _) in })

}

/// MARK : Typealisas
extension SettingsCollectionViewController {
    
    typealias Section = ViewModelType.Section
    typealias Item = ViewModelType.Item
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
}

/// MARK : Manage UI hierarchy presentation
extension SettingsCollectionViewController {
    
    private static func listLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        config.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureUI() {
        collectionView.setCollectionViewLayout(Self.listLayout(), animated: false)
    }
    
}

/// MARK : Manage UI status data
extension SettingsCollectionViewController {
    
    private var snapshot: Snapshot {
        var snapshot = Snapshot()
        
        let settingItems = viewModel.items
        
        settingItems.forEach { item in
            let section = item.section as! ViewModelType.Section
            if snapshot.indexOfSection(section) == .none {
                snapshot.appendSections([section])
            }
            snapshot.appendItems([item], toSection: section)
        }
        
        return snapshot
    }
    
    private func updateStatus() {
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
