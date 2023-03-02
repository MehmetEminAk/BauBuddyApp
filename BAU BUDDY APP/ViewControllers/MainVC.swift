//
//  MainVC.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 2.03.2023.
//

import UIKit

class MainVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tasksVC = ViewController()
        tasksVC.tabBarItem = UITabBarItem(title: "TASK", image: .checkmark, tag: 0)
        
        let nav = UINavigationController(rootViewController: tasksVC)
        
        setViewControllers([nav], animated: true)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
