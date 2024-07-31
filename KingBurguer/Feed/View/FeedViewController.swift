//
//  FeedViewController.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 17/05/24.
//

import UIKit
import SDWebImage

class FeedViewController: UIViewController {
    
    var sections: [CategoryResponse] = []
    
    private var headerView: HighlightView!
    
    private let progress: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        
        aiv.backgroundColor = .systemBackground
        aiv.startAnimating()
        
        return aiv
    }()
   
    private let homeFeedTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        
        tv.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tv.backgroundColor = UIColor.systemBackground
        
        return tv
    }()
    
    var viewModel: FeedViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.title = "Inicio"
        navigationController?.tabBarItem.image = UIImage(systemName: "house")
        
        view.addSubview(homeFeedTable)
        view.addSubview(progress)
        
        headerView = HighlightView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 210))
        headerView.backgroundColor = .orange
        headerView.delegate = self
        
        homeFeedTable.tableHeaderView = headerView
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        viewModel?.fetch()
        viewModel?.fetchHighlight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        progress.frame = view.bounds
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor.red
        
        navigationItem.title = "Produtos"
        
        var image = UIImage(named: "icon")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(testDidTap)),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        ]
    }
    
    @objc func testDidTap(_ sender: UIBarButtonItem) {
        print("CLICOU!!!!!!!!!!")
    }

}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // numero de linhas na secao
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        // neste exato momento eu tenho o UITableViewHeaderFooterView efetivamente!!!!
        
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 120, height: header.bounds.height)
        header.textLabel?.textColor = .label

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        
        cell.products.append(contentsOf: sections[indexPath.section].products)
        cell.delegate = self
        return cell
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func viewModelDidChanged(state: FeedState) {
        switch(state) {
            case .loading:
                break
                
            case .success(let response):
                progress.stopAnimating()
                self.sections = response.categories
                self.homeFeedTable.reloadData()
                break
                
            case .successHighlight(let response):
                guard let url = URL(string: response.pictureUrl) else { break }
                headerView.imageView.sd_setImage(with: url)
                headerView.productId = response.productId
                break
                
            case .error(let msg):
                progress.stopAnimating()
                self.homeFeedTable.reloadData()
                break   
        }
    }
}

extension FeedViewController: FeedCollectionViewDelegate {
    func itemSelected(productId: Int) {
        viewModel?.goToProductDetail(productId: productId)
    }
}

extension FeedViewController: HighlightViewDelegate {
    func highlightSelected(productId: Int) {
        viewModel?.goToProductDetail(productId: productId)
    }
}
