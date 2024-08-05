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
    func fetchRequestAsyncAwait<T : Codable>(method:HTTPMethod, body:Data?, type:T.Type, url:String) async throws -> Data
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
    
    func fetchRequestAsyncAwait<T: Codable>(body:Data?, type:T.Type, method:HTTPMethod, url:String) async throws -> T{
        
        do{
            let data = try await aPIHandeler.fetchRequestAsyncAwait(method: method, body: body, type: type, url: url)
            let model = try await responseHandeler.fetchModalAsyncWait(type: type, data: data)
            return model
        }
        catch let error{
            throw error
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
    
    func fetchRequestAsyncAwait<T : Codable>(method:HTTPMethod, body:Data?, type:T.Type, url:String) async throws -> Data{
        
        guard let url = URL(string: url) else{
            throw DemoError.BadURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body{
            request.httpBody = body
        }
        let (data, response) = try  await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw DemoError.invalidResponse
        }
        
        return data
        
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
    
    func fetchModalAsyncWait<T:Codable>(type:T.Type, data:Data) async throws -> T{
        
        do{
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        }
        catch let error{
            throw error
        }
        
    }
    
}
