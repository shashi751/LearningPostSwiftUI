//
//  PostModel.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import Foundation

struct PostModel:Codable, Identifiable{
    var userId:Int?
    var id:Int
    var title:String
    var body:String
    
    init(userId: Int?, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    enum CodingKeys: CodingKey {
        case userId
        case id
        case title
        case body
    }
}
