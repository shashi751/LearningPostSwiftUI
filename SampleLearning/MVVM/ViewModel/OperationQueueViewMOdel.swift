//
//  OperationQueueViewMOdel.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 06/08/24.
//

import Foundation

class OperationQueueViewModel:ObservableObject{
    
    init() {
        print("blockOperationDemo started")
        operationQueueDemo()
        print("blockOperationDemo finish")
    }
    
    func operationQueueDemo(){
        
        let ob = BlockOperation()
        ob.addExecutionBlock {
            for i in 0...5{
                print(i)
            }
        }
        
        let ob1 = BlockOperation()
        ob1.addExecutionBlock {
            for i in 6...10{
                print(i)
            }
        }
        
        let ob3 = BlockOperation()
        ob3.addExecutionBlock {[weak self] in
            if let op = self?.findNonRepetingItems(numbers: [1,2,5,3,4,3,2,1,5]){
                print("non repeting items = \(op)")
            }
            
            
            if let op = self?.findRepetatingCount(numbers: [1,2,5,3,4,3,2,1,5]){
                print("findRepetatingCount = \(op)")
            }
            
            
        }
        
//        ob.start()
        
        let oQueue = OperationQueue()
        oQueue.addOperation(ob)
        oQueue.addOperation(ob1)
        oQueue.addOperation(ob3)
        oQueue.maxConcurrentOperationCount = 1
        ob3.addDependency(ob)
        ob3.addDependency(ob1)
        
    }
    
    func findNonRepetingItems(numbers:[Int]) -> Set<Int>{
        
        var nonRepetingItems : Set<Int> = []
        
        //Business logic
        var uniqueItems : Set<Int> = []
        var repeatingItems : Set<Int> = []
        
        for item in numbers{
            
            if uniqueItems.contains(item){
                repeatingItems.insert(item)
            }
            else{
                uniqueItems.insert(item)
            }
        }
        
        nonRepetingItems = uniqueItems.subtracting(repeatingItems)
        
        return nonRepetingItems
    }
    
    func findRepetatingCount(numbers:[Int]) -> [Int:Int]{
        
        var items:[Int:Int] = [:]
        for num in numbers{
            items[num, default: 0] += 1
        }
        
        return items
    }
    
    
}
