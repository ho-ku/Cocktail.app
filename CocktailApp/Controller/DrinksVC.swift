//
//  ViewController.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 08.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class DrinksVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let requestManager = RequestManager()
    private var categories: [Category] = []
    private var selectedCategories: [Category] = []
    private let cache = NSCache<NSString, AnyObject>()
    private var loadedCount: Int = 0
    private var drinksInRecentLoadedSectionCount: Int = 0
    private var isDataLoading: Bool = false
    private let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        makeCategoriesRequest()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func filterCategories() {
        selectedCategories = categories.filter { $0.isSelected }
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
    
    private func makeCategoriesRequest() {
        requestManager.requestCategories { [unowned self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                guard let parsed = try? JSONDecoder().decode(Categories.self, from: data) else { return }
                let objects = parsed.drinks
                self.categories = objects.map { Category(object: $0) }
                self.filterCategories()
                self.loadCategory(index: 0)
                DispatchQueue.main.async { [unowned self] in
                    self.updateUI()
                }
            }
        }
    }
    
    private func loadCategory(index: Int) {
        if loadedCount < index { return }
        if index == selectedCategories.count {
            print("Списки закончились")
            return
        }
        let categoryName = selectedCategories[index].name
        requestManager.requestCategory(categoryName: categoryName) { [unowned self] result in
            self.loadedCount += 1
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                guard let objects = try? JSONDecoder().decode(Drinks.self, from: data) else { return }
                let drinks = objects.drinks.map { Drink(object: $0) }
                self.drinksInRecentLoadedSectionCount = drinks.count
                self.cache.setObject(drinks.count as AnyObject, forKey: NSString(string: "\(categoryName)count"))
                for (index, drink) in drinks.enumerated() {
                    self.cache.setObject(drink as AnyObject, forKey: NSString(string: "\(categoryName)\(index)"))
                    self.isDataLoading = false
                    DispatchQueue.main.async { [unowned self] in
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func filtersBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: C.filtersSegueIdentifier, sender: self)
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.filtersSegueIdentifier {
            guard let dest = segue.destination as? FiltersVC else { return }
            dest.delegate = self
            dest.categories = categories
        }
    }
    
}
// MARK: - UITableViewDelegate
extension DrinksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedCategories[section].name
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            if !isDataLoading {
                isDataLoading = true
                loadCategory(index: loadedCount)
            }
        }

    }
    
}
// MARK: - UITableViewDataSource
extension DrinksVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loadedCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryName = selectedCategories[section].name
        guard let count = cache.object(forKey: NSString(string: "\(categoryName)count")) as? Int else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.drinkCellIdentidier, for: indexPath) as? DrinkCell, let drink = cache.object(forKey: NSString(string: "\(selectedCategories[indexPath.section].name)\(indexPath.row)")) as? Drink else { return UITableViewCell() }
        cell.drinkTitleLabel.text = drink.name
        if let image = imageCache.object(forKey: NSString(string: "image\(indexPath.section)\(indexPath.row)")) {
            cell.drinkImageView.image = image
        } else {
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                self.requestManager.requestImage(urlString: drink.imageURLString) { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let data):
                        if let img = UIImage(data: data) {
                            DispatchQueue.main.async { [unowned self] in
                                cell.drinkImageView.image = img
                                self.imageCache.setObject(img, forKey: NSString(string: "image\(indexPath.section)\(indexPath.row)"))
                            }
                        }
                    }
                }
            }
        }
        return cell
    }

}
// MARK: - FiltersDelegate
extension DrinksVC: FiltersDelegate {
    
    func didUpdateCategories(_ newCategories: [Category]) {
        loadedCount = 0
        drinksInRecentLoadedSectionCount = 0
        updateUI()
        categories = newCategories
        filterCategories()
        cache.removeAllObjects()
        loadCategory(index: 0)
    }
    
}
