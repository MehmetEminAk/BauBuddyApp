//
//  SearchViewModel.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 7.03.2023.
//

import Foundation
import UIKit

//This extension is about tasks table operations
extension ViewModel {
    
    public func numberOfRows() -> Int {
        return self.filteredTasks.count
    }
    
    func cellForRowAt(indexPath : IndexPath) -> UITableViewCell {
        let cell = view!.tasksTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "\(filteredTasks[indexPath.row].title)"
        content.secondaryText = "\n \n \(filteredTasks[indexPath.row].task) \n \n\n \(filteredTasks[indexPath.row].descript)"
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor(hexString: filteredTasks[indexPath.row].colorCode, alpha: 1)
        
        return cell
    }
    
    
    
    func configureTable(){
        view!.tasksTable.delegate = view
        view!.tasksTable.dataSource = view
        view!.tasksTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}


//This extension is consist of searchbar operations
extension ViewModel {
    
    func configureSearchbar(){
        let searchController = UISearchController()
        searchController.delegate = view
        searchController.searchBar.delegate = view
        view?.navigationController?.navigationBar.topItem?.searchController = searchController
        
    }
    
    func searchTextChanged(searchText : String){
        if searchText.count > 1 {
            filteredTasks = tasks.filter { realmTask in
                return realmTask.title.contains(searchText) || realmTask.descript.contains(searchText) || realmTask.colorCode.contains(searchText) || realmTask.task.contains(searchText)
            }
            NotificationCenter.default.post(name: NSNotification.Name("datasChanged"), object: nil)
        }
        else {
            filteredTasks = tasks
            NotificationCenter.default.post(name: NSNotification.Name("datasChanged"), object: nil)

        }
    }
}

extension ViewModel {
    func openQrScanner(){
        var vc = ScannerVC()
        vc.modalPresentationStyle = .fullScreen
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
