//
//  CoreDataStack.swift
//  TodoApp
//
//  Created by Jair Moreno Gaspar on 12/28/18.
//  Copyright © 2018 Jair Moreno Gaspar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        
        return container
        
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
