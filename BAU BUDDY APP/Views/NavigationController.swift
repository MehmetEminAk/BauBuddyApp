//
//  MainVC.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 2.03.2023.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tasksVC = TasksVC()
        
        setViewControllers([tasksVC], animated: true)
        
    }
    

}
