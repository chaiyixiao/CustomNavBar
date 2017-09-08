//
//  ViewController.swift
//  CustomNavigationBar
//
//  Created by ChaiYixiao on 30/08/2017.
//  Copyright © 2017 Duodian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ViewController"
        view.backgroundColor = UIColor(red: 59.0/255.0, green: 62.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        
        let pushButton: UIButton = {
            let b = UIButton()
            b.setTitle("PUSH", for: .normal)
            b.sizeToFit()
            b.center = view.center
            b.setTitleColor(.white, for: .normal)
            b.addTarget(self, action: #selector(push), for: .touchUpInside)
            return b
        }()
        view.addSubview(pushButton)
    }

    @objc func push() {
        navigationController?.pushViewController(FirstVC(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


