//
//  ChangeLanguageTableViewController.swift
//  i18n_Example
//
//  Created by gavin on 2023/10/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class ChangeLanguageTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let data = LanguageType.allCases[indexPath.row].rawValue
        cell.textLabel?.text = data

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = LanguageType.allCases[indexPath.row]
        LanguageManager.setLanguage(type: data)
        
        self.navigationController?.popViewController(animated: true)
    }

}
