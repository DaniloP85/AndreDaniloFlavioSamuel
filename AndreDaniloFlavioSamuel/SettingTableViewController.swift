//
//  SettingTableViewController.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//

import UIKit
import CoreData

class SettingTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tfDollarQuotation: UITextField!
    
    // MARK: - Properties
    var state: State!
    var fetchedResultController: NSFetchedResultsController<State>!
    var label = UILabel()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Lista de estados vazia"
        label.textAlignment = .center
        loadState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConfigs(ok: "viewWillAppear")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setConfigs(ok: "touchesEnded")
        
    }
    
    
    // MARK: - IBActions
    @IBAction func addState(_ sender: Any) {
        showAlertAddAndEdit(with: nil)
    }
       
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        guard let state = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = state.state
        cell.detailTextLabel?.text = String(state.tax)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        state = fetchedResultController?.object(at: indexPath)
        showAlertAddAndEdit(with: state)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedResultController.object(at: indexPath)
            context.delete(state)
            try? context.save()
        }
    }
    
    // MARK: - Methods
    
    func setConfigs(ok:String){
        // falta pegar o momento exato para salvar as preferencias do usuario
        print("gravar \(ok)")
        tfDollarQuotation.text = String(tc.dollarQuotation)
        tfIOF.text = String(tc.IOF)
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "state", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func showAlertAddAndEdit(with state: State?) {
        let title = state == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
            if let state = state?.state{
                textField.text = state
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
            if let taxes = state?.tax{
                textField.text = self.tc.getString(of: taxes)
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let state = state ?? State(context: self.context)
            state.state = alert.textFields?.first?.text
            
            guard let taxes = alert.textFields?.last?.text else { return }
            state.tax = self.tc.convertToDouble(taxes)
            
            do {
                try self.context.save()
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }


}

// MARK: - Extension
extension SettingTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
}
