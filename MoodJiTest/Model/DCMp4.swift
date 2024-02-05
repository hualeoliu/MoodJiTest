//
//  DCMp4.swift
//  left-30sec
//
//  Created by lhl on 2020/12/11.
//  Copyright © 2020 left. All rights reserved.
//

import AVFoundation
import MediaPlayer
import SnapKit
import SwiftUI
import UIKit

struct Mp4View: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> DCMp4 {
        DCMp4()
    }

    func updateUIView(_ uiView: DCMp4, context: Context) {
        uiView.loadStart(url)
    }
}

let testurl = "https://v-cdn.zjol.com.cn/276984.mp4"
class DCMp4: UIView { // AVPictureInPictureSampleBufferPlaybackDelegate
    deinit {
        print("释放视频")
        gcd.cancleTimer(WithTimerName: "gcdTimeStr")
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            print("视频窗口离开")
            mp4P?.pause()
        }
    }

    var mp4Url: URL?
    func loadStart(_ ha: URL) {
        mp4Url = ha

        layoutMp4V()
        landDo()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let ero {
            print(ero)
        }

        let volume = AVAudioSession.sharedInstance().outputVolume
        volumeSliderSS = CGFloat(volume)
    }

    private func layoutMp4V() {
        addSubview(videoV)
        addSubview(controlV)
        controlV.addSubview(playBtn)
        controlV.addSubview(seekV)
        seekV.addSubview(seekL)
        self.addSubview(hudV)
        self.addSubview(lightV)
        lightV.addSubview(lightLeftV)
        lightV.addSubview(lightImgV)
        self.addSubview(v2)
        v2.addSubview(progressV)
        progressV.addSubview(loadProgressV)
        progressV.addSubview(playProgressV)
        v2.addSubview(curTimeL)
        v2.addSubview(allTimeL)
        v2.addSubview(bigBtn)

        controlV.backgroundColor = wbk5

        playBtn.center = controlV.center
        playBtn.setImage("playback_play".assetImg, for: .normal)
        playBtn.addTarget(self, action: #selector(playBtnDo), for: .touchUpInside)

        seekV.contentMode = .center
        seekL.offenLike(fm13, .center, wht)

        lightV.backgroundColor = w433Color
        lightV.alpha = 0
        lightV.decotate(nil, 10, nil, nil)
        lightLeftV.backgroundColor = wd2

        progressV.backgroundColor = w433Color
        loadProgressV.backgroundColor = w366Color
        playProgressV.backgroundColor = wb4

        curTimeL.offenLike(fb12, .right, wb4)
        allTimeL.offenLike(fb12, .left, wb4)

        let oneTG = UITapGestureRecognizer(target: self, action: #selector(oneTapDo))
        controlV.addGestureRecognizer(oneTG)
        let tt = UITapGestureRecognizer(target: self, action: #selector(twoTapDo))
        tt.numberOfTapsRequired = 2
        controlV.addGestureRecognizer(tt)
        oneTG.require(toFail: tt)

        let oneTG1 = UITapGestureRecognizer(target: self, action: #selector(oneTapDo))
        videoV.addGestureRecognizer(oneTG1)
        let tt1 = UITapGestureRecognizer(target: self, action: #selector(twoTapDo))
        tt1.numberOfTapsRequired = 2
        videoV.addGestureRecognizer(tt1)
        oneTG1.require(toFail: tt1)

        progressV.backgroundColor = wb4.withAlphaComponent(0.3)
        loadProgressV.backgroundColor = wb4.withAlphaComponent(0.4)
        playProgressV.backgroundColor = wb4

        v2.alpha = 0
        bigBtn.addTarget(self, action: #selector(bigDo), for: .touchUpInside)

        controlV.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGuestDo(_:))))
        videoV.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGuestDo(_:))))
    }

    func landDo() {
        self.snp.removeConstraints()
        self.snp.makeConstraints { m in
            m.left.right.equalToSuperview()
            m.top.equalToSuperview().offset(isLandscape ? 0 : lowSafeH)
            m.bottom.equalToSuperview().offset(isLandscape ? 0 : -lowSafeH)
        }

        videoV.snp.updateConstraints { m in
            m.edges.equalToSuperview()
        }

        controlV.snp.updateConstraints { m in
            m.edges.equalToSuperview()
        }
        playBtn.snp.updateConstraints { m in
            m.width.height.equalTo(50)
            m.center.equalToSuperview()
        }

        seekV.snp.updateConstraints { m in
            m.center.equalToSuperview()
            m.width.height.equalTo(50)
        }

        seekL.snp.updateConstraints { m in
            m.left.equalToSuperview().offset(-20)
            m.top.equalTo(50)
            m.right.equalToSuperview().offset(20)
            m.height.equalTo(20)
        }

        hudV.snp.updateConstraints { m in
            m.center.equalToSuperview()
        }

        lightV.snp.updateConstraints { m in
            m.centerX.equalToSuperview()
            m.top.equalTo(isLandscape ? 45 : 40)
            m.width.equalTo(200)
            m.height.equalTo(30)
        }

        lightImgV.snp.updateConstraints { m in
            m.left.equalTo(15)
            m.height.width.equalTo(15)
            m.centerY.equalToSuperview()
        }

        v2.snp.updateConstraints { m in
            m.left.equalTo((isLandscape ? 40 : 15) - 5)
            m.right.equalTo((isLandscape ? -40 : -15) + 5)
            m.bottom.equalTo(isLandscape ? -10 : 0)
            m.height.equalTo(40)
        }
        progressV.snp.updateConstraints { m in
            m.centerY.equalToSuperview()
            m.left.equalTo(40)
            m.right.equalTo(-80)
            m.height.equalTo(3)
        }
        curTimeL.snp.updateConstraints { m in
            m.centerY.equalTo(loadProgressV)
            m.right.equalTo(progressV.snp.left).offset(-10)
        }
        allTimeL.snp.updateConstraints { m in
            m.centerY.equalTo(loadProgressV)
            m.left.equalTo(progressV.snp.right).offset(10)
        }
        bigBtn.snp.updateConstraints { m in
            m.width.height.equalTo(40)
            m.right.centerY.equalToSuperview()
        }

        mp4Layer?.frame = CGRect(x: 0, y: 0, width: winW, height: isLandscape ? winH : winH - 2 * lowSafeH)
        bigBtn.setImage(isLandscape ? "smallMp4".assetImg : "bigVideo".assetImg, for: .normal)
    }

    private func growPlayer() {
        if mp4Item == nil {
            mp4Item = AVPlayerItem(url: mp4Url!)
            mp4P = AVPlayer(playerItem: mp4Item!)
            mp4P.automaticallyWaitsToMinimizeStalling = false
            mp4Layer = AVPlayerLayer(player: mp4P)
            videoV.layer.insertSublayer(mp4Layer, at: 0)
            videoV.setNeedsLayout()
            mp4Layer?.frame = CGRect(x: 0, y: 0, width: winW, height: isLandscape ? winH : winH - 2 * lowSafeH)
//            mp4Layer.videoGravity = .resizeAspectFill

            gcd.cancleTimer(WithTimerName: "gcdTimeStr")
            gcd.scheduledDispatchTimer(WithTimerName: "gcdTimeStr", timeInterval: 0.02, queue: .main, repeats: true, atOnce: true) { [weak self] in
                self?.callMp4Do()
            }
        }
    }

    private func callMp4Do() { // 主动嗅探
        if mp4Item.duration.value != 0 { // 获取视频总时间
            totalTime = CMTimeGetSeconds(mp4Item.duration)
            allTimeL.text = "\(totalTime.zeroStr)\""
        }

        let curTime = max(0, CMTimeGetSeconds(mp4Item.currentTime()))
        if curTime >= 30 {
            sec30DoBlock?()
            sec30DoBlock = nil
        }
        if isPanGShu == nil {
            playSacal = CGFloat(min(curTime / totalTime, 1))
            canSeekScale = max(canSeekScale, playSacal)
        }

        playProgressV.snp.removeConstraints()
        playProgressV.snp.updateConstraints { m in
            m.left.top.bottom.equalToSuperview()
            m.width.equalTo(progressV).multipliedBy(playSacal)
        }

        curTimeL.text = "\((Double(playSacal) * totalTime).zeroStr)\""
        if playSacal >= 1 { // 播完
            overDoBlock?()
            if isOverRestart {
                seekMp4By(0)
            } else {
                overDoBlock = nil
            }
        }

        if let timeRange = mp4Item.loadedTimeRanges.last?.timeRangeValue { // 视频数据加载进度
            let loadTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration))
            let loadScale = CGFloat(min(loadTime / totalTime, 1))

            loadProgressV.snp.removeConstraints()
            loadProgressV.snp.updateConstraints { m in
                m.left.top.bottom.equalToSuperview()
                m.width.equalTo(progressV).multipliedBy(loadScale)
            }
        }

//        print(mp4P.timeControlStatus.rawValue, mp4P.rate, isHandDo)
        if mp4P.timeControlStatus == .paused { // 根据实际播放状态设置按钮
            playBtn.setImage("playback_play".assetImg, for: .normal)
        } else {
            playBtn.setImage("playback_pause".assetImg, for: .normal)
        }

        if mp4Item.isPlaybackLikelyToKeepUp || isHandDo { // 缓冲足够继续播放或手动状态 隐藏缓冲
            if openOrHudVBlock != nil {
                openOrHudVBlock?(false)
            } else {
                hudV.animateHidden()
                hudV.stopAnimating()
            }

        } else {
//            if mp4P.timeControlStatus != .playing {//没在播放时才出现缓冲
            if openOrHudVBlock != nil {
                openOrHudVBlock?(true)
            } else {
                hudV.animateShow()
                hudV.startAnimating()

                autoControlVHide(0)
            }
//            }
        }
    }

    func rePlayDo() {
        mp4Item.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(1000))) { _ in
            self.playBtnDo()
        }
    }

    @objc func bigDo() { // 全屏
        if #available(iOS 16, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: isLandscape ? .portrait : .landscapeRight))
            }
        } else {
            UIDevice.current.setValue(isLandscape ? UIInterfaceOrientation.portrait.rawValue : UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }

    @objc func playBtnDo() {
        growPlayer()

        if mp4P.timeControlStatus == .paused {
            mp4P.play()

            autoControlVHide(0)
        } else {
            mp4P.pause()
        }
    }

    func seekMp4By(_ ss: CGFloat) {
        if ss > canSeekScale {
            return
        }

        mp4Item.seek(to: CMTime(seconds: Double(ss) * totalTime, preferredTimescale: CMTimeScale(1000))) { _ in
            self.autoControlVHide(0)
        }
    }

    @objc private func panGuestDo(_ panG: UIPanGestureRecognizer) { // 拖动手势
        let location = panG.location(in: self)
        let velocityPoint = panG.velocity(in: self)
        let x = abs(velocityPoint.x)
        let y = abs(velocityPoint.y)

        switch panG.state {
            case .changed:
                if x / y < 0.5 { // 垂直
                    if isPanGShu == nil {
                        isPanGShu = true
                    }
                    if !isPanGShu! {
                        return
                    }
                    if location.x > frame.width * 0.7 { // 右边
                        volumeSliderSS -= CGFloat(velocityPoint.y / 20000)
                        musicPlayer.setValue(volumeSliderSS, forKey: "Volume")

//                    lightLeftV.frame = CGRect.init(x: 0, y: 0, width: volumeSliderSS*200, height: 30)
//                    MCGCDTimer.shared.cancleTimer(WithTimerName: "lightV")
//                    lightV.animateShow()
//                    lightImgV.image = "audio".assetImg
//                    print("音量", volumeSliderSS)
                    } else if location.x < frame.width * 0.3 {
                        UIScreen.main.brightness -= velocityPoint.y / 20000
                        lightLeftV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.brightness * 200, height: 30)
                        MCGCDTimer.shared.cancleTimer(WithTimerName: "lightV")
                        lightV.animateShow()
                        lightImgV.image = "lightV".assetImg
                        print(UIScreen.main.brightness)
                    }
                } else if x / y > 5 { // 水平
                    if isPanGShu == nil {
                        isPanGShu = false
                    }
                    if isPanGShu! {
                        return
                    }
                    let ss = velocityPoint.x / 50000
                    playSacal += ss
                    playSacal = playSacal < 0 ? 0 : playSacal
                    playSacal = playSacal > canSeekScale ? canSeekScale : playSacal

                    mp4P.pause()
                    openOrControlVBlock?(true)
                    controlVAppear()
                    playBtn.alpha = 0
                    seekV.alpha = 1
                    seekV.image = "\(ss > 0 ? "mp4Go" : "mp4Back")".assetImg
                    let tt = (totalTime * Double(playSacal)).zeroStr
                    seekL.text = "\(tt)\" / \(totalTime.zeroStr)\""
                }

            case .ended:
                MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "lightV", timeInterval: 0.5, queue: .main, repeats: false, atOnce: false) {
                    self.lightV.animateHidden()
                }

                if !(isPanGShu ?? true) {
                    seekMp4By(playSacal)
                }
                mp4P.play()
                isPanGShu = nil

            default:
                return
        }
    }

    @objc private func twoTapDo() { // 双击操作
        playBtnDo()
    }

    @objc private func oneTapDo() { // 单击操作
        if mp4P == nil {
            return
        }

        seekV.alpha = 0
        playBtn.alpha = 1
        if controlV.alpha == 1 {
            controlV.animateHidden()
            self.isHandDo = false // 手动隐藏控制视图后设置手动为false

            self.openOrControlVBlock?(false)
        } else {
            controlVAppear()
            autoControlVHide(2.6)

            self.openOrControlVBlock?(true)
        }
    }

    private func controlVAppear() {
        controlV.animateShow()
        v2.alpha = 1
    }

    private func autoControlVHide(_ after: Double) {
        if controlV.alpha == 0 {
            return
        }

        isHandDo = true
        MCGCDTimer.shared.cancleTimer(WithTimerName: "controlVHide")
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "controlVHide", timeInterval: after, queue: .main, repeats: false, atOnce: false) {
            if self.mp4P.timeControlStatus != .paused {
                self.controlV.animateHidden()
                self.isHandDo = false

                self.openOrControlVBlock?(false)
            }
        }
    }

    let gcd = MCGCDTimer()
    let videoV = UIView()

    let controlV = UIView()
    let playBtn = UIButton()
    let hudV = UIActivityIndicatorView()
    let seekV = UIImageView()
    let seekL = UILabel()

    let v2 = UIView() // 底部进度
    let curTimeL = UILabel()
    let allTimeL = UILabel()
    let bigBtn = UIButton()
    let progressV = UIView()
    let loadProgressV = UIImageView()
    let playProgressV = UIImageView()

    let lightV = UIView()
    let lightLeftV = UIImageView()
    let lightImgV = UIImageView()

    var mp4Layer: AVPlayerLayer!
    var mp4P: AVPlayer!
    var mp4Item: AVPlayerItem!
    var totalTime: Double = 11
    var isHandDo = false
    var videoImg: UIImage!
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var volumeSliderSS: CGFloat = 0.5 // 音量调节
    var playSacal: CGFloat = 0 // 播放进度
    var isPanGShu: Bool!

    var openOrControlVBlock: ((_ isOpen: Bool) -> Void)?
    var openOrHudVBlock: ((_ isOpen: Bool) -> Void)?
    var isOverRestart = false
    var overDoBlock: (() -> Void)?
    var sec30DoBlock: (() -> Void)?

    /// 自定义所需功能属性
    var canSeekScale: CGFloat = 0 // 可拖动的进度控制\
}

extension UILabel {
    func offenLike(_ font: UIFont, _ align: NSTextAlignment, _ color: UIColor) {
        self.font = font
        self.textColor = color
        self.textAlignment = align
    }
}

class mp4LoadV: UIView {
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        for idx in 0 ..< 4 {
            let imgv = UIImageView(image: "videoLoad".assetImg)
            addSubview(imgv)
            imgv.frame = CGRect(x: idx * (8 + 20), y: 0, width: 8, height: 20)
            imgv.tag = idx + 1
        }

        let de = 0.7
        for idx in 0 ..< 4 {
            tagImgV(idx + 1)!.alpha = 0.25
            UIView.animate(withDuration: de, delay: de * Double(idx) / 2, options: [.autoreverse, .repeat], animations: {
                self.tagImgV(idx + 1)!.alpha = 1
            })
        }

        alpha = 0
        leftRot()
    }

    func startAct() {
        animateShow()
    }

    func finishAct() {
        animateHidden()
    }
}

extension UIView {
    func decotate(_ textC: UIColor! = nil, _ cornerR: CGFloat! = 5, _ borderC: UIColor! = nil, _ borderW: CGFloat! = nil, _ isMask: Bool = true) { // 圆角
        if textC != nil {
            if self.isKind(of: UIButton.self) {
                (self as! UIButton).setTitleColor(textC, for: .normal)
            }
            if self.isKind(of: UILabel.self) {
                (self as! UILabel).textColor = textC
            }
        }
        if cornerR != nil {
            layer.cornerRadius = cornerR
        }
        if borderC != nil {
            self.layer.borderColor = borderC!.cgColor
        }
        if borderW != nil {
            self.layer.borderWidth = borderW!
        }

        if isMask {
            self.layer.masksToBounds = true
        }
    }

    func leftRot() {
        self.transform = CGAffineTransform(rotationAngle: leftCornerH)
    }

    func tagImgV(_ tag: Int) -> UIImageView! {
        return self.viewWithTag(tag) as? UIImageView
    }

    func animateShow(_ time: Double! = 0.24) {
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }

    func animateHidden(_ time: Double! = 0.24) {
        UIView.animate(withDuration: time) {
            self.alpha = 0
        }
    }
}

extension String {
    var assetImg: UIImage {
        if let t = UIImage(named: self) {
            return t
        } else {
            print(self, "没有本地图片")
            return UIImage()
        }
    }
}

extension Double {
    var timeStr: String {
        let miniter = Int(self / 60)
        let second = Int(self.truncatingRemainder(dividingBy: 60))
        return "\(miniter < 10 ? "0" : "")\(miniter):\(second < 10 ? "0" : "")\(second)"
    }

    var zeroStr: String {
        return String(format: "%.f", self)
    }
}

var _isLandscape = false
var landBlock: (() -> Void)?
var isLandscape: Bool {
    get {
        return _isLandscape
    }
    set(nv) {
        if _isLandscape == nv {
            return
        }

        let x = UIScreen.main.bounds.size.width
        let y = UIScreen.main.bounds.size.height

        if nv {
            winW = max(x, y)
            winH = min(x, y)
        } else {
            winW = min(x, y)
            winH = max(x, y)
        }
        winBounds = CGRect(x: 0, y: 0, width: winW, height: winH)

        _isLandscape = nv
        landBlock?()
    }
}

let wb4 = "#B4B4B4".hexColor
let w366Color = "#666666".hexColor // 未选中色
let w433Color = "#333333".hexColor
let wbk5 = UIColor.black.withAlphaComponent(0.5)
let wht = UIColor.white
let wd2 = "#D2D2D2".hexColor // 按钮可用色2
let fm13 = UIFont.systemFont(ofSize: 13)
let fb12 = UIFont.boldSystemFont(ofSize: 12)
let leftCornerH = -CGFloat.pi * (9 / 180)

var winBounds = UIScreen.main.bounds
var winSize = UIScreen.main.bounds.size
var winW = UIScreen.main.bounds.size.width
var winH = UIScreen.main.bounds.size.height
var lowSafeH: CGFloat {
    34
}
