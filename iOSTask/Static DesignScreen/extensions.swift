//
//  extensions.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/26/25.
//

import Foundation
import UIKit

public extension UITableView {
    func addFooterSpinnerView(spinnerColor: UIColor) {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = spinnerColor
        footerView.addSubview(spinner)
        footerView.layoutIfNeeded()
        spinner.startAnimating()
        
        tableFooterView = footerView
    }

    func register<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellType.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(nibType: T.Type) {
        let nib = UINib(nibName: nibType.className, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: nibType.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T? {
        let cell = self.dequeueReusableCell(withIdentifier: T.className)
        return cell as? T
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: T.className)
        return cell as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath)
        return cell as! T
    }
    
    func updateEmptyState(emptyView: UIView?) {
        self.backgroundView = emptyView
    }
}

public extension UICollectionView {

    enum SupplementaryView {
        case header
        case footer
        var id: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }

    func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, kind: SupplementaryView) {
        let nib = UINib(nibName: supplementaryViewType.className, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind.id, withReuseIdentifier: supplementaryViewType.className)
    }
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellType.className)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath)
        return cell as! T
    }
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: UICollectionView.SupplementaryView,
                                                                       for indexPath: IndexPath) -> T {
        let supplementaryView = self.dequeueReusableSupplementaryView(ofKind: ofKind.id,
                                                                      withReuseIdentifier: T.className, for: indexPath)
        return supplementaryView as! T
    }

    func reloadData(_ completion: (() -> Void)? = nil) {
        reloadData()
        DispatchQueue.main.async {
            completion?()
        }
    }
}

public extension NSObject {
    /// Value that represents a className as a string value
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return String(describing: self)
    }
}

import Combine

public extension Publisher {
    /// Maps the `Output` of its upstream to `Void` and type erases its upstream to `AnyPublisher`.
    func voidPublisher() -> AnyPublisher<Void, Failure> {
        map { _ in Void() }
        .eraseToAnyPublisher()
    }
}

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {

            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{

        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {

            layer.shadowOpacity = newValue

        }
    }
}
