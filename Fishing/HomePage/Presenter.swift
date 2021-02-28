//
//  Presenter.swift
//  Fishing
//
//  Created by mac on 02.12.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit

class Presenter: NSObject {
    
    var info = [FishingInfo]() {
        didSet {
            controller?.onDataLoaded()
        }
    }
    
    weak var controller: ViewController?
    
    func loadData() {
        guard   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
                let result = try? context.fetch(FishingInfo.fetchRequest()) as? [FishingInfo] else { return }
        
        info = result
    }
}
