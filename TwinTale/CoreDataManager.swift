//
//  CoreDataManager.swift
//  TwinTale
//
//  Created for TwinTale App
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TwinTale")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data: Context saved successfully")
            } catch {
                let nserror = error as NSError
                print("❌ Core Data: Failed to save context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - User Management
    
    /// Check if a user with the given Facebook ID already exists
    func userExists(facebookId: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "facebookId == %@", facebookId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("❌ Error checking if user exists: \(error)")
            return false
        }
    }
    
    /// Get user by Facebook ID
    func getUser(facebookId: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "facebookId == %@", facebookId)
        fetchRequest.fetchLimit = 1
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("❌ Error fetching user: \(error)")
            return nil
        }
    }
    
    /// Save Facebook user to Core Data (only if doesn't exist)
    func saveFacebookUser(facebookId: String, name: String, email: String?) -> User? {
        // Check if user already exists
        if let existingUser = getUser(facebookId: facebookId) {
            print("ℹ️ User already exists: \(existingUser.name ?? "Unknown")")
            // Update last login date
            existingUser.lastLoginDate = Date()
            saveContext()
            return existingUser
        }
        
        // Create new user
        let user = User(context: context)
        user.facebookId = facebookId
        user.name = name
        user.email = email
        user.createdDate = Date()
        user.lastLoginDate = Date()
        user.loginMethod = "facebook"
        
        saveContext()
        print("✅ New Facebook user saved: \(name)")
        return user
    }
    
    /// Get all users
    func getAllUsers() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ Error fetching all users: \(error)")
            return []
        }
    }
    
    /// Delete user
    func deleteUser(_ user: User) {
        context.delete(user)
        saveContext()
        print("✅ User deleted: \(user.name ?? "Unknown")")
    }
    
    /// Delete all users (for testing/debugging)
    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("✅ All users deleted")
        } catch {
            print("❌ Error deleting all users: \(error)")
        }
    }
}

// MARK: - User Entity Extension
extension User {
    
    /// Convenience method to get formatted last login date
    var formattedLastLoginDate: String {
        guard let date = lastLoginDate else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Check if this is the user's first login today
    var isFirstLoginToday: Bool {
        guard let lastLogin = lastLoginDate else { return true }
        return !Calendar.current.isDateInToday(lastLogin)
    }
}
