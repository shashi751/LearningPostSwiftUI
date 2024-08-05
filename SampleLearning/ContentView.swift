//
//  ContentView.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = PostViewModel()
    
    @State private var isCreateViewActive = false
    
    var body: some View {
        
        NavigationView {
            VStack{
                HStack{
                    Text("Posts")
                        .padding(.leading, 16)
                        .font(.title)
                    Spacer()
                    Button {
                        isCreateViewActive = true

                    } label: {
                        Text("+ New Post")
                            .padding(8)
                            .foregroundColor(.white)
                            .background(.green)
                            .clipShape(.capsule)
                    }
                    
                }
                .padding(.trailing, 16)
                
                List(viewModel.posts, id: \.id) { post in
                    PostRow(post: post)
                }
                
                // NavigationLink is hidden, but triggers navigation based on state
                NavigationLink(
                    destination: CreatePostView(isActive: $isCreateViewActive),
                    isActive: $isCreateViewActive,
                    label: { EmptyView() }
                )
            }
            .task {
                 await viewModel.fetchPost()
                viewModel.raceConditionhandeling()
                print("After viewModel.raceConditionhandeling()")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
