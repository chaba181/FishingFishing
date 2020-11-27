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
    @IBOutlet private weak var fishingData: UITextField!
    @IBOutlet private weak var fishingName: UITextField!
    @IBOutlet private weak var fishingNote: UITextView!
    @IBOutlet private weak var fishingImage: UIImageView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    var fish: FishingInfo?
    
    var onDataAdded: ((FishingInfo) -> Void)?
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fishingName.text = fish?.title
        fishingNote.text = fish?.notes
        guard let data = fish?.photo else {return}
        #warning("убери warning")
        guard let loadedImage = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] else {return}
        images = loadedImage.compactMap({ UIImage(data: $0) })
       // fishingImage.image = fish?.photo.flatMap { UIImage(data: $0) }
        fishingData.text = fish?.timeData
            
    }
    
    @IBAction func addChangeFishingInfo(_ sender: Any) {
        #warning("Название метода старнное")
        updateName(name: fishingName.text, data: "", note: fishingNote.text, image: nil)
    }
    
    func updateName (name: String?, data: String?, note: String?, image: Data?) {
        guard let id = fish?.id else { return }
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        //needed to fetch request
        #warning("Сделай какой-то класс DB Manager который будет заниматься всеми операци с базой данных")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FishingInfo")
        //predicate to match task on id
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let results = try? context.fetch(fetchRequest) as? [NSManagedObject]
        
        guard let info = results?.first as? FishingInfo else { return }
        
        info.title = name
        info.notes = note
        
        try? context.save()
        self.onDataAdded?(info)
        self.navigationController?.popViewController(animated: true)
    }
}

extension FishingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vccc = cell.viewWithTag(111) as? UIImageView {
            vccc.image = images[indexPath.row] 
        }
        return cell
    }
}
