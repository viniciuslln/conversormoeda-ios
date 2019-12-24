//
//  ConversorViewController.swift
//  Conversor de moeda
//
//  Created by vinicius dev on 22/12/19.
//  Copyright © 2019 vinicius dev. All rights reserved.
//

import UIKit
import Alamofire

class ConversorViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tipoMoedaLabel: UILabel!
    @IBOutlet weak var moedaDesejadaLabel: UILabel!
    
    @IBOutlet weak var tipoMoedaTextField: UITextField!
    @IBOutlet weak var moedaDesejadaTextField: UITextField!
    
    var moedaSelecionada: (moeda: String, valor: Double) = ("",0.0)
    var moedaDesejada: (moeda: String, valor: Double) =  ("",0.0)
    var valorMoedaSelecinada: Double = 0.0
    var valorMoedaDesejada: Double = 0.0
    
    var moedaPickerArray: [(moeda: String, valor: Double)] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialValues()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.moedaPickerArray[row].moeda
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.moedaPickerArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                openSheetMoeda(origem: true)
            } else if indexPath.row == 1 {
                self.tipoMoedaTextField.becomeFirstResponder()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                openSheetMoeda(origem: false)
            } else if indexPath.row == 1 {
                self.moedaDesejadaTextField.becomeFirstResponder()
            }
        }
    }
    
    func openSheetMoeda(origem: Bool) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: "Moeda", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
            if origem {
                self.loadMoedaSelecionada(moeda: self.moedaPickerArray[pickerView.selectedRow(inComponent: 0)])
            } else {
                self.loadMoedaDesejada(moeda: self.moedaPickerArray[pickerView.selectedRow(inComponent: 0)])
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func ConvertCick(_ sender: Any) {
        let valorString = (tipoMoedaTextField?.text?.isEmpty == true) ? "0.0" : tipoMoedaTextField?.text ?? "0.0"
        
        let valorFinal = Double(valorString)! * moedaDesejada.valor
        moedaDesejadaTextField.text = String(valorFinal)
        CoreDataManager.shared.saveHistorico(data: Date(),
                                                 moedaDestino: moedaDesejada.moeda,
                                                 moedaDestinoValor: moedaDesejada.valor,
                                                 moedaOrigem: moedaSelecionada.moeda,
                                                 valorInformado: Double(valorString)!)
    }
    
    func loadInitialValues(){
        AF.request("https://api.exchangeratesapi.io/latest").responseDecodable { (response: DataResponse<ExchangeRate,AFError>) in
            if let data = response.value {
                self.moedaSelecionada = (data.base , 0.0)
                self.moedaPickerArray = data.rates.map { ($0, $1) }.sorted { $0.0 < $1.0 }
                if self.moedaPickerArray.count > 0 {
                    self.moedaDesejada = self.moedaPickerArray[0]
                    self.tipoMoedaLabel.text = self.moedaSelecionada.0
                    self.moedaDesejadaLabel.text = self.moedaDesejada.0
                }
            }
        }
    }
    
    func loadMoedaSelecionada(moeda: (moeda: String, valor: Double) ) {
        self.moedaSelecionada = moeda
        self.tipoMoedaLabel.text = moeda.moeda
        
        AF.request("https://api.exchangeratesapi.io/latest?base=\(self.moedaSelecionada.moeda)").responseDecodable { (response: DataResponse<ExchangeRate,AFError>) in
            if let data = response.value {
                self.moedaPickerArray = data.rates.map { ($0, $1) }.sorted { $0.0 < $1.0 }
                self.moedaDesejada = self.moedaPickerArray[0]
                self.moedaDesejadaLabel.text = self.moedaDesejada.0
            }
        }
    }
    
    func loadMoedaDesejada(moeda: (moeda: String, valor: Double)){
        self.moedaDesejada = moeda
        self.moedaDesejadaLabel.text = self.moedaDesejada.0
    }
    
}
