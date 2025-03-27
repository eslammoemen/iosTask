//
//  StaticScreenViewModel.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/26/25.
//

import Foundation
import UIKit
import Combine

protocol HomeTableViewContact {
    var sectionId: Int { get set }
    var sectionHeight: CGFloat { get set }
    var sectionFlowStyle: [any HomeCollectionViewContact]? { get set }
    
    func rowForItemAtItem(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol HomeCollectionViewContact {
    
    associatedtype ModelType
    
    var dataValue: ModelType? { get set }

    func cellForItemAtItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize
    
}

final class StaticScreenViewModel: BaseViewModelProtocol {
    var viewStatesPublisher: PassthroughSubject<ViewState, Never> = .init()
    
    private (set) var homeCollectionData = [HomeTableViewContact]() {
        didSet {
            homeDataResponsePublisher.send()
        }
    }
    var homeDataResponsePublisher: PassthroughSubject<Void, Never> = .init()
    
    func homeDataPublisher() -> AnyPublisher<Void, Never> {
        return homeDataResponsePublisher.voidPublisher()
    }
    func viewModelDidLoad() {
        homeCollectionData.append(BannerTableCell(
            sectionId: 1,
            sectionHeight: 120,
            sectionFlowStyle: [BannerStruct(dataValue: "somedata"), BannerStruct(dataValue: "somedata"), BannerStruct(dataValue: "somedata")]))
        homeCollectionData.append(CategoryTableCell(sectionId: 2, sectionHeight: 60, sectionFlowStyle: [CategoryStruct(dataValue: "UI/UX"), CategoryStruct(dataValue: "Illustration")]))
        
        homeCollectionData.append(CategoryTableCell(sectionId: 3, sectionHeight: 360, sectionFlowStyle: [CardStruct(dataValue: "")]))
    }
    
    func itemAtIndex(section: Int) -> HomeTableViewContact {
        return homeCollectionData[section]
    }
    
    func numberOfitems() -> Int {
        return homeCollectionData.count
    }
    
}



