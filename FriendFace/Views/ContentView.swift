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
            List(sortedUsers, id: \.id) { user in
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
            .navigationTitle("Friend Face")
        }
        .task {
            if users.count == 0 {
                do {
                    try await loadData()
                    // await cacheUsers(users: users)
                } catch {
                    print("\(error)")
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
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
    
    func cacheUsers(users: [User]) async {
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
                }
            }
            
            // currently does not save to moc
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
