import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var descUrl: String!
    var isCaught: Bool! = false
    var delegate:CatchDelegate?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var spriteImage: UIImageView!
    @IBOutlet var descLabel: UITextView!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        
        if isCaught {
            catchButton.setTitle("Release", for: UIControl.State.normal)
        }
        else {
            catchButton.setTitle("Catch", for: UIControl.State.normal)
        }

        loadPokemon()
        //descLabel.text = descUrl
        //loadPokemonDesc()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    
                    self.navigationItem.title = self.capitalize(text: result.name)
                    //self.nameLabel.text = "Fword"
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.descUrl = result.species.url
                    
                    do {
                        if let image = UIImage(data: try Data(contentsOf: URL(string: result.sprites.front_default!)!)) {
                            self.spriteImage.image = image
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    self.loadPokemonDesc()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    func loadPokemonDesc() {
        URLSession.shared.dataTask(with: URL(string: descUrl)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(SpeciesResult.self, from: data)
                DispatchQueue.main.async {
                    //self.descLabel.text = "fword"
                    for pokemonDesc in result.flavor_text_entries {
                        if pokemonDesc.language.name == "en" {
                            self.descLabel.text = pokemonDesc.flavor_text
                            break
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        //code goes here
        isCaught = !isCaught
        let caughtPokemon = (nameLabel.text?.lowercased())!
        delegate?.onCatchPokemon(name: caughtPokemon)
        if isCaught {
            catchButton.setTitle("Release", for: UIControl.State.normal)
        }
        else {
            catchButton.setTitle("Catch", for: UIControl.State.normal)
        }
    }
    
}
