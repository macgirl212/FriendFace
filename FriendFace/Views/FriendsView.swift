//
//  FriendsView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct FriendsView: View {
    @Environment(\.dismiss) var dismiss
    
    var allUsers: [User]
    @Binding var title: String
    @Binding var friends: [Friend]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends.sorted { $0.name < $1.name }, id: \.id) { friend in
                    NavigationLink {
                        UserDetailView(allUsers: allUsers, userId: friend.id)
                    } label: {
                        Text(friend.name)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
