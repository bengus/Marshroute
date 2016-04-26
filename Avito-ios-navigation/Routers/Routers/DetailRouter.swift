import UIKit

/// Роутер, работающий с одним UINavigationController'ом, и выполняющий push- и reset-переходы
public protocol DetailRouter: class {
    func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder, Self: RouterControllersProviderHolder {
    
    public func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        setViewControllerDerivedFrom(
            deriveViewController,
            animator: ResetNavigationTransitionsAnimator()
        )
    }
    
    public func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        let resetContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingDetailTransitionsHandler.resetWithTransition(context: resetContext)
    }
    
    public func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        let pushContext = PresentationTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        detailTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
}