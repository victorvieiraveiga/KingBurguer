//
//  FeedTableViewCell.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 20/05/24.
//

import UIKit
import SDWebImage

protocol FeedCollectionViewDelegate {
    func itemSelected(productId: Int)
}

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    var products: [ProductResponse] = []
    var delegate: FeedCollectionViewDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 220)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // cv.backgroundColor = .blue
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGreen
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension FeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell

        let product = products[indexPath.row]
        cell.product = product
        
        if let url = URL(string: product.pictureUrl) {
            cell.imageView.sd_setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemSelected(productId: products[indexPath.row].id)
    }
}
