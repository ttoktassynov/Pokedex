import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let sprites: SpritesData
    let species: PokemonSpecies
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct SpritesData: Codable {
    let back_default: String!
    let back_female: String!
    let back_shiny: String!
    let back_shiny_female:String!
    let front_default:String!
    let front_female:String!
    let front_shiny:String!
    let front_shiny_female:String!
}
struct PokemonSpecies: Codable {
    let name: String
    let url: String
}

struct SpeciesResult: Codable {
    let flavor_text_entries: [PokemonDesc]
}

struct PokemonDesc: Codable {
    let flavor_text: String!
    let language: PokemonLangEntry
    let version: PokemonVersEntry
}

struct PokemonLangEntry: Codable {
    let name: String
    let url: String
}
struct PokemonVersEntry: Codable {
    let name: String
    let url: String
}
