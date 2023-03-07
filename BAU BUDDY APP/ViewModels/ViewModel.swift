//
//  ViewModel.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 3.03.2023.
//

import Foundation
import UIKit

protocol ViewModelProtocol {
    func fetchDatas()
    func updateView()
}

class ViewModel : ViewModelProtocol {
    weak var view : TasksVC?
    var localDatabase = LocalDatabase()
    
    public var tasks : [RealmTask] = []
    public var filteredTasks : [RealmTask] = []
    
    init(view : TasksVC) {  self.view = view }
    
    func updateView() {
        DispatchQueue.main.async {
            self.view!.tasksTable.reloadData()
        }
    }
    
    func fetchDatas(){
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
                            
                            DispatchQueue.main.async {
                                self.localDatabase.removeAllDatas()
                            }
                            
                            //Add all new tasks which are they come from api to the local database
                            tasks.forEach { task in
                                
                                let realmTask = RealmTask()
                                
                                realmTask.declareAttributes(data: ["task" : task.task , "description" : task.description , "title" : task.title , "colorCode" : task.colorCode])
                                
                                DispatchQueue.main.async {
                                    
                                    self.localDatabase.savetoLocalDatabase(record: realmTask, expectingType: RealmTask.self, realm: RealmInstance.shared)
                                    self.tasks.append(realmTask)
                                    self.filteredTasks.append(realmTask)
                                    self.view?.progress.dismiss(animated: true)
                                    
                                }
                                
                            }
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name("datasChanged"), object: nil)
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
            DispatchQueue.main.async {
                
                self.filteredTasks.removeAll()
                let tasks = RealmInstance.shared.objects(RealmTask.self)
                tasks.forEach { realmTask in
                    self.filteredTasks.append(realmTask)
                    self.tasks.append(realmTask)
                    self.view?.progress.dismiss(animated: true)
                }
                NotificationCenter.default.post(name: NSNotification.Name("datasChanged"), object: nil)

            }
        }
    }
}

