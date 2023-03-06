//
//  AddAndEditProductViewController.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//

import UIKit
import CoreData

class AddAndEditProductViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfNameProduct: UITextField!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var tfStateSale: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var switchCrediCard: UISwitch!
    @IBOutlet weak var btAddEdit: UIButton!
    
    // MARK: - Properties
    var product: Product!
    var isLoadedImage: Bool = true
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var statesManager = StateManager.shared
   
    // MARK: - Super Methods

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statesManager.loadStates(with: context)
        if (product != nil){
            tfNameProduct.text = product.name
            if let state = product.state, let index = statesManager.states.firstIndex(of: state){
                tfStateSale.text = state.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            
            tfValue.text = String(product.value)
            switchCrediCard.isOn = product.creditCard
            if let image = product.cover as? UIImage {
                ivCover.image = image
                ivCover.contentMode = .scaleAspectFit
                isLoadedImage = false
            }
            btAddEdit.setTitle("EDITAR", for: .normal)
            title = "Editar Produto"
        }
    }
    // MARK: - Buttons pickerView
    
    @objc func cancel(){
        tfStateSale.resignFirstResponder()
    }
    
    @objc func done(){
        tfStateSale.text = statesManager.states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: button addProduct
    @IBAction func addProduct(_ sender: Any) {
        if tfNameProduct.text!.isEmpty {
            alertEmpty(title:"Nome do produto", message:"Deve ser preenchido")
            return
        }
        
        if isLoadedImage {
            alertEmpty(title:"Imagem do produto", message:"Escolha uma imagem")
            return
        }
        
        if tfStateSale.text!.isEmpty {
            alertEmpty(title:"Escolha um estado", message:"Deve ser preenchido")
            return
        }
        
        if tfValue.text!.isEmpty {
            alertEmpty(title:"Valor do produto", message:"Deve ser preenchido")
            return
        }
        
        if (product == nil){
            product = Product(context: context)
        }
        
        if !tfStateSale.text!.isEmpty {
            let state = statesManager.states[pickerView.selectedRow(inComponent: 0)]
            product.state = state
        }
        
        product.name = tfNameProduct.text
        product.creditCard = switchCrediCard.isOn
        product.value = formatterValues.convertToDouble(tfValue.text!)
        product.cover = ivCover.image
        
        do {
            try context.save()
        } catch {
            print("Algo deu errado...")
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: button add CoverProduct
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
    
    // MARK: - Methods
    

    func alertEmpty(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

// MARK: - Extension



// MARK: Picker view DataSource and Delegate
extension AddAndEditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesManager.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = statesManager.states[row]
        return state.name
    }
}

extension AddAndEditProductViewController: NSFetchedResultsControllerDelegate {
    // MARK: NSFetched Delegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

extension AddAndEditProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: UIImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            ivCover.image = image
            ivCover.contentMode = .scaleAspectFit
            isLoadedImage = false
        }
        
        dismiss(animated: true)
    }
}
