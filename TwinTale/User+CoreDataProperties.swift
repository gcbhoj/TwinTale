//
//  User+CoreDataProperties.swift
//  TwinTale
//
//  Created for TwinTale App
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var facebookId: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var lastLoginDate: Date?
    @NSManaged public var loginMethod: String?
    @NSManaged public var profilePictureUrl: String?

}

extension User : Identifiable {

}
