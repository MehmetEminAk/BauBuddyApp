//
//  Model.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 2.03.2023.
//

import Foundation





struct Task : Codable {
    var task : String
    var title : String
    var colorCode : String
    var description : String
   
}



struct Authenticate : Codable {
    var oauth : AuthInfos
}

struct AuthInfos : Codable {
    var access_token : String
    var token_type : String
}



