//
//  CardCell.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/27/25.
//

import UIKit

class CardCell: UICollectionViewCell {

    @IBOutlet weak var backImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
    }
    
    private func setupGradient() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor,
                                    UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1) // Bottom
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0) // Top
            layer.insertSublayer(gradientLayer, at: 0)
        }
    
    override func layoutSubviews() {
            super.layoutSubviews()
        backImage.layer.frame = bounds // Ensure gradient updates on resize
        }
        
}
