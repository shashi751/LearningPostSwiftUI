//
//  PostViewModel.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import Foundation

class PostViewModel:ObservableObject{
    
    @Published var posts = [PostModel]()
    @Published var post : PostModel?
    
    func fetchPost(){
        
        NetworkService().fetchRequest(body:nil, type: [PostModel].self, method: .GET, url: "\(baseURL)posts") { [weak self] result in
            
            switch result{
            case .success(let modal):
                print(modal)
                DispatchQueue.main.async {
                    self?.posts = modal
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createNewPost(title:String, body:String){
        
        var param:[String:Any] = [String:Any]()
        param["title"] = title
        param["body"] = body
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            
            NetworkService().fetchRequest(body:jsonData, type: PostModel.self, method: .POST, url: "\(baseURL)posts") { [weak self] result in
                
                switch result{
                case .success(let modal):
                    print(modal)
                    DispatchQueue.main.async {
                        self?.post = modal
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        catch let error{
            print(error)
        }
        
    }
}
