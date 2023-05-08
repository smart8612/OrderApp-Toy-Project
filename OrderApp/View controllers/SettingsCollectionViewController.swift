//
//  SettingsCollectionViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import UIKit
import Combine


final class SettingsCollectionViewController: UICollectionViewController {
    
    private let viewModel = SettingsViewModel()
    
    private var subscription: Cancellable?

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
    
    private func updateStatus() {
        dataSource.apply(snapshot)
    }
    
    private func configureUI() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func configureSubscriber() {
        subscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink {
            [weak self] _ in
            self?.updateStatus()
        }
    }
    
    private var snapshot: NSDiffableDataSourceSnapshot<SettingsViewModel.Section, SettingsViewModel.Item<Int>> {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsViewModel.Section, SettingsViewModel.Item<Int>>()
        
        let settingItems = viewModel.items
        let keys = Array(settingItems.keys)
        snapshot.appendSections(keys)
        keys.forEach { snapshot.appendItems(settingItems[$0] ?? [], toSection: $0) }
        
        return snapshot
    }
    
    private var cellRegistration = UICollectionView.CellRegistration<CheckableCollectionViewListCell, SettingsViewModel.Item<Int>> { (cell, indexPath, item) in
        cell.title = item.title
        cell.value = item.isChecked
    }
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<SettingsViewModel.Section, SettingsViewModel.Item<Int>>(collectionView: collectionView) { [weak self]
        (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let cellRegistration = self?.cellRegistration else { return nil }
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let schema = UIUserInterfaceStyle(rawValue: item.value) else { return }
        UserDefaults.standard.colorSchema = schema
    }

}
