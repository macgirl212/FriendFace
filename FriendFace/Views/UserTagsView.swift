//
//  UserTagsView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct UserTagsView: View {
    var allUsers: [User]
    var selectedUser: String
    var tags: [String]
    
    @State private var title = ""
    @State private var isShowingFriendsViewFromTag = false
    @State private var possibleFutureFriends = [Friend]()
    
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
                        Button {
                            findUsersByTag(tag)
                        } label: {
                            Text(tag)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .sheet(isPresented: $isShowingFriendsViewFromTag) {
            FriendsView(allUsers: allUsers, title: $title, friends: $possibleFutureFriends)
        }
    }
    
    func findUsersByTag(_ tag: String) {
        title = "Users Interested in \"\(tag)\""
        // find all users with associated tag
        let filteredUsers = allUsers
            .filter { $0.tags.contains(tag) && $0.name != selectedUser }
        
        // convert all users to friends to better fit the new view
        let convertedUsers: [Friend] = filteredUsers.map { Friend(id: $0.id, name: $0.name) }

        possibleFutureFriends = convertedUsers
        isShowingFriendsViewFromTag = true
    }
}
