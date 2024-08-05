//
//  PostViewModel.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import Foundation

//@MainActor
class PostViewModel:ObservableObject{
    
    @Published var posts = [PostModel]()
    @Published var post : PostModel?
    
    func fetchPost() async {
        
        do{
            let list = try await NetworkService().fetchRequestAsyncAwait(body: nil, type: [PostModel].self, method: .GET, url: "\(baseURL)posts")
            DispatchQueue.main.async {
                self.posts = list
            }
            
        }
        catch let error{
            print(error)
        }
        
        /*NetworkService().fetchRequest(body:nil, type: [PostModel].self, method: .GET, url: "\(baseURL)posts") { [weak self] result in
            
            switch result{
            case .success(let modal):
                print(modal)
                DispatchQueue.main.async {
                    self?.posts = modal
                }
                
            case .failure(let error):
                print(error)
            }
        }*/
    }
    
    func createNewPost(title:String, body:String) async{
        
        var param:[String:Any] = [String:Any]()
        param["title"] = title
        param["body"] = body
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            let post = try await NetworkService().fetchRequestAsyncAwait(body: jsonData, type: PostModel.self, method: .GET, url: "\(baseURL)posts")
            DispatchQueue.main.async {
                self.post = post
            }
        }
        catch let error{
            print(error)
        }
        
    }
    
    //:
    @Published var availableTickets: Int = 5
    private var concurrentQueue = DispatchQueue(label: "com.sample.learning.tickets", attributes: .concurrent)
    
    @Published var tickets = [Person(ticketNumber: 2, name: "Shashi"),
                   Person(ticketNumber: 3, name: "Vishal"),
                   Person(ticketNumber: 4, name: "Yatin"),
                   Person(ticketNumber: 1, name: "Rahul")]
    
    func reset(){
        self.tickets = [Person(ticketNumber: getRandomNumber(), name: "Shashi", purchased: ""),
                       Person(ticketNumber: getRandomNumber(), name: "Vishal", purchased: ""),
                       Person(ticketNumber: getRandomNumber(), name: "Yatin", purchased: ""),
                       Person(ticketNumber: getRandomNumber(), name: "Rahul", purchased: "")]
        
        self.availableTickets = 5
    }
    
    private func getRandomNumber() -> Int{
        return Int.random(in: 1...5)
    }
    
    func raceConditionhandeling(){
        
        for ticket in tickets{
            concurrentQueue.async(flags: .barrier) {
                self.bookTickets(person: ticket)
            }
        }
    }
    
    private func bookTickets(person:Person){
        print("Booking ticket is started for \(person.name)")
        sleep(1)
        if self.availableTickets >= person.ticketNumber{
            self.availableTickets = self.availableTickets - person.ticketNumber
            if let index = tickets.firstIndex(where: {($0.ticketNumber == person.ticketNumber) && ($0.name == person.name)}){
                self.tickets[index].purchased = "Success"
            }
            print("Ticket alloted successfull for \(person.name)")
        }
        else{
            print("Ticket booking Failed for \(person.name)")
            if let index = tickets.firstIndex(where: {($0.ticketNumber == person.ticketNumber) && ($0.name == person.name)}){
                self.tickets[index].purchased = "Failed"
            }
        }
    }
}
