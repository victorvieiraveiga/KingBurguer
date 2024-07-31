//
//  ProductDetailViewController.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var id: Int!
    
    let scroll: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let container: UIStackView = {
        let v = UIStackView(arrangedSubviews: [])
        v.axis = .vertical
        v.distribution = .fill
        v.spacing = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    let containerPrice: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let nameLbl: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .red
        lb.font = .systemFont(ofSize: 20.0)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Combo XPTO"
        return lb
    }()
    
    
    let priceLbl: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .white
        lb.backgroundColor = .red
        lb.font = .systemFont(ofSize: 18.0)
        lb.layer.cornerRadius = 10
        lb.clipsToBounds = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Combo XPTO"
        lb.text = " R$ 29,90  "
        return lb
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Resgatar Cupom", for: .normal)
        btn.layer.borderColor = UIColor.systemBackground.cgColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 5
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let descLbl: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .darkText
        lb.numberOfLines = 0
        lb.sizeToFit()
        lb.font = .systemFont(ofSize: 16.0)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = ""

        return lb
    }()
    
    private let progress: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        
        aiv.backgroundColor = .systemBackground
        aiv.translatesAutoresizingMaskIntoConstraints = false
        
        return aiv
    }()

    var viewModel: ProductDetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetch(id: id)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        
        containerPrice.addSubview(nameLbl)
        containerPrice.addSubview(priceLbl)
        
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(containerPrice)
        container.addArrangedSubview(descLbl)
        
        scroll.addSubview(container)
        
        view.addSubview(scroll)
        view.addSubview(button)
        view.addSubview(progress)
        
        navigationItem.title = "Cupom"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        applyConstraints()
    }
    
    func applyConstraints() {
        let scrollConstraints = [
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        let sl = scroll.contentLayoutGuide
        let containerConstraints = [
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: sl.topAnchor),
            container.leadingAnchor.constraint(equalTo: sl.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: sl.trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(equalTo: sl.bottomAnchor),
        ]
        
        let imageConstraints = [
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let nameConstraints = [
            nameLbl.leadingAnchor.constraint(equalTo: containerPrice.leadingAnchor, constant: 20),
            nameLbl.topAnchor.constraint(equalTo: containerPrice.topAnchor, constant: 10),
        ]
        
        let priceConstraints = [
            priceLbl.trailingAnchor.constraint(equalTo: containerPrice.trailingAnchor, constant: -20),
            priceLbl.topAnchor.constraint(equalTo: containerPrice.topAnchor, constant: 10),
        ]
        
        let containerPriceConstraints = [
            containerPrice.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let buttonConstraints = [
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let progressConstraints = [
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progress.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progress.topAnchor.constraint(equalTo: view.topAnchor),
        ]
        
        NSLayoutConstraint.activate(buttonConstraints)
        NSLayoutConstraint.activate(nameConstraints)
        NSLayoutConstraint.activate(priceConstraints)
        NSLayoutConstraint.activate(containerPriceConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(progressConstraints)
    }
    
}

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    
    func viewModelDidChanged(state: ProductDetailState) {
        switch(state) {
            case .loading:
            progress.startAnimating()
                break
                
            case .success(let response):
            self.nameLbl.text = response.name
            self.descLbl.text = response.description
            
            if let price = response.price.toCurrency() {
                self.priceLbl.text = " \(price)"
            }
            
            guard let url = URL(string: response.pictureUrl) else { break }
            self.imageView.sd_setImage(with: url)
                progress.stopAnimating()
                break
                
            case .error(let msg):
                progress.stopAnimating()
                break
                
        }
    }
}
