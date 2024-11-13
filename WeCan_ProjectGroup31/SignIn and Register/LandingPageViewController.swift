//
//  LandingPageViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/15/24.
//

import UIKit

class LandingPageViewController: UIViewController {

    var landingPage = LandingPageView()
    
    override func loadView() {
        view = landingPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        landingPage.signInButoon.addTarget(self, action: #selector(onButtonSignInTapped), for: .touchUpInside)
        landingPage.registerButoon.addTarget(self, action: #selector(onButtonRegisterTapped), for: .touchUpInside)
    }
    
    @objc func onButtonSignInTapped(){
        
    }
    
    @objc func onButtonRegisterTapped(){
        
    }


}

