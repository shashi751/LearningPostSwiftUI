//
//  NetworkService.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import Foundation

enum DemoError: Error{
    case BadURL
    case NoData
    case DecodingError
    case requestFailed
    case invalidResponse
}

enum HTTPMethod:String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

protocol APIHandelerProtocol{
    func fetchRequest<T : Codable>(method:HTTPMethod, body:Data?, type:T.Type, url:String, callback:@escaping((Result<Data, DemoError>) -> Void))
}

protocol NetworkServiceProtocol{
    func fetchRequest<T: Codable>(url:String, callback:(Result<T, Error>)->Void)
}

class NetworkService:NSObject{
    
    var aPIHandeler:APIHandelerProtocol
    var responseHandeler:ResponseHandeler
    
    init(aPIHandeler: APIHandelerProtocol = APIHandeler(), ResponseHandeler: ResponseHandeler = ResponseHandeler()) {
        self.aPIHandeler = aPIHandeler
        self.responseHandeler = ResponseHandeler
    }
    
    func fetchRequest<T: Codable>(body:Data?, type:T.Type, method:HTTPMethod, url:String, callback:@escaping(Result<T, DemoError>)->Void){
        
        self.aPIHandeler.fetchRequest(method: method, body: body, type: type, url: url) { result in
            
            switch result{
            case .success(let data):
                self.responseHandeler.fetchModal(type: type, data: data) { responseData in
                    
                    switch responseData {
                    case .success(let modal):
                        callback(.success(modal))
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        callback(.failure(.NoData))
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                callback(.failure(.NoData))
            }
        }
    }
    
}

class APIHandeler : APIHandelerProtocol{
    
    func fetchRequest<T : Codable>(method:HTTPMethod, body:Data?, type:T.Type, url:String, callback:@escaping((Result<Data, DemoError>) -> Void)){
        
        guard let url = URL(string: url) else{
            callback(.failure(.BadURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body{
            request.httpBody = body
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                callback(.failure(.NoData))
                return
            }
            
            callback(.success(data))
        }
        
        task.resume()
        
    }
}

class ResponseHandeler{
    
    func fetchModal<T:Codable>(type:T.Type, data:Data, callback:(Result<T, DemoError>) -> Void){
        
        let jsonDecoder = JSONDecoder()
        do{
            let decodedData = try jsonDecoder.decode(type, from: data)
            callback(.success(decodedData))
        }
        catch let error{
            print(error)
            callback(.failure(.DecodingError))
        }
        
    }
    
}
