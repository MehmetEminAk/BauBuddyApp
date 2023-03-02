//
//  ViewController.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 1.03.2023.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    
    private var tasksTitles : [String] = []
    private var tasks : [String] = []
    private var tasksDescription : [String] = []
    private var tasksColor : [String] = []
    private var filteredTaskList : [RealmTask] = []
    private var taskList : [RealmTask] = []

    
    private let tasksTable : UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight))
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchbar()
        
        view.addSubview(tasksTable)
        
        configureTable()
        
        if isInternetAvailable() {
            NetworkOperations.shared.requestAuthInfos { authResult in
                 switch authResult {
                 case .success(let authInfos):
                     
                     let headers = [
                         "Authorization": "\(authInfos[0]) \(authInfos[1])",
                       "Content-Type": "application/json"
                     ]
                     
                     let request = NetworkOperations.shared.createRequest(url: URL(string: tasksUrl)! , headers: headers)
                     
                     NetworkOperations.shared.fetchDatasFromUrlRequest(urlRequest: request, expectingType: Task.self) { result in
                         switch result {
                         case .success(let tasks):
                             
                             //Remove all old tasks in local database
                             
                             try! RealmInstance.shared.write {
                                 RealmInstance.shared.deleteAll()
                             }
                             
                             //Add all new tasks which are they come from api to the local database
                             tasks.forEach { task in
                                 
                                 
                                 let realmTask = RealmTask()
                                 realmTask.declareAttributes(data: ["task" : task.task , "description" : task.description , "title" : task.title , "colorCode" : task.colorCode])
                                 
                                 self.savetoLocalDatabase(record: realmTask, expectingType: RealmTask.self, realm: RealmInstance.shared)
                                 self.tasks.append(realmTask.task)
                                 self.tasksTitles.append(realmTask.title)
                                 self.tasksDescription.append(realmTask.descript)
                                 self.tasksColor.append(realmTask.colorCode)
                                 self.filteredTaskList.append(realmTask)
                                 self.taskList.append(realmTask)
                                 
                             }
                             
                             DispatchQueue.main.async {
                                 self.tasksTable.reloadData()
                             }
                             
                             
                             
                             
                         case .failure(let error):
                             print(error.localizedDescription)
                         }
                     }
                     
                     
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
                 
             }
        }
        else {
            let tasks = RealmInstance.shared.objects(RealmTask.self)
            tasks.forEach { realmTask in
                self.tasks.append(realmTask.task)
                self.tasksTitles.append(realmTask.title)
                self.tasksDescription.append(realmTask.descript)
                self.tasksColor.append(realmTask.colorCode)
            }
            DispatchQueue.main.async {
                self.tasksTable.reloadData()
            }
            
        }
        
        
        }
    
}


extension ViewController {
    
    
    func savetoLocalDatabase<T : Object>(record : T,expectingType : T.Type,realm : Realm) {
       
        try! realm.write {
            realm.add(record)
        }
        
    }
    func fetchFromLocalDatabase<T : Object>(realm : Realm ,targetClass : T.Type) -> Results<T> {
        let datas = realm.objects(targetClass.self)
        return datas
    }
    
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasksTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = tasksTitles[indexPath.row]
        content.secondaryText = "\n \n \(tasks[indexPath.row]) \n \n\n \(tasksDescription[indexPath.row])"
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor(hexString: tasksColor[indexPath.row], alpha: 1)
        
        return cell
        
    }
    
    func configureTable(){
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}


extension ViewController :  UISearchControllerDelegate , UISearchBarDelegate  {
    
    func configureSearchbar(){
        let searchController = UISearchController()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.topItem?.searchController = searchController
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.count > 2  {
            let a =  filteredTaskList.filter { realmTask in
                return realmTask.task.lowercased().contains(searchText.lowercased()) || realmTask.colorCode.lowercased().contains(searchText.lowercased()) || realmTask.title.lowercased().contains(searchText.lowercased()) ||
                realmTask.descript.lowercased().contains(searchText.lowercased())
            }
        }else {
            
        }
    }
}


