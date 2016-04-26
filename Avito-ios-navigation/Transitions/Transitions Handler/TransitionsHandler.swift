/// Действия, вызываемые роутером для влияния на состояние навигации приложения
public protocol TransitionsHandler: class {
    /// Вызывается роутером, чтобы осуществить переход на другой модуль
    func performTransition(context context: PresentationTransitionContext)
    
    /// Вызывается роутером, чтобы отменить все переходы из своего модуля и вернуться на свой модуль.
    func undoTransitionsAfter(transitionId transitionId: TransitionId)
    
    /// Вызывается роутером, чтобы отменить все переходы из своего модуля и
    /// убрать свой модуль с экрана (вернуться на предшествующий модуль)
    func undoTransitionWith(transitionId transitionId: TransitionId)
    
    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей,
    /// но текущий модуль оставить нетронутым
    func undoAllChainedTransitions()

    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
    /// и отменить все переходы внутри модуля (аналог popToRootViewController).
    /// Удобно вызывать из роутера контейнера, чтобы вернуться на контроллер контейнера,
    /// потому что переходы из контейнера обычно вызываются не роутером контейнера,
    /// а роутерами содержащихся в контейнере модулей.
    func undoAllTransitions()
    
    /// Вызывается роутером, чтобы скрыть всю последовательность дочерних модулей
    /// и отменить все переходы внутри модуля (аналог popToRootViewController).
    /// После чего подменяется корневой контроллер (аналог setViewControllers:).
    /// Как правило вызывается роутером master - модуля SplitViewController'а,
    /// чтобы обновить detail
    func resetWithTransition(context context: ResettingTransitionContext)
}