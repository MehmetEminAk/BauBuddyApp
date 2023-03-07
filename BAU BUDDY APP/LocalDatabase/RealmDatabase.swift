//
//  RealmDatabase.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 7.03.2023.
//

import Foundation
import RealmSwift



struct LocalDatabase  {
    
    init(){}
    
    func removeAllDatas(){
        try! RealmInstance.shared.write {
            RealmInstance.shared.deleteAll()
        }
    }
    
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
