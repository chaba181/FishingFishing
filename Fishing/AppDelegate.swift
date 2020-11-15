//
//  AppDelegate.swift
//  Fishing
//
//  Created by mac on 27.07.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // let index: CGFloat? = 1
        
        //1. Разопционалить через if let
        
        //2. Разопционалить через guard let
        
        //3. Розопционалить через flatMap
        
        //4. Разопционалить через дефолтное значение
        
        //5*. Разопционалить через switch
        
        return true
    }
    
    // MARK: - Core Data stack
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    #warning("Попробуй вынести весь CoreData стек в отдельный класс, например CoreDataManager, почитай за паттерн Singletone и попробуй его применить + удали комменты ебаные")
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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
