//
//  CategoryCell.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/27/25.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak private var cellLabel: UILabel!
    
    func setCellText(text: String?) {
        cellLabel.text = text
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
