//
//  RealmInstance.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 2.03.2023.
//

import Foundation
import RealmSwift



struct RealmInstance {
    static let shared = try! Realm()
    private init(){}
    
}
