//
//  CreatePostView.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import SwiftUI

struct CreatePostView: View {
    
    @State var titleText = ""
    @State var bodyText = ""
    @Binding var isActive: Bool
    
    @ObservedObject private var viewModel = PostViewModel()
    
    var body: some View {
        
        VStack(alignment:.leading){
            
            NavigationView {
                VStack{
                    
                    Form {
                        Section(header: Text("")) {
                            TextField("Post Title", text: $titleText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            TextEditor(text: $bodyText)
                                .padding(4)
                                .background(Color(UIColor.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .frame(height: 100) // Adjust height as needed
                            .padding()
                            
                        }
                        
                    }
                    Button(action: {
                        // Handle the form submission
                        print("Name: \(titleText), Email: \(bodyText)")
                        if let _ = viewModel.post{
                            isActive = true
                        }
                        if !titleText.isEmpty && !bodyText.isEmpty{
                            viewModel.createNewPost(title: titleText, body: bodyText)
                        }
                        
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                    .padding()
                }
                .navigationBarTitle("Create New Post", displayMode: .automatic)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing(true) // Dismiss the keyboard when tapping outside
        }
    }
}

//#Preview {
//    CreatePostView(isActive: true)
//}

