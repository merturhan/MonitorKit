//
//  MonitorKitListViewController.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

final class MonitorKitListViewController: UIViewController {
    
    private let manager = MonitorKitManager.shared
    private var records: [MonitorKitRecord] = []
    
    private let headerView = MonitorKitListHeaderView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.frame = UIScreen.main.bounds
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        tableView.register(MonitorKitListCell.self, forCellReuseIdentifier: MonitorKitListCell.identifier)
    }
    
    private func setupDelegations() {
        tableView.dataSource = self
        tableView.delegate = self
        manager.delegate = self
    }
    
    private func load() {
        self.records = manager.records
        tableView.reloadData()
    }
    
    private func goToDetails(with record: MonitorKitRecord?) {
        guard let record else { return }
        
        let detailViewController = MonitorKitDetailViewController(record: record)
        present(detailViewController, animated: true)
    }
}

extension MonitorKitListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: MonitorKitListCell.self, at: indexPath)
        
        if let record = records[safe: indexPath.row] {
            cell.configure(with: record)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let record = records[safe: indexPath.row]
        goToDetails(with: record)
    }
}

extension MonitorKitListViewController: MonitorKitManagerDelegate {
    func monitorKitDidUpdate(records: [MonitorKitRecord]) {
        self.records = records
        self.tableView.reloadData()
    }
}
