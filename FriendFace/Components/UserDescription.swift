//
//  UserDescription.swift
//  FriendFace
//
//  Created by Melody Davis on 3/24/23.
//

import SwiftUI

struct UserDescription: View {
    var user: User
    
    var body: some View {
        UserDetailSegment(heading: "Joined", userDetails: user.registered.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year(.twoDigits)))
        
        UserDetailSegment(heading: "Age", userDetails: String(user.age))
        
        UserDetailSegment(heading: "Company", userDetails: user.company)
        
        UserDetailSegment(heading: "Email", userDetails: user.email)
        
        UserDetailSegment(heading: "Address", userDetails: user.address)
        
        UserDetailSegment(heading: "About", userDetails: user.about)
    }
}
