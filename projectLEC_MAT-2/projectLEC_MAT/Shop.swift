import UIKit
import CoreData

class Shop: UIViewController {

    @IBOutlet weak var shopTableView: UITableView!
    
    @IBOutlet weak var SongListText: UILabel!
    var currentUser: User?

        var songs: [Song] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
                UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
            ]
            
            view.layer.insertSublayer(gradientLayer, at: 0)
            
            // Set up table view
            shopTableView.dataSource = self
            shopTableView.delegate = self
            
            clearData()

            // Fetch data from Core Data
            fetchData()
            
            // Example: Add a new song when the view loads
            addSongToCoreData(songName: "AfterDark", songArtist: "Mr kitty ", songImage: "AfterDark", songAudio: "AfterDark")
            addSongToCoreData(songName: "Cupid", songArtist: "FIFTY FIFTY ", songImage: "Cupid", songAudio: "Cupid")
            addSongToCoreData(songName: "Demons", songArtist: "Imagine Dragon ", songImage: "Demons", songAudio: "Demons")
            addSongToCoreData(songName: "ET", songArtist: "Katty Parry ", songImage: "ET", songAudio: "ET")
            addSongToCoreData(songName: "ImGood", songArtist: "Bebe Rexha & David Guetta ", songImage: "ImGood", songAudio: "ImGood")
            addSongToCoreData(songName: "MiddleOfThenNight", songArtist: "Elley Duhe", songImage: "MiddleOfTheNight", songAudio: "MiddleOfTheNight")
            addSongToCoreData(songName: "Mockingbird", songArtist: "Eminem ", songImage: "Mockingbird", songAudio: "Mockingbird")
            addSongToCoreData(songName: "Solo", songArtist: "Clean Bandit", songImage: "Solo", songAudio: "Solo")
            addSongToCoreData(songName: "SummertimeSadness", songArtist: "Lana Del Rey", songImage: "SummertimeSadness", songAudio: "SummertimeSadness")
            addSongToCoreData(songName: "SweaterWeather", songArtist: "The Neighbourhood", songImage: "SweaterWeather", songAudio: "SweaterWeather")
          
            
            SongListText.textColor = .white
        }

        // Function to fetch data from Core Data
        func fetchData() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                // Fetch songs from Core Data
                self.songs = try context.fetch(Song.fetchRequest())
                
                // Reload the table view to display the fetched data
                self.shopTableView.reloadData()
            } catch {
                print("Error fetching data: \(error)")
            }
        }

        // Function to add a song to Core Data
        func addSongToCoreData(songName: String, songArtist: String, songImage: String, songAudio: String) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Create a new Song object
            let newSong = Song(context: context)
            newSong.songName = songName
            newSong.songArtist = songArtist
            newSong.songImage = songImage
            newSong.songAudio = songAudio
            
            // Save the context to persist the changes
            do {
                try context.save()
                // Update the table view with the new data
                fetchData()
            } catch {
                print("Error saving data: \(error)")
            }
        }
    
    func clearData() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            do {
                // Fetch all songs
                let allSongs = try context.fetch(Song.fetchRequest()) as [Song]

                // Delete each song
                for song in allSongs {
                    context.delete(song)
                }

                // Save the context to persist the changes
                try context.save()
            } catch {
                print("Error clearing data: \(error)")
            }
        }

    // ... (other methods or actions as needed)
}

    // Adopt UITableViewDataSource and UITableViewDelegate protocols
extension Shop: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! ShopTableViewCell

        let song = songs[indexPath.row]
        cell.configure(with: song)
        cell.addToPlaylistHandler = {
            self.addToPlaylist(song: song)
        }

        return cell
    }

    // Function to add a song to the User Core Data entity
    func addToPlaylist(song: Song) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Check if the song is already in the playlist
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "savedSongName == %@", song.songName ?? "")
        
        do {
            let existingSongs = try context.fetch(fetchRequest)
            
            if existingSongs.isEmpty {
                // Song is not in the playlist, proceed to add it
                let newUser = User(context: context)

                newUser.savedSongName = song.songName ?? ""
                newUser.savedSongArtist = song.songArtist ?? ""
                newUser.savedSongAudio = song.songAudio ?? ""
                newUser.savedSongImage = song.songImage ?? ""

                // Save the context to persist the changes
                try context.save()

                // Show success alert
                showAlert(message: "Song successfully added to your playlist")
            } else {
                // Song is already in the playlist, show alert
                showAlert(message: "This song is already in your playlist")
            }
        } catch {
            print("Error checking existing songs: \(error)")
            showAlert(message: "An error occurred while checking existing songs")
        }
    }

    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Playlist", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
    // Optional: Implement didSelectRowAt to handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
