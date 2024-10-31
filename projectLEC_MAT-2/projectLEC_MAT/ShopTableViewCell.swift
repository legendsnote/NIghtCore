import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var addToPlaylistButton: UIButton!

    var addToPlaylistHandler: (() -> Void)?

    func configure(with song: Song) {
        songNameLabel.text = song.songName
        artistLabel.text = song.songArtist

        // Check if the song has a valid image name
        if let imageName = song.songImage, !imageName.isEmpty {
            // Use the UIImage(named:) method to load the image
            if let image = UIImage(named: imageName) {
                songImageView.image = image
            } else {
                // Use a default image if the named image is not found
                songImageView.image = UIImage(named: "defaultImage")
                print("Image named '\(imageName)' not found. Using default image.")
            }
        } else {
            // Use a default image if the song does not specify an image
            songImageView.image = UIImage(named: "defaultImage")
        }

        // Set text colors for readability on the gradient background
        songNameLabel.textColor = .white
        artistLabel.textColor = .white
        addToPlaylistButton.setTitleColor(.white, for: .normal)
    }

    @IBAction func addToPlayList(_ sender: Any) {
        addToPlaylistHandler?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        contentView.layer.insertSublayer(gradientLayer, at: 0)

        // Additional setup, if needed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
