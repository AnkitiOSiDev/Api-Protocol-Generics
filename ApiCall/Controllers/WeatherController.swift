//
//  WeatherController.swift
//  ApiCall
//
//  Created by Ankit on 27/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    var apiRequest: APIRequest<WordApiResourse>?
    @IBOutlet weak var tableView: UITableView!
    var dataProvider : WeatherViewModel!
    var refreshControl :UIRefreshControl! = nil
    
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addSearchBar()
        addRefreshControl()
        dataProvider = WeatherViewModel(delegate: self, pagination: Paging(isPagingAvailable: false, paginStatus: .noData, pageLimit: 20))
            
        dataProvider.fetchFirstPage()
    }
    
    func addRefreshControl()  {
        refreshControl = UIRefreshControl()
        refreshControl.endRefreshing()
        refreshControl.addTarget(self, action: #selector(manualRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherTableViewCell.nibCell, forCellReuseIdentifier: WeatherTableViewCell.identifierCell)
    }
    
    func addSearchBar(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    @objc func manualRefresh() {
        self.refreshControl.beginRefreshing()
        dataProvider.fetchFirstPage()
    }
}


extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataProvider.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifierCell, for: indexPath) as? WeatherTableViewCell{
            cell.objWeather = dataProvider.getData(index: indexPath.row)
            return cell
        }
       return UITableViewCell()
    }
    
}


extension WeatherViewController:UITableViewDelegate {
    
}

extension WeatherViewController: DataProviderDelegate{
    func requestUpdatedSuccessFully() {
        DispatchQueue.main.async {
            self.lblWeather.text = self.dataProvider.getCurrentConditionD()
            self.iconWeather.image = self.dataProvider.getCurrentIcon()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func requestFailed(message: String) {
        print("requestFailed \(message)")
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        
    }
}

extension WeatherViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    
}
