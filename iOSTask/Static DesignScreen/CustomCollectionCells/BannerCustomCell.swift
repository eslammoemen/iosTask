//
//  BannerCustomCell.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/27/25.
//

import Foundation
import UIKit

class BannerTableCell: HomeTableViewContact {
    var sectionHeight: CGFloat
    var sectionId: Int
    var sectionFlowStyle: [any HomeCollectionViewContact]?
    
    
    init(sectionId: Int, sectionHeight: CGFloat, sectionFlowStyle: [any HomeCollectionViewContact]? = nil) {
        self.sectionId = sectionId
        self.sectionHeight = sectionHeight
        self.sectionFlowStyle = sectionFlowStyle
    }
    
    func rowForItemAtItem(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as HomeTableCell
        return cell
    }
    
}

struct BannerStruct: HomeCollectionViewContact {
    var dataValue: String?
    
    func cellForItemAtItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as BannerCell
        
        return cell
    }
    
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize {
        return .init(width: 70, height: 85)
    }
    
}
