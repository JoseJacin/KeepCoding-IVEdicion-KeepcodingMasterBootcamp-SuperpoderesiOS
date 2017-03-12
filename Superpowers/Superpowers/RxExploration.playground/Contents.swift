//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

import RxSwift

// Con esto configuramos el Playground para que se esté ejecutando indefinidamente
PlaygroundPage.current.needsIndefiniteExecution = true

// Create define el código que se va a ejecutar cada vez que alguien se subcribe a los eventos de ese observable
// Lo que se recibe en la clausura es el observador
let hello = Observable<String>.create ({ observer in
    // on define el evento que se quiere enviar.
    // En este caso se envía el evento next
    observer.on(.next("Hello wolrd!"))
    // En este caso se envía el evento completed (secuencia de eventos finalizada)
    observer.on(.completed)
    return Disposables.create()
})

// Esto es lo mismo que lo anterior debido a la inferencia de tipos, es decir, se pueden quitar los paréntesis y el tipo del retorno
let hello2 = Observable<String>.create { observer -> Disposable in
    observer.onNext("Hello wolrd")
    observer.onCompleted()
    return Disposables.create()
}

let subscriber = hello.subscribe(onNext: { value in
    print(value)
})

let subscriber2 = hello.subscribe(onNext: { _ in })

// empty crea un observable que genera un evento completed
let empty = Observable<Void>.empty()

// esto es lo mismo que lo anterior, es decir, un método que genera un evento completed y a la vez se subscribe a dicho evento
let _ = Observable<Void>.empty().subscribe(
    onCompleted: {
        print("completed")
    })

// Otra forma de hacer el Hello Wolrd
let _ = Observable.just("Hello Wolrd!").subscribe(
    onNext: { value in
        print(value)
    })

// Otra forma de hacer el Hello Wolrd
let _ = Observable.just("Hello Wolrd!").subscribe(
    onNext: { value in
        print(value)
    }, onCompleted: {
        print("completed!!!")
    })

// Contructor que retorna un error
let error = Observable<Void>.error(NSError(domain: "test", code: 42, userInfo: nil))

let _ = error.subscribe(
    onNext: { _ in
        print("not going to happen")
    }, onError: { error in
        print(error)
    }, onCompleted: {
        print("not going to happen")
    })

// ------------------------------
// Subject: Observable que es un observer a la vez
let subject = PublishSubject<String>()

let _ = subject.subscribe { event in
    print(event)
}

subject.onNext("pepito")
subject.onNext("fulanito")
subject.onCompleted()
// Esta última no se pasa porque ya se ha completado
subject.onNext("juanito")

// Sustituye a KVO en RxSwift.
// Además se aplica la conversión para que en caso de que se encuentre en espacio " " se añada como un nuevo elemento en un Array de String
let query = Variable("")
let _ = query.asObservable()
    .map {
        $0.components(separatedBy: " ")
    }
    .subscribe { event in
    print(event)
}

query.value = "pepito"
query.value = "pepito fulanito"
query.value = "pepito fulanito hola"