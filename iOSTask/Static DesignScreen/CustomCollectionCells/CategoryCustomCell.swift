//
//  CategoryCustomCell.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/27/25.
//

import Foundation
import UIKit

class CategoryTableCell: HomeTableViewContact {
    var sectionHeight: CGFloat
    var sectionId: Int
    var sectionFlowStyle: [any HomeCollectionViewContact]?
    
    
    init(sectionId: Int, sectionHeight: CGFloat, sectionFlowStyle: [any HomeCollectionViewContact]? = nil) {
        self.sectionId = sectionId
        self.sectionHeight = sectionHeight
        self.sectionFlowStyle = sectionFlowStyle
    }
    
    func rowForItemAtItem(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CourseCatCell
        return cell
    }
    
}

struct CategoryStruct: HomeCollectionViewContact {
    var dataValue: String?
    
    func cellForItemAtItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as CategoryCell
        cell.setCellText(text: dataValue)
        
        return cell
    }
    
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.text = dataValue
        label.sizeToFit()
        return .init(width: label.frame.width + 30, height: 41)
    }
}
