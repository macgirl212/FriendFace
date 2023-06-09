//
//  UserTags.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct UserTags: View {
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
    
    var filteredTags: [String] {
        return tags.removingDuplicates()
    }
    
    var body: some View {
        VStack {
            Text("Tags:")
                .font(.headline)
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(filteredTags.sorted(), id: \.self) { tag in
                        Button {
                            findUsersByTag(tag)
                        } label: {
                            Text(tag)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(2)
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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
