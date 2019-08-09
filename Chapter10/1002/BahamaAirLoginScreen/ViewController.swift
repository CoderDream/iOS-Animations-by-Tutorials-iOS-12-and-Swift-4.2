/*
 * Copyright (c) 2014-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = layer.backgroundColor
    tint.toValue = toColor.cgColor
    tint.duration = 0.5
    layer.add(tint, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}

// Challenge 3: Animating corner radius
func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = layer.cornerRadius
    round.toValue = toRadius
    round.duration = 0.5
    layer.add(round, forKey: nil)
    layer.cornerRadius = toRadius
}


class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    // 信息标签
    let info = UILabel()

    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        statusPosition = status.center
        
        // 设置标签并添加到视图中
        info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0,  width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clear
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .center
        info.textColor = UIColor.white
        info.text = "Tap on a field and enter username and password"
        view.insertSubview(info, belowSubview: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 手动给heading添加layer动画
        // 1. 定义一个x轴方向的基本动画
        let flyRight = CABasicAnimation(keyPath: "position.x")
        // 2. 设置初始位置
        flyRight.fromValue = -view.bounds.size.width/2
        // 3. 设置目的位置
        flyRight.toValue = view.bounds.size.width/2
        // 4. 设置动画经过的时间
        flyRight.duration = 0.5
        // 设置代理
        flyRight.delegate = self
        flyRight.setValue("form", forKey: "name")
        flyRight.setValue(heading.layer, forKey: "layer")
        // 5. 将动画添加到 heading 控件上
        heading.layer.add(flyRight, forKey: nil)
        
        // 延迟 0.3 秒
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        //
        flyRight.fillMode = CAMediaTimingFillMode.both
        flyRight.setValue(username.layer, forKey: "layer")
        // 给用户名添加动画
        username.layer.add(flyRight, forKey: nil)
        
        // 延迟 0.3 秒
        flyRight.beginTime = CACurrentMediaTime() + 0.4
        flyRight.setValue(password.layer, forKey: "layer")
        // 给用户名添加动画
        password.layer.add(flyRight, forKey: nil)
        
        //flyRight.isRemovedOnCompletion = false
        
        // 隐藏三个控件
        //heading.center.x -= view.bounds.width
        //username.center.x -= view.bounds.width
        //password.center.x -= view.bounds.width
        username.layer.position.x = view.bounds.size.width/2
        password.layer.position.x = view.bounds.size.width/2
        
//        cloud1.alpha = 0.0
//        cloud2.alpha = 0.0
//        cloud3.alpha = 0.0
//        cloud4.alpha = 0.0
        
//        loginButton.center.y += 30.0
//        loginButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        fadeIn.duration = 0.5
        fadeIn.fillMode = .backwards
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(fadeIn, forKey: nil)
        
        // 登录按钮动画
//        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
//            self.loginButton.center.y -= 30.0
//            self.loginButton.alpha = 1.0
//        }, completion: nil)
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .backwards
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        // 缩放
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        
        // 旋转
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi / 4.0
        rotate.toValue = 0.0
        
        // 淡入淡出
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        
        groupAnimation.animations = [scaleDown, rotate, fade]
        loginButton.layer.add(groupAnimation, forKey: nil)
        
        //
        animateCloud(layer: cloud1.layer)
        animateCloud(layer: cloud2.layer)
        animateCloud(layer: cloud3.layer)
        animateCloud(layer: cloud4.layer)
        
        // 向左移动
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.frame.size.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5.0
        //
        flyLeft.repeatCount = 2.5
        flyLeft.autoreverses = true
        flyLeft.speed = 2.0
        info.layer.speed = 2.0
        view.layer.speed = 2.0
        info.layer.add(flyLeft, forKey: "infoappear")
        
        // 淡入淡出
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1.0
        fadeLabelIn.duration = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadein")
        
        // 设置输入框代理
        username.delegate = self
        password.delegate = self
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        
        // transitionCurlDown
        UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionFlipFromBottom], animations: {
            self.status.isHidden = false
        }, completion: { _ in
            //transition completion
            delay(2.0) {
                // 遍历 messages，显示各种信息
                if index < self.messages.count-1 {
                    self.removeMessage(index: index)
                } else {
                    //reset form
                    self.resetForm()
                }
            }
        })
    }
    
    func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
            self.status.center.x += self.view.frame.size.width
        }, completion: { _ in
            self.status.isHidden = true
            self.status.center = self.statusPosition
            
            self.showMessage(index: index+1)
        })
    }
    
    func resetForm() {
        UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop, animations: {
            self.status.isHidden = true
            self.status.center = self.statusPosition
        }, completion: { _ in
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
            roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.spinner.center = CGPoint(x: -20.0, y: 16.0)
            self.spinner.alpha = 0.0
            //self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.loginButton.bounds.size.width -= 80.0
            self.loginButton.center.y -= 60.0
        }, completion: nil)
    }
    
    func animateCloud(layer: CALayer) {
        // 1 云移动的速度
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        // 2
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width / 2
        cloudMove.delegate = self
        
        cloudMove.fillMode = .forwards
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        layer.add(cloudMove, forKey: nil)
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        // 登录按钮动画
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 80.0
        }, completion: { _ in
            self.showMessage(index: 0)
        })
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y += 60.0
            //self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
            self.spinner.alpha = 1.0
        }, completion: nil)
        
        let tintColoer = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColoer)
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
}

// add delegate
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation did finish")
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        
        if name == "form" {
            // form field found
            print("name == form")
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = 0.25
            layer?.add(pulse, forKey: nil)
        }
        
        if name == "layer" {
            if let layer = anim.value(forKey: "layer") as? CALayer {
                
                anim.setValue(nil, forKey: "layer")
                
                layer.position.x = -layer.bounds.width / 2
                delay(0.5) {
                    self.animateCloud(layer: layer)
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let runningAnimations = info.layer.animationKeys() else {
            return
        }
        print(runningAnimations)
        info.layer.removeAnimation(forKey: "infoappear")
    }
}
