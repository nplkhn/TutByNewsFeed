////
////  Animator.swift
////  TutbyFeedViewer
////
////  Created by Никита Плахин on 10/29/20.
////
//
//import Foundation
//import UIKit
//
//class Animator: NSObject, UIViewControllerAnimatedTransitioning {
//    static let duration: TimeInterval = 0.25
//
//    private let type: PresentationType
//    private let firstVC: NewsCollectionViewController
//    private let secondVC: NewsViewController
//    private let selectedCellContentViewSnapshot: UIView
//    private let cellContentViewRect: CGRect
//
//    init?(type: PresentationType, firstVC: NewsCollectionViewController, secondVC: NewsViewController, selectedCellContentViewSnapshot: UIView) {
//        self.type = type
//        self.firstVC = firstVC
//        self.secondVC = secondVC
//        self.selectedCellContentViewSnapshot = selectedCellContentViewSnapshot
//
//        guard let window = firstVC.view.window ?? secondVC.view.window,
//              let selectedCell = firstVC.selectedCell else { return nil }
//        self.cellContentViewRect = selectedCell.contentView.convert(selectedCell.contentView.bounds, to: window)
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return Self.duration
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//
//        guard let toView = secondVC.view
//            else {
//                transitionContext.completeTransition(false)
//                return
//        }
//
//        containerView.addSubview(toView)
//
//        guard let selectedCell = firstVC.selectedCell,
//              let window = firstVC.view.window ?? secondVC.view.window,
//              let cellContentSnapshot = selectedCell.contentView.snapshotView(afterScreenUpdates: true),
//              let controllerContentSnapshot = secondVC.view.snapshotView(afterScreenUpdates: true) else {
//            transitionContext.completeTransition(false)
//            return
//        }
//
//
//
//        let isPresenting = type.isPresenting
//        let contentViewSnapshot: UIView
//
//        if isPresenting {
//            contentViewSnapshot = cellContentSnapshot
//        } else {
//            contentViewSnapshot = controllerContentSnapshot
//        }
//
//        toView.alpha = 0.0
//
//        [contentViewSnapshot].forEach { containerView.addSubview($0) }
//
//        let controllerContentViewRect = secondVC.view.convert(secondVC.view.bounds, to: window)
//
//        [contentViewSnapshot].forEach {
//            $0.frame = isPresenting ? cellContentViewRect : controllerContentViewRect
//        }
//
//        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic) {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
//                contentViewSnapshot.frame = isPresenting ? controllerContentViewRect : self.cellContentViewRect
//            }
//        } completion: { _ in
//            contentViewSnapshot.removeFromSuperview()
//            toView.alpha = 1
//
//            transitionContext.completeTransition(true)
//        }
//
//
//    }
//
//}
//
//enum PresentationType {
//    case present
//    case dismiss
//
//    var isPresenting: Bool {
//        return self == .present
//    }
//}
//
