//
//  CoreDataManager.swift
//  Fishing
//
//  Created by mac on 18.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let modelFileName = "Model"
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelFileName)
        container.loadPersistentStores(completionHandler: { (_, _) in })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch { }
        }
    }
}
