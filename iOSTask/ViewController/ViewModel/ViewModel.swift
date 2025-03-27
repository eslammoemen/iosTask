//
//  ViewModel.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/25/25.
//

import Foundation
import Combine

enum ViewState: Equatable {
    case idle
    case error(String)
    case loading
    case succsss(String)
}

protocol BaseViewModelProtocol {
    var viewStatesPublisher: PassthroughSubject<ViewState, Never> { get }
    
    func viewModelDidLoad()
}

final class ViewModel: BaseViewModelProtocol {
    
    var viewStatesPublisher: PassthroughSubject<ViewState, Never> = .init()
    var allcategoriesPublisher: PassthroughSubject<Void, Never> = .init()
    var subCategoriesPublisher: PassthroughSubject<Void, Never> = .init()
    var subCategoriesProperitiesPublisher: PassthroughSubject<Void, Never> = .init()
    
    private let service = NetworkManager.shared.allCategoryRepo?.allCategoryService
    
    private (set) var allCats: [Category]? = []
    private (set) var subCategories: [SubCategoryModel]? = []
    private (set) var categoriesProperities: [SubCategoryModel]? = []
    
    
    var selectedItems: [SelectedItems]? = [] {
        didSet {
            print(selectedItems)
        }
    }
    
    func resetSubcatProperities() {
        subCategories = []
        categoriesProperities = []
        //
        subCategoriesProperitiesPublisher.send()
        subCategoriesPublisher.send()
        
    }
    func viewModelDidLoad() {
        Task {
            await getAllCatgeories()
        }
    }
    func getCategoriesProperities(subcatId: Int) {
        Task {
            await MainActor.run {
                viewStatesPublisher.send(.loading)
            }
            do {
                let res = try await subCategoryProperities(id: subcatId)
                self.categoriesProperities = res
                if categoriesProperities?.isEmpty == false {
                    self.categoriesProperities?.append(.init(id: 0, name: "other option"))
                }
                await MainActor.run {
                    subCategoriesProperitiesPublisher.send()
                    viewStatesPublisher.send(.idle)
                }
            } catch {
                print(error)
                await MainActor.run {
                    viewStatesPublisher.send(.idle)
                }
            }
        }
    }
    func getSubCategories(id: Int)  {
        Task {
            await MainActor.run {
                viewStatesPublisher.send(.loading)
            }
            do {
                let res = try await subCategories(id: id)
                self.subCategories = res
                if subCategories?.isEmpty == false {
                    self.subCategories?.append(.init(id: 0, name: "other option"))
                }
                await MainActor.run {
                    subCategoriesPublisher.send()
                    viewStatesPublisher.send(.idle)
                }
            } catch {
                print(error)
                await MainActor.run {
                    viewStatesPublisher.send(.idle)
                }
            }
        }

    }
    func getAllCatgeories() async {
        await MainActor.run {
            viewStatesPublisher.send(.loading)
        }

        do {
            let res = try await allCategories()
            self.allCats = res
            if allCats?.isEmpty == false {
                self.allCats?.append(.init(id: 0, name: "other option"))
            }
            await MainActor.run {
                allcategoriesPublisher.send()
                viewStatesPublisher.send(.idle)
            }
        } catch {
            print(error)
            await MainActor.run {
                viewStatesPublisher.send(.idle)
            }
        }
        
        
        
    }
    
    func selectedItemsCount() -> Int {
        return selectedItems?.count ?? 0
    }
    func subCategoryProperities(id: Int) async throws -> [SubCategoryModel]? {
        let result = try await service?.getOptionsProperities(id: id)
        return result?.data
    }
    
    func subCategories(id: Int) async throws -> [SubCategoryModel]? {
        let result = try await service?.getSubCategories(id: id)
        return result?.data
    }
    
    func allCategories() async throws -> [Category]? {
        let result = try await service?.getALlCategoriesList()
        return result?.data?.categories
    }
    
}

extension ViewModel {
    struct SelectedItems {
        let name: String?
        let id: Int?
    }
}
