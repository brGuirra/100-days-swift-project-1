//
//  ViewController.swift
//  project-1
//
//  Created by Bruno Guirra on 30/12/21.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            self?.loadImagesFromBundle()
        }
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            
            do {
                pictures = try decoder.decode([Picture].self, from: savedData)
                print(pictures[0].views)
            } catch {
                print("Failed loading pictures info.")
            }
            
            
        }
    }
    
    func loadImagesFromBundle() {
        let fm = FileManager.default
        
        let path = Bundle.main.resourcePath!
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(Picture(name: item))
            }
        }
        
        pictures.sort()
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].name
            vc.pictureIndex = indexPath.row + 1
            vc.amountOfPictures = pictures.count
            
            pictures[indexPath.row].views += 1
            
            save()
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let enconder = JSONEncoder()
        
        if let savedData = try? enconder.encode(pictures) {
            let defaults = UserDefaults.standard
            
            print(pictures[0].views)
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed saving pictures info.")
        }
    }
}

