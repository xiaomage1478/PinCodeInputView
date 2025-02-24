//
//  ItemView.swift
//  PinCodeInputView
//
//  Created by Jinsei Shima on 2018/11/17.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

// Default Item View

@IBDesignable
public class ItemView: UIView, ItemType {
    
    public var text: Character? = nil {
        didSet {
            guard let text = text else {
                label.text = nil
                return
            }
            label.text = String(text)
        }
    }
    
    public var isHiddenCursor: Bool = true {
        didSet {
            cursor.isHidden = isHiddenCursor
			if (isHiddenCursor) {
                self.backgroundColor = _appearance?.backgroundColor
                self.layer.borderColor = _appearance?.borderColor.cgColor
				self.layer.borderWidth = 1
			} else {
                self.backgroundColor = _appearance?.highlightBackgroundColor
                self.layer.borderColor = _appearance?.highlightBorderColor.cgColor
				self.layer.borderWidth = 1
			}
        }
    }
    
    public let label: UILabel = .init()
    public let cursor: UIView = .init()
    
    public init() {
        
        super.init(frame: .zero)
        
        addSubview(label)
        addSubview(cursor)
        
        clipsToBounds = true
        
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        
        cursor.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBack), name: UIApplication.didEnterBackgroundNotification, object: nil)
        becomeActive()

    }
    
    /// 闪烁动画
    fileprivate var opacityAnimation: CABasicAnimation = {
        let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.9
        opacityAnimation.repeatCount = HUGE
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.fillMode = .forwards
        opacityAnimation.timingFunction = CAMediaTimingFunction.init(name: .linear)
        return opacityAnimation
    }()
    
    
    /// 去后台
    @objc fileprivate func enterBack() {
        // 移除动画
        cursor.layer.removeAnimation(forKey: "kOpacityAnimation")
    }
    
    /// 回前台
    @objc fileprivate func becomeActive() {
        // 重新添加动画
        cursor.layer.add(opacityAnimation, forKey: "kOpacityAnimation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
        
        let width: CGFloat = 2
        let height: CGFloat = bounds.height * 0.6
        
        cursor.frame = CGRect(
            x: (bounds.width - width) / 2,
            y: (bounds.height - height) / 2,
            width: width,
            height: height
        )
    }
    
    private var _appearance: ItemAppearance?
    
    public func set(appearance: ItemAppearance) {
        _appearance = appearance
        bounds.size = appearance.itemSize
        label.font = appearance.font
        label.textColor = appearance.textColor
        cursor.backgroundColor = appearance.cursorColor
        backgroundColor = appearance.backgroundColor
        layer.cornerRadius = appearance.cornerRadius
		self.layer.borderColor = appearance.borderColor.cgColor
        layoutIfNeeded()
    }
}
