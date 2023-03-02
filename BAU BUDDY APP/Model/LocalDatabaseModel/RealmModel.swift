//
//  RealmModel.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 2.03.2023.
//

import Foundation
import RealmSwift






class RealmTask : Object , DbDeclare {
    func declareAttributes(data: Dictionary<String,String>) {
        self.task = data["task"]!
        self.title = data["title"]!
        self.colorCode = data["colorCode"]!
        self.descript = data["description"]!
    }
    
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var task : String
    @Persisted var descript : String
    @Persisted var colorCode : String
    @Persisted var title : String
    

    
    override init() {}
}
