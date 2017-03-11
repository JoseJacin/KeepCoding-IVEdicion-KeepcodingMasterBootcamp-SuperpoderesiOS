//: Playground - En el que se va a descargar el avatar de un usuario de GitHub con URLSession usando RxSwift
import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa

import SpriteKit

// Con esto configuramos el Playground para que se esté ejecutando indefinidamente
PlaygroundPage.current.needsIndefiniteExecution = true

// Con esto se deshabilitan las caches del sistema para que URLSession funcione en un Playground
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

//MARK: - Aliases
typealias JSONDictionary = [String: Any]

//MARK: - Enums
enum JSONError: Error {
    case invalidData
    case notFound(String)
    case invalidValue(Any, String)
}

enum HTTPError: Error {
    case basStatus(Int)
}

// Se extiende la clase URLSession para añadir la funcionalidad de los Observables
extension URLSession {
    // Función que va a recibir una request (HTTP) y va a retornar un Observable de tipo Data
    func data(request: URLRequest) -> Observable<Data> {
        return Observable.create { observer in
            // Se monta la tarea
            let task = self.dataTask(with: request) { data, response, error in
                // Se examina el resultado para comprobar si ha habido error
                if let error = error {
                    // Se llama a onErorr del observer
                    observer.onError(error)
                // se comprueba si hay datos. De esta forma nos quitamos el opcional
                // Se comprueba el contenido de response
                } else {
                    // Se comprueba si response es del tipo HTTPURLResponse
                    guard let httpResponse = response as? HTTPURLResponse else {
                        // Provocamos que la aplicación falle en caso de que response no sea del tipo HTTPURLResponse
                        fatalError("Protocolo no soportado")
                    }
                    
                    // Se comprueba que el statusCode de response sea entre 200 y 299
                    if 200 ..< 300 ~= httpResponse.statusCode {
                        // El statusCode tiene un código de OK
                        // Se llama a onNext del observer usando la siguiente validación
                        // Si data no es nulo, se retorna data
                        // Si data es nulo, se retorna un Data
                        observer.onNext(data ?? Data())
                        // Se llama a onCompleted del observer
                        observer.onCompleted()
                        
                    } else {
                        // El statusCode tiene un código de error, por lo que se llama a onError del observer pasándole el statusCode de httpResponse
                        observer.onError(HTTPError.basStatus(httpResponse.statusCode))
                    }
                    
                }
            }
            
            task.resume()
            
            // Provoca que la tarea ejecutada en el observer se cancele si se cancela la 
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// ---------------------------------
// Se crea un URLSession
let google = URLSession.shared.data(request: URLRequest(url: URL(string: "https://www.google.es")!))
// Se suscribe al observable. En este momento es cuando se ejecuta la petición HTTP
let disposable = google.subscribe(
    onNext: { data in
        let value = String(data: data, encoding: .ascii)
        print(data)
})

// ---------------------------------
// Obtenemos la representación textual de google
let googleAsText = google.map { data in
    return String(data: data, encoding: .ascii)!
}

let _ = googleAsText.subscribe(onNext: { print($0) })

// ---------------------------------
// Se otiene el profile de un usuario de GitHub y después se descarga la imagen

// Se crea una sesión que sea compartida


// Se crea una sesión que corra en otro hilo
let session = URLSession(configuration: .default)

// Función que recupera la información (profile) de un usuario de GitHub
func fetchProfile(for username: String) -> Observable<JSONDictionary> {
    // Se monta la URL
    let apiURL = URL(string: "https://api.github.com/users/\(username)")!
    
    // Se crea una request
    let request = URLRequest(url: apiURL)
    
    // Se transforman los datos en un JSONDictionary
    return session.data(request: request)
        // Se aplica una transformación a JSONDictionary sobre cada uno de los datos de data
        .map { data -> JSONDictionary in
            // Si no hay error, se parsea el JSON
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []), // Se obtiene el JSON en bruto
              let profile = json as? JSONDictionary else { // Se comprueba si el JSON obtenido es de tipo JSONDictionary definido
                // Si hay error porque lo obtenido no es de tipo JSONDictionary o los datos son erróneos se llama al callback failure con la descripción del error
                throw JSONError.invalidData
            }
        // Se retorna el profile
        return profile
    }
}

// Función que descarga una imagen y la convierte en UIImage
func fetchImage(with url: URL) -> Observable<UIImage> {
    return session.data(request: URLRequest(url: url))
        // Se aplica una transformación a UIImage sobre cada uno de los datos de data
        .map { data -> UIImage in
            return UIImage(data: data) ?? UIImage()
    }
}

// Función que descarga la imagen del perfil pasado en el parámetro username
func fetchAvatarImage(for username: String) -> Observable<UIImage> {
    return fetchProfile(for: username)
        .flatMap { profile -> Observable<UIImage> in
            // Se comprueba si la clave avatar_url se encuentra en el JSONDictionary
            guard let value = profile["avatar_url"] else {
                throw JSONError.notFound("avatar_url")
            }
            // Se comprueba si el contenido de avatar_url es un String
            guard let stringValue = value as? String,
                // Se comprueba si el valor es una URL válida
                let url = URL(string: stringValue) else {
                    throw (JSONError.invalidValue(value, "avatar_url"))
            }
            
            // Se descarga la imagen que corresponde al URL
            return fetchImage(with: url)
    }
}

var imageView = UIImageView()

fetchAvatarImage(for: "josejacin")
    .subscribe(onNext: { imageView.image = $0 })

// Se indica que todos los valores obtenidos de fetchAvatarImage estén asociados (likados) a imageView.rx.image
// Esta parte se está usando con RxCocoa
fetchAvatarImage(for: "josejacin").bindTo(imageView.rx.image)

fetchImage(with: URL(string: "http://img.desmotivaciones.es/201404/QUITHOR.jpg")!)
    // Lo siguiente asegura que esta ejecución se va a realizar en la cola principal
    .observeOn(MainScheduler.instance)
    .bindTo(imageView.rx.image)

// -----------------------------
// Recurso que devuelve un objeto de tipo genérico llamado T
struct Resource<T> {
    let url: URL
    let decode: (Data) -> T
}

// Función que descarga una imagen y la convierte en UIImage
// Es otra implementación de fetchImage para hacerla genérica
func fetch<T>(resource: Resource<T>) -> Observable<T> {
    return session.data(request: URLRequest(url: resource.url))
        // Se aplica una transformación a UIImage sobre cada uno de los datos de data
        .map(resource.decode)
}

// Se puede llamar para obtener una UIImage
let imageResource = Resource(url: URL(string: "http://img.desmotivaciones.es/201404/QUITHOR.jpg")!) {
    UIImage(data: $0)
}

// Llamada
let _ = fetch(resource: imageResource).subscribe(
    onNext: { imageView.image = $0 })


// Se puede llamar para obtener un String
let googleResource = Resource(url: URL(string: "https://google.es")!) {
    String(data: $0, encoding: .ascii)
}

// Lamada
let _ = fetch(resource: googleResource).subscribe(onNext: {
    print($0 ?? "")
})

// -----------------------
// ACLARACIONES
// Aclaraciones sobre map o flatMap
let observable = fetchProfile(for: "josejacin") //Observeble<UIImage>
    .flatMap { profile in
        return fetchImage(with: URL(string: "")!)
}

let observable2 = fetchProfile(for: "josejacin") //Observeble<Observable<UIImage>>
    .map { profile in
        return fetchImage(with: URL(string: "")!)
}

let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
let maybeImage = cell.imageView?.image
// Esto es la representación gráfica del operador ?. Es lo mismo que lo anterior.
let maybeImage2 = cell.imageView.flatMap { $0.image } //Optional<UIImage>
let maybeImage3 = cell.imageView.map { $0.image } //Optional<Optional<UIImage>>








