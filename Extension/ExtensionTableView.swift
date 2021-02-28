//
//  ExtetnionTableViewForViewC.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.info.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fishingInfo = presenter?.info[indexPath.row] else { return UITableViewCell() }
        #warning("Здесь аналогично тому что я писал выше")
        if let cell = tbldViewData.dequeueReusableCell(withIdentifier: "Cell") as? FishingTableViewCell {
            cell.fishingName.text = fishingInfo.title
            cell.fishingLocation.text = fishingInfo.address
            cell.fishingDate.text = fishingInfo.timeData
            if let data = fishingInfo.photo,
               let loadedImage = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] {
                let images = loadedImage.compactMap({ UIImage(data: $0) })
                cell.fishingImage.image = images.first
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - transition to another class by cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fishingInfo = presenter?.info[indexPath.row]
        
        #warning("Сделай доступ к сторибордам и контролерам через R.string, удали закоменченый код")
        guard let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FishingDetailViewController") as? FishingDetailViewController else {return}
        controller.fish = fishingInfo
        controller.onDataAdded = { [weak self] fishingInfo in
            self?.tbldViewData.reloadData()
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func deleteData(indexPath:IndexPath) {
        self.presenter?.info.remove(at: indexPath.row)
    }
    
    // MARK: - delete and share a cell in tableView
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let fishingInfo = presenter?.info[indexPath.row] else { return UISwipeActionsConfiguration() }
        let share = UIContextualAction(style: .normal, title: "Поделиться") { (_, _, _)  in
            var image: UIImage?
            let defaultText = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
            if let data = fishingInfo.photo,
               let loadedImage = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] {
                let images = loadedImage.compactMap({ UIImage(data: $0) })
                image = images.first
            }
            
            let activityConteoller = UIActivityViewController(activityItems: [defaultText , image as Any], applicationActivities: nil)
            self.present(activityConteoller, animated: true, completion: nil)
        }
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (_, _, _)  in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                self.tbldViewData.setEditing(true, animated: true)
                context.delete(self.presenter?.info [indexPath.row] ?? FishingInfo())
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                self.deleteData(indexPath: indexPath)
            }
        }
        let action = UISwipeActionsConfiguration(actions: [delete, share])
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2211629322, blue: 0.03118017327, alpha: 1)
        delete.image = UIImage(named: "delete")
        
        share.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        share.image = UIImage(named: "share")
        
        return action
    }
}

// MARK: - extension FishingDetailViewController: UITableViewDelegate, UITableViewDataSource

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
