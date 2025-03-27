
import Foundation

class AllCategoryRepo {
    // MARK: Lifecycle

    deinit {
        debugPrint("repository deinited")
    }

    init(apiRrequest: APIRequest) {
        self.apiRrequest = apiRrequest
    }

    // MARK: Internal

    lazy var allCategoryService: AllCategoriesService? = .init(apiRequest: self.apiRrequest)

    // MARK: Private

    private var apiRrequest: APIRequest
}

