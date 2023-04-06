//
//  ContentView.swift
//  FriendFace
//
//  Created by Melody Davis on 3/21/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var cachedUsers: FetchedResults<CachedUser>
    
    @State private var users = [User]()
    
    var sortedUsers: [User] {
        return users.sorted { t1, t2 in
            // sort by name
            if t1.isActive == t2.isActive {
                return t1.name < t2.name
            }
            // sort by isActive
            return t1.isActive && !t2.isActive
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedUsers, id: \.id) { user in
                    NavigationLink {
                        UserDetailView(allUsers: users, userId: user.id)
                    } label: {
                        HStack(alignment: .center) {
                            Text(user.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(user.isActive ? "Online" : "Offline")
                                .foregroundColor(user.isActive ? Color.green : Color.red)
                        }
                    }
                }
            }
            .navigationTitle("Friend Face")
        }
        .task {
            if users.count == 0 {
                do {
                    try await loadData()
                } catch {
                    fatalError("\(error)")
                }
            }
        }
    }
    
    func loadData() async throws {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                // format date
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        users = decodedResponse
                    }
                    Task {
                        do {
                            try await cacheUsers(users)
                        } catch {
                            print("Could not cache users")
                        }
                    }
                    return
                }
            }
            for cachedUser in cachedUsers {
                var friendsArray = [Friend]()
                for friend in cachedUser.friendsArray {
                    let cachedFriend = Friend(id: friend.wrappedId, name: friend.wrappedName)
                    friendsArray.append(cachedFriend)
                }
                
                let user = User(
                    id: cachedUser.wrappedId,
                    isActive: cachedUser.isActive,
                    name: cachedUser.wrappedName,
                    age: Int(cachedUser.age),
                    company: cachedUser.wrappedCompany,
                    email: cachedUser.wrappedEmail,
                    address: cachedUser.wrappedAddress,
                    about: cachedUser.wrappedAbout,
                    registered: cachedUser.wrappedRegistered,
                    tags: cachedUser.wrappedTags,
                    friends: friendsArray
                )
                users.append(user)
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()

    }
    
    func cacheUsers(_ users: [User]) async throws {
        await MainActor.run {
            for user in users {
                let cachedUser = CachedUser(context: moc)
                cachedUser.id = user.id
                cachedUser.isActive = user.isActive
                cachedUser.name = user.name
                cachedUser.age = Int16(user.age)
                cachedUser.company = user.company
                cachedUser.email = user.email
                cachedUser.address = user.address
                cachedUser.about = user.about
                cachedUser.registered = user.registered
                cachedUser.tags = user.tags.joined(separator: ",")
                for friend in user.friends {
                    let cachedFriend = CachedFriend(context: moc)
                    cachedFriend.id = friend.id
                    cachedFriend.name = friend.name
                    cachedUser.addToFriends(cachedFriend)
                }

                if moc.hasChanges {
                    try? moc.save()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
