//
//  Network.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 1.03.2023.
//

import Foundation



enum HTTPMethods : String {
    case POST = "POST"
    case GET = "GET"
}



struct NetworkOperations {
    static let shared = NetworkOperations()
    
    private init() {}
    
    func createRequest(url : URL, method : HTTPMethods = .GET,  headers : Dictionary<String,String> = [:] ) -> NSMutableURLRequest {
        
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        
        return request
        }
    
    
    func fetchDatasFromUrlRequest<T : Codable>(urlRequest : NSMutableURLRequest ,expectingType : T.Type ,   completionHandler : @escaping (Result<[T],Error>) -> Void ){
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { data, _, error in
            guard let data = data , error == nil else {
                completionHandler(.failure(error!))
                
                return
            }
           do {
              
               let datas = try JSONDecoder().decode([T].self, from: data)
               completionHandler(.success(datas))
            }
            
            catch {
                completionHandler(.failure(error))
            }
            
            
        }
        task.resume()
    }
    
    
    func requestAuthInfos(completionHandler : @escaping (Result<[String],Error>) -> Void) {
        
        var postData : Data!
        
        let headers : Dictionary<String,String> = [
            "Authorization": "\(authenticationType) \(basicAuthenticationCode)",
             "Content-Type": "application/json"
           ]
        
        let loginParameters = [
          "username": "365",
          "password": "1"
        ] as [String : Any]
    
        
        do {
            postData = try JSONSerialization.data(withJSONObject: loginParameters, options: [])
        }
        
        catch {
            completionHandler(.failure(error))
        }

        let request = NSMutableURLRequest(url: NSURL(string: "\(loginUrl)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, _, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            let fetchedDatas = try! JSONDecoder().decode(Authenticate.self, from: data)
            
            var outhInfos = [fetchedDatas.oauth.token_type,fetchedDatas.oauth.access_token]
            completionHandler(.success(outhInfos))
            
        }
        task.resume()
        
        
    }

}
