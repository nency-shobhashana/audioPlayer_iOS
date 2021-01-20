//
//  ViewController.swift
//  Audio Player
//
//  Created by Mohammad Kiani on 2021-01-17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var voulumSlider: UISlider!
    @IBOutlet weak var playBtn: UIBarButtonItem!

    // song list
    let songList = ["bach", "boing", "explosion", "hit", "knife", "shoot", "swish", "wah", "warble"]
    
    var isPlaying = false
    
    //we need to create an insatance of AVAudioPlayer
    var player = AVAudioPlayer()
    
    // we need to acess the audio path
    var path =  Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer = Timer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectedSong()
        
        // tap gesture for volumn
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
                self.voulumSlider.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if event?.subtype == UIEvent.EventSubtype.motionShake {
                phoneShake()
            }
        }
    
    // on phone shake select new song and add in path
    func phoneShake(){
        self.path = Bundle.main.path(forResource: self.songList.randomElement(), ofType: "mp3")
        self.selectedSong()
    }
    
    // play selected song
    func selectedSong(){
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            scrubber.maximumValue = Float(player.duration)
            if isPlaying {
                player.play()
            }
        } catch {
            print(error)
        }
    }
    
    // detact tap on slider and slide it to new value
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
            //  print("A")

            let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)

            let positionOfSlider: CGPoint = voulumSlider.frame.origin
            let widthOfSlider: CGFloat = voulumSlider.frame.size.width
            let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(voulumSlider.maximumValue) / widthOfSlider)

        voulumSlider.setValue(Float(newValue), animated: true)
        }
    
    // play and pause button
    @IBAction func playAudio(_ sender: UIBarButtonItem) {
        if isPlaying {
            playBtn.image = UIImage(systemName: "play.fill")
            player.pause()
            isPlaying = false
            timer.invalidate()
        } else {
            playBtn.image = UIImage(systemName: "pause.fill")
            player.play()
            isPlaying = true
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats:true)
        }
    }
    
    // update scrubber based on player current time
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
        if scrubber.value == scrubber.minimumValue {
            isPlaying = false
            playBtn.image = UIImage(systemName: "play.fill")
        }
    }
    
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrubber.value)
        if isPlaying {
            player.play()
        }
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        player.volume = voulumSlider.value
    }
    

}

