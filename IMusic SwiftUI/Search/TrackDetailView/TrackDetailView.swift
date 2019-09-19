//
//  TrackDetailView.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 15.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
protocol TrackMovingDelegate {
    func moveBackForPreviusTrack() -> SearchViewModel.Cell?
    func moveForwardForNextTrack() -> SearchViewModel.Cell?
    
}
class TrackDetailView: UIView {
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniPauseButton: UIButton!
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSLider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    var delegate: TrackMovingDelegate?
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.layer.cornerRadius = 5
        setupGesture()
        
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        observePlayerCurrentTime()
        playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else {return}
        miniTrackImageView.sd_setImage(with: url)
        trackImageView.sd_setImage(with: url)
        monitorStartTime()
        
        
    }
    
    private func setupGesture(){
        
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTappedMaximazed)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMaximazed)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDissmisPan)))
    }
    @objc func handleTappedMaximazed(){
        self.tabBarDelegate?.muximizeTrackDetailController(viewModel: nil)
    }
    
    @objc func handlePanMaximazed(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            print("Began")
            self.transform = .identity
        case .changed:
            handlePanChanged(gesture: gesture)
            print("changed")
            
        case .ended:
            handlePanEnding(gesture: gesture)
            print("ended")
            
        @unknown default:
            Log("@unknown default")
            
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnding(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            print(translation.y < -200)
            print(velocity.y < -500)
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.muximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizedStackView.alpha = 0
                self.tabBarDelegate?.minimizeTrackDetailController()
            }
        })
    }
    
    @objc private func handleDissmisPan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.maximizedStackView.transform = .identity
                if translation.y > 70 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                } else {
                    self.miniTrackView.alpha = 0
                    self.maximizedStackView.alpha = 1
                    self.tabBarDelegate?.muximizeTrackDetailController(viewModel: nil)
                    
                }})
            //self.transform = .identity
            
        @unknown default:
            Log("@unknown default")
        }
    }
    private func playTrack(previewUrl: String?){
        guard let url = URL(string: previewUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func changeScaleTrackImageView(scale: CGFloat){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            if scale == 1 {
                self.trackImageView.transform = .identity
            } else {
                self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }, completion: nil)
    }
    
    private func monitorStartTime(){
        self.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.changeScaleTrackImageView(scale: 1)
        }
        
    }
    
    private func observePlayerCurrentTime() {
        let interval =  CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTrack = self?.player.currentItem?.duration
            
            let currentDurationTime = ((durationTrack ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationTimeLabel.text = currentDurationTime
            self?.updateCurrentSlider()
        }
    }
    private func updateCurrentSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentItem?.currentTime() ?? CMTimeMake(value: 1, timescale: 1))
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSLider.value = Float(percentage)
    }
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        
        self.tabBarDelegate?.minimizeTrackDetailController()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        let precentage = currentTimeSLider.value
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = durationInSeconds * Float64(precentage)
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleValumeValue(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func prewiousTrackTapped(_ sender: Any) {
        let cellViewModel = delegate?.moveBackForPreviusTrack()
        guard let cell = cellViewModel else {return}
        self.set(viewModel: cell)
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        if player.timeControlStatus != .paused {
            player.pause()
            miniPauseButton.setImage( UIImage(systemName: "play.fill"), for: .normal)
            playPauseButton.setImage( UIImage(systemName: "play.fill"), for: .normal)
            changeScaleTrackImageView(scale: 0.8)
            
        } else {
            player.play()
            miniPauseButton.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            playPauseButton.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            
            self.changeScaleTrackImageView(scale: 1)
            
        }
    }
    
    @IBAction func nextTrackTapped(_ sender: UIButton) {
        let cellViewModel = delegate?.moveForwardForNextTrack()
        guard let cell = cellViewModel else {return}
        self.set(viewModel: cell)
    }
    
}
