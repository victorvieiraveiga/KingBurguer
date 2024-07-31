//
//  HomeCoordinator.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 10/05/24.
//

import UIKit

class HomeCoordinator {
    private let window: UIWindow?
    
    let navFeedVC = UINavigationController()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let homeVC = HomeViewController()
        
        let feedCoordinator = FeedCoordinator(navFeedVC)
        feedCoordinator.start()
        homeVC.setViewControllers([navFeedVC], animated: true)
        window?.rootViewController = homeVC
    }
}
