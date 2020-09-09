//
//  FiltersVC.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 08.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

protocol FiltersDelegate: class {
    func didUpdateCategories(_ newCategories: [Category])
}

final class FiltersVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var categories: [Category] = []
    weak var delegate: FiltersDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func applyBtnPressed(_ sender: Any) {
        delegate?.didUpdateCategories(categories)
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - UITableViewDelegate
extension FiltersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categories[indexPath.row].isSelected.toggle()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(C.filterCellHeight)
    }
    
}
// MARK: - UITableViewDataSource
extension FiltersVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.filterCellIdentifier, for: indexPath) as? FilterCell else { return UITableViewCell() }
        let category = categories[indexPath.row]
        cell.filterTitleLabel.text = category.name
        cell.tickImageView.isHidden = !category.isSelected
        return cell
    }

}
