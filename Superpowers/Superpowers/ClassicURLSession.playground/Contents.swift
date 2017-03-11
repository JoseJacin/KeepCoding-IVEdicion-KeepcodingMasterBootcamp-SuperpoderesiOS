//: Playground - En el que se va a descargar el avatar de un usuario de GitHub con URLSession del modo tradicional (con callbacks)
import UIKit
import PlaygroundSupport

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

//MARK: - Funcitons
// Función que recupera la información de un usuario de GitHub
// Es este caso:
// Si todo va bien: JSONDictionary tiene un JSON y Error es nil
// Si todo va mal: JSONDictionary es nil y Error tiene un error
// Pero puede darse el caso de que tanto JSONDictionary como Error sean nil, y eso no se puede tolerar
//func fetchProfile(for username: String, completion: (JSONDictionary?, Error?) -> Void) {
//    
//}

// Función que recupera la información (profile) de un usuario de GitHub
func fetchProfile(for username: String, success: @escaping (JSONDictionary) -> Void, failure: @escaping (Error) -> Void) {
    // Se monta la URL
    let apiURL = URL(string: "https://api.github.com/users/\(username)")!
    
    // Se monta la tarea
    let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
        // Se examina el resultado para comprobar si ha habido error
        if let error = error {
            // Se llama al callback de fallo failure con el error
            failure(error)
        // se comprueba si hay datos. De esta forma nos quitamos el opcional
        } else if let data = data {
            // En este punto lo recomendable es comprobar el valor de response y siempre y cuando no tenga un valor > 200, no hay error
            // Si no hay error, se parsea el JSON
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []), // Se obtiene el JSON en bruto
                  let profile = json as? JSONDictionary else { // Se comprueba si el JSON obtenido es de tipo JSONDictionary definido
                    // Si hay error porque lo obtenido no es de tipo JSONDictionary o los datos son erróneos se llama al callback failure con la descripción del error
                    failure(JSONError.invalidData)
                    return
            }
            
            // Lo obtenido es un JSONDictionary y los datos son correctos, son lo que se llama al callback success y se le pasa el json parseado
            success(profile)
        }
        
        
        // Se llama a una de las callbacks que nos han pasado
    }
    
    // Se ejecuta la tarea
    task.resume()
}

// Función que descarga una imagen y la convierte en UIImage
func fetchImage(with url: URL, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
    // Se monta la tarea
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        // Se examina el resultado para comprobar si ha habido error
        if let error = error {
            // Se llama al callback de fallo failure con el error
            failure(error)
            // se comprueba si hay datos. De esta forma nos quitamos el opcional
        } else if let data = data {
            // En este punto lo recomendable es comprobar el valor de _ (response) y siempre y cuando no tenga un valor > 200, no hay error
            // Se comprueba si se ha podido decodificar la imagen
            guard let image = UIImage(data: data) else {
                // La imagen no se ha podido decodificar, por lo que se llama al callback de error con un NSError
                failure(NSError(domain: "", code: 42, userInfo: nil))
                return
            }
            
            // La imagen se ha podido decodificar
            success(image)
        }
    }
    
    task.resume()
}

// Función que descarga la imagen del perfil pasado en el parámetro username
func fetchAvatarImage(for username: String, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
    // Se llama a fetchProfile para obtener el JSONDictionary con los datos del profile pasado en username
    fetchProfile(for: username,
                 // En caso de éxito, se recupera la URL del avatar que se saca del JSONDictionary obtenido
                 success: { profile in
                    // Se comprueba si la clave avatar_url se encuentra en el JSONDictionary
                    guard let value = profile["avatar_url"] else {
                        failure(JSONError.notFound("avatar_url"))
                        return
                    }
                    // Se comprueba si el contenido de avatar_url es un String
                    guard let stringValue = value as? String,
                          // Se comprueba si el valor es una URL válida
                          let url = URL(string: stringValue) else {
                            failure(JSONError.invalidValue(value, "avatar_url"))
                            return
                    }
                    
                    // Dado que no ha habido ningún error, se ejecuta fetchImage
                    fetchImage(with: url, success: success, failure: failure)
                 },
                 // En caso de ellor se llama al callback failure pasándole el error obtenido
                 failure: { failure($0) })
}

// Se ejecuta la petición
fetchAvatarImage(for: "josejacin",
                 // Se imprime el perfil en caso de que todo haya ido bien
                 success: { let imageView = UIImageView(image: $0) },
                 // Se imprime el error en caso en que algo haya fallado
                 failure: { print($0) })



