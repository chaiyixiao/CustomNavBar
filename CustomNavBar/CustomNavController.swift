//
//  CustomNavController.swift
//  CustomNavBar
//
//  Created by ChaiYixiao on 30/08/2017.
//  Copyright © 2017 Duodian. All rights reserved.
//

import UIKit


class CustomNavController: UINavigationController {
    var previousTitle: String?
    var toTitle: String?
    
    private var titleObservation: NSKeyValueObservation?
    static let transitionDuration: TimeInterval = 0.3
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: CustomNavBar.self, toolbarClass: nil)
        viewControllers = [rootViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleDisplay(sender:)))
        configNavBar()
        
        //        transitionManager.popAnimator = popAnimator
        //        transitionManager.navigationController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let title = navigationController?.topViewController?.title, let navBar = navigationBar as? CustomNavBar else {
            return
        }
        navBar.fromTitle = title
    }
    
    private func configNavBar() {
        guard let navBar = navigationBar as? CustomNavBar else {
            return
        }
        navBar.popAction =  { [unowned self] in
            if (self.viewControllers.count >= 2) {
                self.popViewController(animated: true)
            }
        }
        
        titleObservation = visibleViewController?.observe(\.title, options: [.initial, .new]) { (_, title) in
            guard let _newTitle = title.newValue, let newTitle = _newTitle else { return }
            navBar.toTitle = newTitle
        }
        
        let barView = navBar.containerView
        view.addSubview(barView)
        barView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        barView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        barView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        barView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func handleDisplay(sender: UIGestureRecognizer) {
        guard let bar = navigationBar as? CustomNavBar else { return }
        
        let locationX = sender.location(in: view).x
        let progress = locationX / view.bounds.width
        
        switch sender.state {
        case .began, .changed:
            bar.fromTitleLabel.alpha = 1 - progress
            bar.toTitleLabel.alpha = progress
        default:
            break
        }
    }
}

extension CustomNavController: UINavigationBarDelegate {
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        guard let bar = navigationBar as? CustomNavBar else { return true }
        
        bar.toTitle = item.title
        let numberOfViewControllers = viewControllers.count
        if numberOfViewControllers > 1 {
            if let fromTitle = viewControllers[numberOfViewControllers - 2].title {
                bar.fromTitle = fromTitle
            }
        }
        bar.fromTitleLabel.alpha = 1
        bar.toTitleLabel.alpha = 0
        return true
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        guard let bar = navigationBar as? CustomNavBar else { return }
        bar.fromTitle = item.title
        bar.toTitle = ""
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        guard let bar = navigationBar as? CustomNavBar, viewControllers.count > 0 else { return false }
        bar.fromTitle = item.title
        let numberOfViewControllers = viewControllers.count
        if let popTitle = viewControllers[numberOfViewControllers - 1].title {
            bar.toTitle = popTitle
        }
        return true
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        guard let bar = navigationBar as? CustomNavBar else { return }
        bar.fromTitle = bar.toTitle
        bar.toTitle = ""
        bar.fromTitleLabel.alpha = 1
        bar.toTitleLabel.alpha = 0
    }
}

extension CustomNavController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let coordinator = navigationController.topViewController?.transitionCoordinator,
            let bar = navigationBar as? CustomNavBar else {
                return
        }
        coordinator.notifyWhenInteractionChanges({ (context) in
            let duration = context.transitionDuration * Double((1 - context.percentComplete))
            do {
                UIView.animate(withDuration: duration, animations: {
                    bar.fromTitleLabel.alpha = context.isCancelled ? 1 : 0
                    bar.toTitleLabel.alpha = context.isCancelled ? 0 : 1
                })
            }
        })
    }
}

