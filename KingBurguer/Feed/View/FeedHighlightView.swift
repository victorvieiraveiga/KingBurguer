//
//  FeedHighlightView.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 22/05/24.
//

import UIKit

protocol HighlightViewDelegate {
    func highlightSelected(productId: Int)
}

class HighlightView: UIView {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "highlight")
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Resgatar Cupom", for: .normal)
        btn.layer.borderColor = UIColor.systemBackground.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    var delegate: HighlightViewDelegate?
    var productId: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        addGradient()
        
        addSubview(moreButton)
        applyConstraints()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor, // 33%
            UIColor.clear.cgColor, // 33%
            UIColor.black.cgColor  // 33%
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        let moreButtonConstraints = [
            moreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -8),
            moreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(moreButtonConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func buttonTapped() {
        delegate?.highlightSelected(productId: productId ?? 0)
    }
}
