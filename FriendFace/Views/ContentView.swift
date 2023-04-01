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
                // for testing purposes
                .onDelete(perform: deleteUsers)
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
                let user = User(
                    id: cachedUser.id ?? "123",
                    isActive: cachedUser.isActive,
                    name: cachedUser.name ?? "Anonymous",
                    age: Int(cachedUser.age),
                    company: cachedUser.company ?? "Company",
                    email: cachedUser.email ?? "Unknown",
                    address: cachedUser.address ?? "Unknown",
                    about: cachedUser.about ?? "",
                    registered: cachedUser.registered ?? Date.now,
                    tags: cachedUser.tags?.components(separatedBy: ",") ?? [],
                    friends: []
                )
                users.append(user)
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()

    }
    
    func cacheUsers(_ users: [User]) async throws {
        await MainActor.run {
            print(users[0].tags)
            
            // for testing purposes
            let cachedUser = CachedUser(context: moc)
            cachedUser.id = users[0].id
            cachedUser.isActive = users[0].isActive
            cachedUser.name = users[0].name
            cachedUser.age = Int16(users[0].age)
            cachedUser.company = users[0].company
            cachedUser.email = users[0].email
            cachedUser.address = users[0].address
            cachedUser.about = users[0].about
            cachedUser.registered = users[0].registered
            cachedUser.tags = users[0].tags.joined(separator: ",")
            
            try? moc.save()
            
            for cachedUser in cachedUsers {
                let user = User(
                    id: cachedUser.id ?? "123",
                    isActive: cachedUser.isActive,
                    name: cachedUser.name ?? "Anonymous",
                    age: Int(cachedUser.age),
                    company: cachedUser.company ?? "Company",
                    email: cachedUser.email ?? "Unknown",
                    address: cachedUser.address ?? "Unknown",
                    about: cachedUser.about ?? "",
                    registered: cachedUser.registered ?? Date.now,
                    tags: cachedUser.tags?.components(separatedBy: ",") ?? [],
                    friends: []
                )
                self.users.append(user)
            }

            /*
            // hopefully soon to be live code
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
                
                /*
                if moc.hasChanges {
                    try? moc.save()
                }
                 */
            }
             */
        }
    }
    
    // for testing purposes
    func deleteUsers(at offsets: IndexSet) {
        for offset in offsets {
            let user = cachedUsers[offset]
            moc.delete(user)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
