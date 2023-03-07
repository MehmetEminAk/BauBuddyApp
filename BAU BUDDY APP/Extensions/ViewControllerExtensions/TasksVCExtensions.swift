//
//  TasksVCExtensions.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 7.03.2023.
//

import Foundation
import UIKit

extension TasksVC : UITableViewDelegate , UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRowAt(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
}

extension TasksVC {
    
    @objc func updateUI(){
        viewModel.updateView()
    }
}


extension TasksVC :  UISearchControllerDelegate , UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextChanged(searchText: searchText)
    }

}

extension TasksVC {
    @objc func openQRScannerVC(){
        viewModel.openQrScanner()
    }
}



