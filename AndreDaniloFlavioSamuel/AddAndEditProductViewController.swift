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
    @IBOutlet weak var btAddEdit: UIButton!
    
    var product: Product!
    
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
        if (product != nil){
            tfNameProduct.text = product.name
            if let state = product.state, let index = statesManager.states.firstIndex(of: state){
                tfStateSale.text = state.state
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            
            tfValue.text = String(product.value)
            switchCrediCard.isOn = product.creditCard
            if let image = product.cover as? UIImage {
                ivCover.image = image
            }
            btAddEdit.setTitle("EDITAR", for: .normal)
            title = "Editar Produto"
        }
    }
    
    @IBAction func addProduct(_ sender: Any) {
        if (product == nil){
            product = Product(context: context)
        }
        
        product.name = tfNameProduct.text
        
        if !tfStateSale.text!.isEmpty {
            let state = statesManager.states[pickerView.selectedRow(inComponent: 0)]
            product.state = state
        }
        
        product.creditCard = switchCrediCard.isOn
        product.value = tc.convertToDouble(tfValue.text!)
        product.cover = ivCover.image
        
        do {
            try context.save()
            print("adicionou, o que fazer agora?")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addCoverProduct(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar pôster", message: "De onde você deseja escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { _ in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { _ in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
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

extension AddAndEditProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            ivCover.image = image
        }
        
        dismiss(animated: true)
    }
}


