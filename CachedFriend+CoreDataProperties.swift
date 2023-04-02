//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Melody Davis on 4/2/23.
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
    @NSManaged public var isFriendsOf: NSSet?
    
    public var wrappedName: String {
        friendName ?? "Unknown"
    }
    
    public var wrappedId: String {
        friendId ?? "123"
    }

}

// MARK: Generated accessors for isFriendsOf
extension CachedFriend {

    @objc(addIsFriendsOfObject:)
    @NSManaged public func addToIsFriendsOf(_ value: CachedUser)

    @objc(removeIsFriendsOfObject:)
    @NSManaged public func removeFromIsFriendsOf(_ value: CachedUser)

    @objc(addIsFriendsOf:)
    @NSManaged public func addToIsFriendsOf(_ values: NSSet)

    @objc(removeIsFriendsOf:)
    @NSManaged public func removeFromIsFriendsOf(_ values: NSSet)

}

extension CachedFriend : Identifiable {

}
