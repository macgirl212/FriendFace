//
//  FriendsView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct FriendsView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
    @Binding var friends: [Friend]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends.sorted { $0.name < $1.name }, id: \.id) { friend in
                    Text(friend.name)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var sampleFriends = [
        Friend(id: "123", name: "Tom"),
        Friend(id: "234", name: "Dick"),
        Friend(id: "345", name: "Harry")
    ]
    static var previews: some View {
        FriendsView(title: .constant("Friend View"), friends: .constant(sampleFriends))
    }
}
