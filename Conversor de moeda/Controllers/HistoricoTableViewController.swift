//
//  HistoricoTableViewController.swift
//  Conversor de moeda
//
//  Created by vinicius dev on 22/12/19.
//  Copyright © 2019 vinicius dev. All rights reserved.
//

import UIKit

class HistoricoTableViewController: UITableViewController {
    let dateFormatter = DateFormatter()
    let reuseIdentifier = "historicoCell"
    var data: [Historico] = []
    
    override func viewWillAppear(_ animated: Bool) {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = CoreDataManager.shared.loadHistorico()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as UITableViewCell
        
        let historico = data[indexPath.row]
        
        cell.textLabel?.text = "\(historico.moedaOrigem ?? "") (\(historico.valorInformado)) > \(historico.moedaDestino ?? "") (\(historico.moedaDestinoValor * historico.valorInformado))"
        cell.detailTextLabel?.text = dateFormatter.string(from: historico.data ?? Date())
        
        return cell
    }
    
}
