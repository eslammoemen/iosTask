//
//  CardCustomcell.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/27/25.
//

import Foundation
import UIKit

struct CardStruct: HomeCollectionViewContact {
    var dataValue: String?
    
    func cellForItemAtItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as CardCell
        
        return cell
    }
    
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize {
        return .init(width: collectionView.frame.width - 30, height: collectionView.frame.height)
    }
}
