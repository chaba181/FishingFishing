//
//  AppDelegate.swift
//  Fishing
//
//  Created by mac on 27.07.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
#warning("старайся делать меньше лоигки в контролерах(например операции с бд - выноси все по отдельным классам")
#warning("Почитый за принципы Solid и постарайся привести свой код близко к ним, особенно проблема с тем что один класс должен выполнять только свои одни специфические действия")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistentContainer = CoreDataManager.shared.persistentContainer
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    // MARK: - Core Data stack
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    #warning("Попробуй вынести весь CoreData стек в отдельный класс, например CoreDataManager, почитай за паттерн Singletone и попробуй его применить + удали комменты ебаные")

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
