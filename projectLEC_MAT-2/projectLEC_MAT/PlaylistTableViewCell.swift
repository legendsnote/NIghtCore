import UIKit
import AVFoundation

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistSongName: UILabel!
    @IBOutlet weak var playlistArtist: UILabel!
    @IBOutlet weak var playButton: UIButton!

    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var deleteHandler: (() -> Void)?

    @IBAction func playButton(_ sender: Any) {
        isPlaying ? stopAudio() : playAudio()
    }

    @IBAction func deleteCell(_ sender: Any) {
        deleteHandler?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set the text color of labels to white
        playlistSongName.textColor = .white
        playlistArtist.textColor = .white

        // Set the background color of playlistImage to white
        playlistImage.backgroundColor = .white

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func loadImage(named imageName: String) {
        // Use UIImage(named:) to load the image from the asset catalog
        playlistImage.image = UIImage(named: imageName)
    }

    func playAudio() {
        guard let songAudioFileName = playlistSongName.text, !songAudioFileName.isEmpty else {
            print("Song audio file name is missing.")
            return
        }

        print("Attempting to play audio for file: \(songAudioFileName)")

        if let audioUrl = Bundle.main.url(forResource: songAudioFileName, withExtension: "mp3", subdirectory: "Audio") {
            print("Audio file found at URL: \(audioUrl)")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.play()
                isPlaying = true
                playButton.setTitle("stop", for: .normal)
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found.")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
        playButton.setTitle("play", for: .normal)
    }
}
