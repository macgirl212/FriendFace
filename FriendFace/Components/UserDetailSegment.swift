//
//  UserDetailSegment.swift
//  FriendFace
//
//  Created by Melody Davis on 3/22/23.
//

import SwiftUI

struct UserDetailSegment: View {
    var heading: String
    var userDetails: String
    var body: some View {
        HStack(alignment: .top) {
            Text("\(heading):")
                .font(.headline)
            
            Text(userDetails)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .trailing, .bottom])
    }
}

struct UserDetailSegment_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailSegment(heading: "Age", userDetails: "30")
    }
}
