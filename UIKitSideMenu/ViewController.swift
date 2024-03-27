//
//  ViewController.swift
//  UIKitSideMenu
//
//  Created by Roderick Presswood on 3/27/24.
//

import UIKit

protocol CloseButton: AnyObject {
    func closeMenu()
}

class ViewController: UIViewController, CloseButton {
    func closeMenu() {
        hideSideMenu()
    }
    
    private var menuButton: UIButton = {
       let button = UIButton()
        button.setTitle("Press Here", for: .normal)
        button.backgroundColor = .purple
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openMenu(_:)), for: .touchUpInside)
        return button
    }()

    var sideMenuViewController: SideMenuViewController?
    var isSideMenuPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(menuButton)
//        view.backgroundColor =
        
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func openMenu(_ sender: UIButton) {
        if isSideMenuPresented {
            hideSideMenu()
        } else {
            showSideMenu()
        }
    }
    
    private func showSideMenu() {
        guard sideMenuViewController == nil else { return }
        
        let sideMenuVC = SideMenuViewController()
        sideMenuVC.delegate = self
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        
        // Initially off-screen to the left
                sideMenuVC.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width - 100, height: view.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            sideMenuVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: self.view.frame.height)
        } completion: { _ in
            sideMenuVC.didMove(toParent: self)
            self.sideMenuViewController = sideMenuVC
            self.isSideMenuPresented = true
        }
    }
    
    private func hideSideMenu() {
        guard let sideMenuVC = sideMenuViewController else { return }
        
        UIView.animate(withDuration: 0.3) {
            sideMenuVC.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        } completion: { _ in
            sideMenuVC.willMove(toParent: nil)
            sideMenuVC.view.removeFromSuperview()
            sideMenuVC.removeFromParent()
            self.sideMenuViewController = nil
            self.isSideMenuPresented = false
        }
    }

}

