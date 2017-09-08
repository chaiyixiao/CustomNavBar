//
//  FirstVC.swift
//  CustomNavigationBar
//
//  Created by ChaiYixiao on 30/08/2017.
//  Copyright © 2017 Duodian. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FIRST"
        view.backgroundColor = UIColor(red: 59.0/255.0, green: 62.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        
        let pushButton: UIButton = {
            let b = UIButton()
            b.setTitle("PUSH-1", for: .normal)
            b.sizeToFit()
            b.center = view.center
            b.setTitleColor(.white, for: .normal)
            b.addTarget(self, action: #selector(push), for: .touchUpInside)
            return b
        }()
        view.addSubview(pushButton)
    }
    
    @objc func push() {
        navigationController?.pushViewController(SecondVC(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
