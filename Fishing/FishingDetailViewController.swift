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
    @IBOutlet weak var fishingData: UITextField!
    @IBOutlet weak var fishingName: UITextField!
    @IBOutlet weak var fishingNote: UITextView!
    @IBOutlet weak var fishingImage: UIImageView!
    var fish: FishingInfo?
    var onDataAdded: ((FishingInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fishingName.text = fish?.title
        fishingNote.text = fish?.notes
        fishingImage.image = fish?.photo.flatMap { UIImage(data: $0) }
        fishingData.text = fish?.timeData
    }
    
    @IBAction func addChangeFishingInfo(_ sender: Any) {
        updateName(name: fishingName.text, data: "", note: fishingNote.text, image: nil)
    }
    
    func updateName (name: String?, data: String?, note: String?, image: Data?) {
        guard let id = fish?.id else { return }
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        //needed to fetch request
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
