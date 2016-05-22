import Foundation

protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly

    func categoriesAssembly() -> CategoriesAssembly
    
    func subcategoriesAssembly() -> SubcategoriesAssembly
    
    func searchResultsAssembly() -> SearchResultsAssembly
    
    func advertisementAssembly() -> AdvertisementAssembly
    
    func recursionAssembly() -> RecursionAssembly
    
    func shelfAssembly() -> ShelfAssembly
    
    func authorizationAssembly() -> AuthorizationAssembly
    
    func bannerAssembly() -> BannerAssembly
}
