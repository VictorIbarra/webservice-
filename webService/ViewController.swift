//
//  ViewController.swift
//  webService
//
//  Created by victor sotelo on 1/15/18.
//  Copyright © 2018 victor sotelo. All rights reserved.
//


//eror signal e rbt la mayoria las conexiones las tienes desconectados pero esta esperando el codigo cuando borras outlet y action

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
   
    
    @IBOutlet weak var textField: UITextField!
    
    //no le damos valor porque queremos que sea un optional
    
    var palabra:String?
    
    /*URL:
     
     https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=sega
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
 
    @IBAction func buscar(_ sender: Any) {
        
        
        // recuperamos textfield que es la que usa el usuario y se la ponemos al string de la api
        
        
        palabra = textField.text!
        
        
        //se la asignamos a la constante url completo porque es nuestra api le pasamos la palabra que le vamos a pasar
        
        let urlCompleto = "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=\(palabra!.replacingOccurrences(of: " ", with: "%20"))"
        
        
        //vamos a crear un objeto url para meterlo en una peticion por la clase de url y ya tenemos nuestro ojeto url
        
        let objetoUrl = URL(string:urlCompleto)
        
        
        // constante tarea hacemos session y deve de hacer trabajo con una url en este caso el objeto url y ejecutamos por mdeio de resum
        
        
        //closures se va  a activar   (datos,respuesta,error) es una funcion sin nombre se abre corchetes pones los parametros  reservada in  donde ponemos todo lo que haga la funcionm es este caso closure
        
        let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos, respuesta, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                // abrimos y cerrmos bloque de do try catch en caso de que no se pueda se usa el catch 
                
                
                //constante json =  a lo que intentemos realizar 
//                despues la imprimimos y mostramos en consola mandamos a llamar la clase de jsonserialization convertimos json a objetos de la clase foundation o al contrario para que nos envie el servidor agarrar lo que queremos   muestra reglas deve de ser a un arreglo o un diccionario  despuesjsonobject te devuelve el ovjeto del json para que lo puedas utilizar dentro de tu clase parametros data recibimos en la funcion y las opciones despues mutablecontainer son los dicionarios o arreglo son mutables por si los quieres modigicar despues as anyobject para poder manipular el json
                
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
//                    print(json)
                    
                    //esta constante es un sub json parte pequeña del json llamada query agarrar la parte de la constante json solo el valor de la llave query porque asi se llama la llave que queremos lo transformamos de el mismo valor llave valor
                    
        let querySubJson = json["query"] as! [String:Any]
                    
//                    print(querySubJson)
                    
        let pagesSubJson = querySubJson["pages"] as! [String:Any]

//                    print(pagesSubJson)
                    
                    
                    //para sacar una llave o tercer llave o cuarta option del teclado pulsamos en keys   y nos muestra los contenidos
                    
         let pageId = pagesSubJson.keys
                    
         let primerLlave = pageId.first!
                    
        let idSubJson = pagesSubJson[primerLlave] as! [String:Any]

//                      print(idSubJson)
                    
        let extractStringHtml = idSubJson["extract"] as! String
                    
                    
                    print(extractStringHtml)
                    
                    
                    //le decimos que carge el view de html
                    
                    DispatchQueue.main.sync(execute:{
                    
                        self.webView.loadHTMLString(extractStringHtml, baseURL: nil)
                    
                    })
                    
                    
                }catch {
                    
                    print("El Procesamiento del JSON tuvo un error")
                    
                }
                
            }
            
        }
        
        tarea.resume()
    
        
    }
    
   
    
}


