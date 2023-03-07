//
//  ViewController.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 1.03.2023.
//

import UIKit
import RealmSwift
import JGProgressHUD

class TasksVC: UIViewController {
    var qrCodeText : String?
    var viewModel :  ViewModel!
    
    let progress : JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.frame = CGRect(x: Int(deviceWidth) / 2 - 100, y: Int(deviceHeight) / 2 - 100, width: 100, height: 100)
        return hud
    }()
    
    let tasksTable : UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight))
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel(view: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("datasChanged"), object: nil)
        
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(openQRScannerVC))
        
        
        view.addSubview(tasksTable)
        progress.show(in: view)
        
        
        viewModel.configureSearchbar()
        viewModel.configureTable()
        viewModel.fetchDatas()
        
        if let _ = qrText {
            navigationController?.navigationBar.topItem?.searchController?.searchBar.text = qrText
        }
        
        
        }
    override func viewWillAppear(_ animated: Bool) {
        if qrCodeText != nil {
        
            self.navigationController?.navigationBar.topItem?.searchController?.searchBar.text = self.qrCodeText
    
        }
    }
}


