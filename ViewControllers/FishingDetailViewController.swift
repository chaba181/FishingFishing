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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FishingInfo")
        getEntityById(fetchRequest: fetchRequest, id: id)
        
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
    
    func getEntityById(fetchRequest: NSFetchRequest<NSFetchRequestResult>, id: String) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let results = try? context.fetch(fetchRequest) as? [NSManagedObject]
        
        guard let info = results?.first as? FishingInfo else { return }
        info.rating = buttonString
        try? context.save()
        self.onDataAdded?(info)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FishingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? FishingDetailTableViewCell {
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Название"
                cell.valueLabel.text = fish?.title
            case 1:
                cell.keyLabel.text = "Дата"
                cell.valueLabel.text = fish?.timeData
            case 2:
                cell.keyLabel.text = "Адрес"
                cell.valueLabel.text = fish?.address
            case 3:
                cell.keyLabel.text = "Заметки"
                cell.valueLabel.text = fish?.notes
            default: break
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension FishingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FishingDetailCollectionViewCell else {return UICollectionViewCell()}
        cell.imageView.image = images[indexPath.row]
        fish?.rating = buttonString
        cell.rateButton.setImage(UIImage(named: buttonString ?? ""), for: .normal)
        cell.showMap = { [weak self] in
            self?.goTotheMapView() }
        cell.showRate = { [weak self] in
            self?.goToTheRateView()
        }
        return cell
    }
}
