//
//  Presenter.swift
//  Fishing
//
//  Created by mac on 02.12.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit

protocol HomePagePresenterOutput: class {
    func didDataUpdate()
}

class HomePagePresenter: NSObject {
    weak var output: HomePagePresenterOutput?
    
    var info = [FishingInfo]() {
        didSet {
            output?.didDataUpdate()
        }
    }
}

// MARK: - HomePageViewControllerOutput
extension HomePagePresenter: HomePageViewControllerOutput {
    func loadData() {
        guard   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
                let result = try? context.fetch(FishingInfo.fetchRequest()) as? [FishingInfo] else { return }
        
        info = result
    }
}
