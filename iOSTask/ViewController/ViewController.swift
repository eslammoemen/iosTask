//
//  ViewController.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/25/25.
//

import UIKit
import iOSDropDown
import Combine

class ViewController: BaseViewController<ViewModel> {
    
    @IBOutlet weak var allCatDropDown: DropDown!
    @IBOutlet weak var categoryProperities: DropDown!
    @IBOutlet weak var subCatOptions: DropDown!
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var custompopupView: UIView = {
        var view = UIView(frame: .init(x: 10, y: 80, width: UIScreen.main.bounds.width, height: 60))
        let textFeild = UITextField(frame: .init(x: 10, y: 0, width: view.frame.width - 20, height: view.frame.height + 20))
        textFeild.placeholder = "eneter custom subcategory"
        view.addSubview(textFeild)
        view.backgroundColor = .lightGray
        view.center = self.view.center
        return view
    }()
    private lazy var tableView: UITableView = {
        var table = UITableView(frame: .init(x: 10, y: 100, width: view.frame.width + 10, height: 400))
        table.backgroundColor = .lightGray
        table.layer.cornerRadius = 10
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if custompopupView.isDescendant(of: view) {
            custompopupView.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        DropDownPublisher()
        dropDownSelectAction()
        
        [allCatDropDown, categoryProperities, subCatOptions].forEach({$0?.listWillAppear { [weak self] in
            guard let self = self else { return }
            if custompopupView.isDescendant(of: view) {
                custompopupView.removeFromSuperview()
            }
            
        }})
    }
    
    private func DropDownPublisher() {
        viewModel
            .allcategoriesPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                setupDropDown()
            }
            .store(in: &cancellables)
        
        viewModel
            .subCategoriesPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                setupProperitiesDropDown()
            }
            .store(in: &cancellables)
        viewModel
            .subCategoriesProperitiesPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                setupSubcatOptions()
                
                
            }
            .store(in: &cancellables)
    }
    
    private func dropDownSelectAction() {
        allCatDropDown
            .didSelect { [weak self] selectedText, index, id   in
                print(selectedText, index, id)
                guard let self = self else { return }
                guard id != 0 else {
                    view.addSubview(custompopupView)
                    return
                }
                viewModel.selectedItems?.removeAll()
                viewModel.selectedItems?.append(.init(name: selectedText, id: id))
                resetDropDownsData()
                viewModel.getSubCategories(id: id)
                   
            }
        categoryProperities.didSelect { [weak self] selectedText, index, id in
            guard let self = self else { return }
            guard id != 0 else {
                return
            }
            viewModel.getCategoriesProperities(subcatId: id)
            viewModel.selectedItems?.append(.init(name: selectedText, id: id))
        }
        subCatOptions.didSelect { [weak self] selectedText, index, id in
            guard let self = self else { return }
            guard id != 0 else {
                return
            }
            viewModel.selectedItems?.append(.init(name: selectedText, id: id))
        }
    }
    
    private func resetDropDownsData() {
        viewModel.resetSubcatProperities()
        categoryProperities.text = ""
        subCatOptions.text = ""
    }
    private func setupDropDown() {
        if let names = viewModel.allCats?.compactMap({$0.name}),
           let ids = viewModel.allCats?.compactMap({$0.id}) {
            allCatDropDown.optionArray = names
            allCatDropDown.optionIds = ids
        }
       
    }
    private func setupProperitiesDropDown() {
        if let names = viewModel.subCategories?.compactMap({$0.name}),
           let ids = viewModel.subCategories?.compactMap({$0.id}) {
            categoryProperities.optionArray = names
            categoryProperities.optionIds = ids
        }
        
    }
    private func setupSubcatOptions() {
        if let names = viewModel.categoriesProperities?.compactMap({$0.name}),
           let ids = viewModel.categoriesProperities?.compactMap({$0.id}) {
            subCatOptions.optionArray = names
            subCatOptions.optionIds = ids
            
        }
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        view.addSubview(tableView)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                return cell
            }()
            let currentValue = viewModel.selectedItems?[indexPath.row]
        cell.textLabel?.text = "\(currentValue?.name ?? "") with id \(currentValue?.id ?? 0)"
            
            return cell
    }
    
    
}
