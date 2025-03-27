//
//  StaticDesignScreen.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/26/25.
//

import UIKit
import Combine

class StaticDesignScreen: BaseViewController<StaticScreenViewModel> {
    
    @IBOutlet weak var containTableView: UITableView!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containTableView.delegate = self
        containTableView.dataSource = self
        containTableView.register(cellType: HomeTableCell.self)
        containTableView.register(cellType: CourseCatCell.self)
        viewModel
            .homeDataPublisher()
            .sink { [weak self] in
                guard let self = self else { return }
                containTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension StaticDesignScreen: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfitems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.itemAtIndex(section: indexPath.row).rowForItemAtItem(tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.itemAtIndex(section: indexPath.row).sectionHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let cell = cell as? HomeTableCell {
            cell.itemsCollectionView.dataSource = self
            cell.itemsCollectionView.delegate = self
            cell.itemsCollectionView.tag = indexPath.item
            cell.itemsCollectionView.register(cellType: BannerCell.self)
//            cell.itemsCollectionView.register(cellType: ServiceCollectionViewCell.self)
            cell.itemsCollectionView.reloadData()
        } else if let cell = cell as? CourseCatCell {
            cell.itemsCollectionView.dataSource = self
            cell.itemsCollectionView.delegate = self
            cell.itemsCollectionView.tag = indexPath.item
            cell.itemsCollectionView.register(cellType: CategoryCell.self)
            cell.itemsCollectionView.register(cellType: CardCell.self)
            cell.itemsCollectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension StaticDesignScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemAtIndex(section: collectionView.tag).sectionFlowStyle?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = viewModel.itemAtIndex(section: collectionView.tag).sectionFlowStyle?[indexPath.row].cellForItemAtItem(collectionView: collectionView, indexPath: indexPath) {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.itemAtIndex(section: collectionView.tag).sectionFlowStyle?[indexPath.row].sizeForItemAt(collectionView: collectionView) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13.2
    }
    
}


