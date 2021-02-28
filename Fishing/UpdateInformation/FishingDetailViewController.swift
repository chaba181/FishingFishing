//
//  FishingDetailViewController.swift
//  Fishing
//
//  Created by mac on 08.09.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit
import CoreData

class FishingDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var sliderCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    
    var buttonString: String? = "good"
    var fish: FishingInfo?
    var images: [UIImage] = []
    
    var onDataAdded: ((FishingInfo) -> Void)?
    
    // MARK: - FishingDetailViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = fish?.photo else {return}
        guard let loadedImage = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] else {return}
        images = loadedImage.compactMap({ UIImage(data: $0) })
        self.hideKeyboardWhenTappedaround()
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableView.automaticDimension
        
        if let rating = fish?.rating {
            buttonString = rating
        }
        
    }
    
    @IBAction func updateFishingInfo(_ sender: Any) {
        updateName()
    }
    
    func updateName() {
        guard let id = fish?.id else { return }
        #warning("Сделай какой-то класс DB Manager который будет заниматься всеми операци с базой данных")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FishingInfo")
        fetchRequest2(fetchRequest: fetchRequest, id: id)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    func goTotheMapView () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapView = storyboard.instantiateViewController(identifier: "MapView") as? MapViewController {
            mapView.fish = fish
            show(mapView, sender: true)
        }
        
    }
    
    func goToTheRateView () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rateView = storyboard.instantiateViewController(identifier: "RateViewController") as? RateViewController {
            present(rateView, animated: true, completion: nil)
            sliderCollectionView.reloadData()
            rateView.onRatingChosen = { [weak self] fishingRating in
                self?.buttonString = fishingRating
                self?.sliderCollectionView.reloadData()
            }
        }
    }
    func fetchRequest2(fetchRequest: NSFetchRequest<NSFetchRequestResult>, id: String) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let results = try? context.fetch(fetchRequest) as? [NSManagedObject]
        
        guard let info = results?.first as? FishingInfo else { return }
        info.rating = buttonString
        try? context.save()
        self.onDataAdded?(info)
    }
}
