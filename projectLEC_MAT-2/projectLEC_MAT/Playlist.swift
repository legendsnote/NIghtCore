import UIKit
import CoreData

class Playlist: UIViewController {

    @IBOutlet weak var playlistTableView: UITableView!
    
    @IBOutlet weak var playlistText: UILabel!
    
    var playlistSongs: [User] = []
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view
        playlistTableView.dataSource = self
        playlistTableView.delegate = self

        // Fetch data from Core Data
        fetchData()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        playlistText.textColor = .white
    }

    func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            // Fetch songs from Core Data
            self.playlistSongs = try context.fetch(User.fetchRequest())

            // Delete the first row if there are songs and it hasn't been deleted yet
            if !playlistSongs.isEmpty {
                let indexPath = IndexPath(row: 0, section: 0)
                playlistSongs.remove(at: 0)
                playlistTableView.deleteRows(at: [indexPath], with: .fade)

                // Reload the table view to display the fetched data after deletion
                DispatchQueue.main.async {
                    self.playlistTableView.reloadData()
                }
            } else {
                // Reload the table view if there are no songs to display
                DispatchQueue.main.async {
                    self.playlistTableView.reloadData()
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

// Adopt UITableViewDataSource and UITableViewDelegate protocols
extension Playlist: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell

        let song = playlistSongs[indexPath.row]
        cell.playlistSongName.text = song.savedSongName
        cell.playlistArtist.text = song.savedSongArtist

        cell.loadImage(named: song.savedSongImage ?? "defaultPlaylistImage")

        // Set the delete handler closure
        cell.deleteHandler = { [weak self] in
            // Ensure the index path is still valid
            if let indexPath = tableView.indexPath(for: cell) {
                self?.deleteCell(at: indexPath)
            }
        }

        return cell
    }

    func deleteCell(at indexPath: IndexPath) {
        // Check if the indexPath is within the bounds of your data source
        guard indexPath.row < playlistSongs.count else {
            return
        }

        // Get the song object to be deleted
        let songToDelete = playlistSongs[indexPath.row]

        // Remove the item from your data source (playlistSongs)
        playlistSongs.remove(at: indexPath.row)

        // Update the table view with the deletion
        playlistTableView.deleteRows(at: [indexPath], with: .fade)

        // Get the managedObjectContext from the AppDelegate
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }

        // Delete the corresponding object from Core Data
        context.delete(songToDelete)

        // Save the changes to Core Data
        do {
            try context.save()
        } catch {
            print("Error saving context after deletion: \(error)")
        }
    }

    // Optional: Implement didSelectRowAt to handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection, if needed
    }
}

