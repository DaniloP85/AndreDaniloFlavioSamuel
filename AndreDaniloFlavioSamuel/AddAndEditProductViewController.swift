//
//  AddAndEditProductViewController.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//

import UIKit
import CoreData

class AddAndEditProductViewController: UIViewController {
    
    @IBOutlet weak var tfNameProduct: UITextField!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var tfStateSale: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var switchCrediCard: UISwitch!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var statesManager = StateManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btCancel, btFlex, btDone]
        
        tfStateSale.inputView = pickerView
        tfStateSale.inputAccessoryView = toolbar
    }
    
    @objc func cancel(){
        tfStateSale.resignFirstResponder()
    }
    
    @objc func done(){
        tfStateSale.text = statesManager.states[pickerView.selectedRow(inComponent: 0)].state
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statesManager.loadStates(with: context)
    }
    
    @IBAction func addCoverProduct(_ sender: Any) {
        print("add image")
    }
        
    @IBAction func addProduct(_ sender: Any) {
        print("add produto")
    }
}

extension AddAndEditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesManager.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = statesManager.states[row]
        return state.state
    }
}

extension AddAndEditProductViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
//        tableView.reloadData()
    }
}
