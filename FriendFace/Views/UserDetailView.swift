//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct UserDetailView: View {
    var allUsers: [User]
    var userId: String
    
    
    var user: User {
        if let selectedUser = allUsers.first(where: { $0.id == userId }) {
            return selectedUser
        }
        fatalError("User does not exist.")
    }
    
    @State private var isShowingFriendsView = false
    @State private var title = "Friend List"
    @State private var friendsList = [Friend]()
    
    var body: some View {
        ScrollView {
            Text(user.name)
                .font(.largeTitle)
                .bold()
            
            Text(user.isActive ? "Online" : "Offline")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(user.isActive ? Color.green : Color.red)
                .padding(10)
                .frame(width: 150)
                .background(user.isActive ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(user.isActive ? Color.green.opacity(0.6) : Color.red.opacity(0.5), lineWidth: 4)
                )
                .padding(.bottom)
            
            UserDetailSegmentView(heading: "Joined", userDetails: user.registered.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year(.twoDigits)))
            
            UserDetailSegmentView(heading: "Age", userDetails: String(user.age))
            
            UserDetailSegmentView(heading: "Company", userDetails: user.company)
            
            UserDetailSegmentView(heading: "Email", userDetails: user.email)
            
            UserDetailSegmentView(heading: "Address", userDetails: user.address)
            
            UserDetailSegmentView(heading: "About", userDetails: user.about)
            
            UserTagsView(allUsers: allUsers, selectedUser: user.name, tags: user.tags)
                .padding(.bottom)
            
            Button {
                isShowingFriendsView = true
            } label: {
                Text("View Friends")
            }
        }
        .sheet(isPresented: $isShowingFriendsView) {
            FriendsView(allUsers: allUsers, title: $title, friends: $friendsList)
        } .task {
            friendsList = user.friends
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static let exampleUser = User(
        id: "123",
        isActive: true,
        name: "Luke Pearce",
        age: 24,
        company: "Time's Antiquities",
        email: "sherlock97@totmail.com",
        address: "123 Main Street, Stellis City, Stellis",
        about: "I'm just a normal, healthy guy that is back in my hometown. I own an antique shop, and I have a great pet bird named Peanut. That's it. I live a completely normal life. Nothing different about me at all.",
        registered: Date.now,
        tags: ["healthy", "mystery lover", "antiques", "shop owner"],
        friends: [
            Friend(id: "234", name: "Rosa"),
            Friend(id: "345", name: "Marius"),
            Friend(id: "456", name: "Artem"),
            Friend(id: "567", name: "Vyn")
        ]
    )
    
    static var previews: some View {
        UserDetailView(allUsers: [exampleUser], userId: "123")
    }
}
