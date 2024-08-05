//
//  TicketBookingView.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 05/08/24.
//

import SwiftUI

struct TicketBookingView: View {
    
    @ObservedObject private var viewModel = PostViewModel()
    
    var body: some View {
        VStack{
            Text("Race Condition")
                .font(.system(size: 22, weight: .bold))
            
            HStack{
                Text("Available tickets:")
                Text("\(viewModel.availableTickets)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding(.top, 3)
            List(viewModel.tickets, id: \.id) { person in
                
                VStack(alignment:.leading){
                    HStack{
                        Text("\(person.name) needs booking ticket:")
                        Spacer()
                        Text("\(person.ticketNumber)")
                            .font(.system(size: 20, weight: .bold))
                    }
                    person.purchased == "Success" ? Text(person.purchased)
                        .foregroundColor(.green) : Text(person.purchased)
                        .foregroundColor(.red)
                    
                }
                .padding(.top, 5)
            }
            HStack{
                if viewModel.tickets.filter({$0.purchased == ""}).count == 0{
                    Button(action: {
                        viewModel.reset()
                    }, label: {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.gray)
                            .clipShape(Capsule())
                    })
                }
                else{
                    Button(action: {
                        viewModel.raceConditionhandeling()
                    }, label: {
                        Text("Book Tickets")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.green)
                            .clipShape(Capsule())
                    })
                }
                
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    TicketBookingView()
}
