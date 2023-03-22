//
//  UserTagsView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct UserTagsView: View {
    var tags: [String]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            Text("Tags:")
                .font(.headline)
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(tags.sorted(), id: \.self) { tag in
                        Button(tag) { }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
        }
    }
}

struct UserTagsView_Previews: PreviewProvider {
    static var previews: some View {
        UserTagsView(tags: ["piano", "guitar", "programming", "drawing", "watching anime", "video games", "swimming"])
    }
}
