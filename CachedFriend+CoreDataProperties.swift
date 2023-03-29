//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Melody Davis on 3/29/23.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var friendId: String?
    @NSManaged public var friendName: String?
    @NSManaged public var origin: CachedUser?

}
