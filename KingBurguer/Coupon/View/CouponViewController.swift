//
//  CouponViewController.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 17/05/24.
//

import UIKit

class CouponViewController: UIViewController {

    let test: UIView = {
        let view = UIView(frame: CGRect(x: 20, y: 90, width: 20, height: 20))
        view.backgroundColor = .purple
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(test)
    }
}
