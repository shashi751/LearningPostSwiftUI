//
//  PostRow.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import SwiftUI

struct PostRow: View {
    
    var post:PostModel
    
    var body: some View {
        VStack(alignment:.leading){
            Text(post.title.capitalized)
                .font(.system(size: 20, weight: .bold))
            Text(post.body.capitalized)
                .padding(.top, 5)
                .font(.system(size: 18, weight: .regular))
        }
        .padding(10)
    }
}

#Preview {
    PostRow(post: PostModel(userId: 1, id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"))
}
