//
//  DraggableCardView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 4/23/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import pop

protocol DraggableCardDelegate: class {
    
    func card(card: DraggableCardView, wasDraggedWithFinishPercent percent: CGFloat, inDirection direction: SwipeResultDirection)
    func card(card: DraggableCardView, wasSwipedInDirection direction: SwipeResultDirection)
    func card(cardWasReset card: DraggableCardView)
    func card(cardWasTapped card: DraggableCardView)
    func card(cardSwipeThresholdMargin card: DraggableCardView) -> CGFloat?
}

//Drag animation constants
private let rotationMax: CGFloat = 1.0
private let defaultRotationAngle = CGFloat(Double.pi) / 10.0
private let scaleMin: CGFloat = 0.8
public let cardSwipeActionAnimationDuration: TimeInterval = 0.4

//Reset animation constants
private let cardResetAnimationSpringBounciness: CGFloat = 10.0
private let cardResetAnimationSpringSpeed: CGFloat = 20.0
private let cardResetAnimationKey = "resetPositionAnimation"
private let cardResetAnimationDuration: TimeInterval = 0.2

public class DraggableCardView: UIView {
    
    weak var delegate: DraggableCardDelegate?
    
    private var overlayView: OverlayView?
    private(set) var contentView: UIView?
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var animationDirection: CGFloat = 1.0
    private var dragBegin = false
    private var dragDistance = CGPoint.zero
    private var actionMargin: CGFloat = 0.0
    
    //MARK: Lifecycle
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override public var frame: CGRect {
        didSet {
            actionMargin = delegate?.card(cardSwipeThresholdMargin: self) ?? frame.size.width / 2.0
        }
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
        removeGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panGestureRecognized:"))
        addGestureRecognizer(panGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapRecognized:"))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: Configurations
    func configure(view: UIView, overlayView: OverlayView?) {
        self.overlayView?.removeFromSuperview()
        self.contentView?.removeFromSuperview()
        
        if let overlay = overlayView {
            self.overlayView = overlay
            overlay.alpha = 0;
            self.addSubview(overlay)
            configureOverlayView()
            self.insertSubview(view, belowSubview: overlay)
        } else {
            self.addSubview(view)
        }
        
        self.contentView = view
        configureContentView()
    }
    
    private func configureOverlayView() {
        if let overlay = self.overlayView {
            overlay.translatesAutoresizingMaskIntoConstraints = false
            
            let width = NSLayoutConstraint(
                item: overlay,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1.0,
                constant: 0)
            let height = NSLayoutConstraint(
                item: overlay,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 1.0,
                constant: 0)
            let top = NSLayoutConstraint (
                item: overlay,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0)
            let leading = NSLayoutConstraint (
                item: overlay,
                attribute: NSLayoutConstraint.Attribute.leading,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.leading,
                multiplier: 1.0,
                constant: 0)
            addConstraints([width,height,top,leading])
        }
    }
    
    private func configureContentView() {
        if let contentView = self.contentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let width = NSLayoutConstraint(
                item: contentView,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1.0,
                constant: 0)
            let height = NSLayoutConstraint(
                item: contentView,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 1.0,
                constant: 0)
            let top = NSLayoutConstraint (
                item: contentView,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 0)
            let leading = NSLayoutConstraint (
                item: contentView,
                attribute: NSLayoutConstraint.Attribute.leading,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.leading,
                multiplier: 1.0,
                constant: 0)
            
            addConstraints([width,height,top,leading])
        }
    }
    
    //MARK: GestureRecognizers
    func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        dragDistance = gestureRecognizer.translation(in: self)
        
        let touchLocation = gestureRecognizer.location(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            
            let firstTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: firstTouchPoint.x / bounds.width, y: firstTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            removeAnimations()
            
            dragBegin = true
            
            animationDirection = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
            
            layer.shouldRasterize = true
            
            break
        case .changed:
            let rotationStrength = min(dragDistance.x / frame.width, rotationMax)
            let rotationAngle = animationDirection * defaultRotationAngle * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * abs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
    
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, scale, scale, 1)
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, dragDistance.x, dragDistance.y, 0)
            layer.transform = transform
            
            updateOverlayWithFinishPercent(percent: dragDistance.x / frame.width)
            //100% - for proportion
            delegate?.card(card: self, wasDraggedWithFinishPercent: min(abs(dragDistance.x * 100 / frame.width), 100), inDirection: dragDirection)
            
            break
        case .ended:
            swipeMadeAction()
            
            layer.shouldRasterize = false
        default :
            break
        }
    }
    
    func tapRecognized(recogznier: UITapGestureRecognizer) {
        delegate?.card(cardWasTapped: self)
    }
    
    //MARK: Private
    private var dragDirection: SwipeResultDirection {
        return dragDistance.x > 0 ? .Right : .Left
    }
    
    private func updateOverlayWithFinishPercent(percent: CGFloat) {
        if let overlayView = self.overlayView {
            overlayView.overlayState = percent > 0.0 ? OverlayMode.Right : OverlayMode.Left
            //Overlay is fully visible on half way
            let overlayStrength = min(abs(2 * percent), 1.0)
            overlayView.alpha = overlayStrength
        }
    }
    
    private func swipeMadeAction() {
        
        if abs(dragDistance.x) >= actionMargin {
            swipeAction(direction: dragDirection)
        } else {
            resetViewPositionAndTransformations()
        }
    }
    
    private func swipeAction(direction: SwipeResultDirection) {
        
        let screenWidth = UIScreen.main.bounds.width
        let translation = screenWidth + (screenWidth / 2)
        let directionMultiplier: CGFloat = direction == .Left ? -1 : 1
        let finishTranslation = directionMultiplier * translation
        
        overlayView?.overlayState = direction == .Left ? .Left : .Right
        overlayView?.alpha = 1.0
        delegate?.card(card: self, wasSwipedInDirection: direction)
        let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationX)
        translationAnimation!.duration = cardSwipeActionAnimationDuration
        translationAnimation!.fromValue = POPLayerGetTranslationX(layer)
        translationAnimation!.toValue = finishTranslation
        translationAnimation!.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
        layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
    }
    
    private func resetViewPositionAndTransformations() {
        delegate?.card(cardWasReset: self)
        
        removeAnimations()
        
        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        resetPositionAnimation!.fromValue = NSValue(cgPoint: CGPoint(x: dragDistance.x, y: dragDistance.y))
        resetPositionAnimation!.toValue = NSValue(cgPoint: CGPoint.zero)
        resetPositionAnimation!.springBounciness = cardResetAnimationSpringBounciness
        resetPositionAnimation!.springSpeed = cardResetAnimationSpringSpeed
        resetPositionAnimation!.completionBlock = {
            (_, _) in
            self.layer.transform = CATransform3DIdentity
            self.dragBegin = false
        }
        
        layer.pop_add(resetPositionAnimation, forKey: "resetPositionAnimation")
        
        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        resetRotationAnimation!.fromValue = POPLayerGetRotationZ(layer)
        resetRotationAnimation!.toValue = CGFloat(0.0)
        resetRotationAnimation!.duration = cardResetAnimationDuration
        
        layer.pop_add(resetRotationAnimation, forKey: "resetRotationAnimation")
        
        let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        overlayAlphaAnimation!.toValue = 0.0
        overlayAlphaAnimation!.duration = cardResetAnimationDuration
        overlayAlphaAnimation!.completionBlock = { _, _ in
            self.overlayView?.alpha = 0
        }
        overlayView?.pop_add(overlayAlphaAnimation, forKey: "resetOverlayAnimation")
        
        let resetScaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        resetScaleAnimation!.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        resetScaleAnimation!.duration = cardResetAnimationDuration
        layer.pop_add(resetScaleAnimation, forKey: "resetScaleAnimation")
    }
    
    //MARK: Public
    func removeAnimations() {
        pop_removeAllAnimations()
        layer.pop_removeAllAnimations()
    }
    
    func swipe(direction: SwipeResultDirection) {
        if !dragBegin {
            delegate?.card(card: self, wasSwipedInDirection: direction)
            
            let screenWidth = UIScreen.main.bounds.width
            let finalPosition = direction == .Left ? -screenWidth : 2 * screenWidth
            
            let swipePositionAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
            swipePositionAnimation!.toValue = finalPosition
            swipePositionAnimation!.duration = cardSwipeActionAnimationDuration
            swipePositionAnimation!.completionBlock = {
                (_, _) in
                self.removeFromSuperview()
            }
            
            layer.pop_add(swipePositionAnimation, forKey: "swipePositionAnimation")
            
            let swipeRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
            swipeRotationAnimation!.fromValue = POPLayerGetRotationZ(layer)
            swipeRotationAnimation!.toValue = CGFloat(direction == .Left ? -Double.pi / 4 : Double.pi / 4)
            swipeRotationAnimation!.duration = cardSwipeActionAnimationDuration
            
            layer.pop_add(swipeRotationAnimation, forKey: "swipeRotationAnimation")
            
            overlayView?.overlayState = direction == .Left ? .Left : .Right
            let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            overlayAlphaAnimation!.toValue = 1.0
            overlayAlphaAnimation!.duration = cardSwipeActionAnimationDuration
            overlayView?.pop_add(overlayAlphaAnimation, forKey: "swipeOverlayAnimation")
        }
    }
}
