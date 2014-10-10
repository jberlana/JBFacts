Facts
===============

**Facts** es una app muy simple que trabaja con la API [numbersapi](http://numbersapi.com) que devuelve datos curiosos sobre números, fechas o de forma aleatoria.

## Estructura de la app

La app es compatible con todos los dispositivos iOS: iPad y iPhone. Soporta las nuevas pantallas de 4.7" y 5.5".

Consta de dos pantallas:

- **Home**: Muestra al usuario los tres tipos de datos a obtener y un input.
- **Detail**: Una vez el usuario introduce un dato o pulsa en el botón de random se le manda a esta pantalla dónde puede leer el dato devuelto por `numbersapi`.

## Estructura del proyecto

El proyecto contiene los siguientes directorios:

- **API**: Contiene la clase `NumbersAPIClient` encargada de realizar toda la comunicación con el API de numbersAPI. 
- **Model**: Contiene las calses relativas al modelo de datos de la app. La clase `Fact` y sus subclases: `NumberFact`, `DateFact` y `RandomFact`. Más adelante, en patrones utilizados se hablara de la arquitectura de estas clases.
- **View**: Contiene las vistas de la app `FactTypeButton`, `FactInputTextField` y `DateMonthPickerView`.
- **Controller**: Contiene los view controllers, por un lado los *parent view controllers* de los que heredarán el resto de controladores de la app `FactsNavigationController` y `FactsViewController` heredar de estos en lugar de los homólogos `UINavigationController` y `UIViewController` nos va a permitir realizar tareas comunes a toda la app en un único lugar. Por último las clases que manejan las dos pantallas de la app: `HomeViewController` y `FactDetailViewController`.
- **Media**: Directorio que contiene las imágenes del proyecto (haciendo uso de `xcassets`), y dónde en el futuro podremos albergar sonidos, fuentes custom u otros elementos multimedia de los que haga uso la app.

Adicionalmente la app hace uso de 2 *pods* de [cocapods](http://cocoapods.org/) (conocido gestor de dependencias para iOS): `AFNetworking` framework para conexiones de red y `CocoaLumberjack` framework para gestión de logs.

## Patrones utilizados

#### MVC
El modelo–vista–controlador (MVC) es un patrón de arquitectura de software que separa los datos y la lógica de negocio de una aplicación de la interfaz de usuario y el módulo encargado de gestionar los eventos y las comunicaciones.

Toda la estructura de la app está bajo el patrón modelo-vista-controlador. Las clases del *modelo* son las únicas que tienen contacto con el cliente del API y las responsables de validar datos de entrada en función de su tipo para seguir la nomenclatura del API. Las *vistas* serán elementos de interfaz desacoplados y reutilizables por los *controladores* quienes combinaran los datos extraídos del *modelo* para pintar las *vistas* en pantalla.  

#### Singleton
El cliente del API de numbers `NumbersAPIClient`  usa este patrón para garantizar que la clase sólo tenga una instancia y proporcionar un punto de acceso global a ella. De manera que podamos gestionar el numero de llamadas concurrentes, timeouts, errores de red... 

`NumbersAPIClient` hereda de `AFHTTPSessionManager`, clase del Framework de red que nos abstrae la complejidad de las llamadas de red HTTP, y nos provee de gestión de errores, asincronismo, entre otras características *out of the box*. Para mi el uso de `AFNetworking` es un must en cada proyecto.

#### Facade
El patrón fachada se aplica para estructurar varios subsistemas en capas, siendo las fachadas el punto de entrada a cada nivel y desacoplar un sistema de sus clientes y de otros subsistemas, haciéndolo más independiente, portable y reutilizable.

En nuestro caso se utilizará en el modelo de datos para abstraer a los controladores de la interacción con el servidor la clase `Fact` expondrá el método 

``` objc
- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                     failure:(void (^)(NSError *error))failure;
```
El cual dependiendo del tipo de la instancia de `Fact` que podrá ser `NumberFact`, `DateFact` o `RandomFact` hará la correspondiente llamada a la API y devolverá el resultado por medio de dos bloques, uno en caso satisfactorio, y otro en caso de que haya habido un error. De esta manera clases externas no necesitan conocer detalles de implementación del API o en caso de cambiar de API en el futuro estas no se verán afectadas.

#### Factory Method

Se hace uso de este patrón por un lado para la creación de objetos de tipo `Fact` y por otro para la creación de los botones de selección `FactTypeButton` los cuales modificarán la interfaz e icono del botón dependiendo del tipo que representen.

En el caso de `Fact` esta clase expone una seria de métodos para la inicialización de objetos de tipo `Fact`:

``` objc
+ (Fact *)factWithRawText:(NSString *)text andType:(FactType)type;
+ (Fact *)factWithNumber:(NSInteger)number;
+ (Fact *)factWithDate:(NSDate *)date;
+ (Fact *)factRandom;
```

Todos ellos debidamente documentados en el fichero cabecera `Fact.h`. En función del método estático llamado se devolverá una instancia de `NumberFact`, `DateFact` o `RandomFact`, cada una de estas clases implementa de manera diferente el método `getFactWithSuccess:failure:` de esta manera las clases encargadas de instanciar objetos de tipo `Fact` se abstraen de los tipos disponibles y de su implementación, y en caso de que en el futuro se añadan nuevos tipos no habrá que hacer modificaciones en las clases existentes.

#### Delegate

Patrón muy común usado en el desarrollo con el Framework Cocoa. Nos permite delegar la responsabilidad de ciertas acciones de una clase en otras clases, la implementación en Objective-C de este patrón se realiza por medio de protocolos.

Este patrón se ha aplicado en todas las vistas de la aplicación para delegar en el controlador las acciones necesarias tras interactuar con cada una de las vistas. Por ejemplo al pulsar un botón en `FactTypeButton`, al mostrar el teclado o introducir algún valor en `FactInputTextField` y al seleccionar un fecha o cancelar el control en `DateMonthPickerView`.

#### Observer

Patrón de diseño que define una dependencia del tipo uno-a-muchos entre objetos, de manera que cuando uno de los objetos cambia su estado, notifica este cambio a todos los dependientes. En esta app se hace uso de este patrón para ser notificado en cambios en la aparición del teclado del sistema de manera que las vistas puedan reaccionar, se puede observar la implementación en la clase `FactInputTextField`.

## Roadmap para futuros añadidos

Se piden tres nucas características para la app:

- Poder incluir nuevos datos sobre números y fechas.
- Ver un calendario para poder seleccionar un día.
- Compartir en twitter o Facebook.

####¿Cómo plantearías el roadmap? 

El roadmap dependerá mucho de los recursos humanos disponibles, en caso de tener 3 desarrolladores iOS son acciones que se podrían desarrollar en paralelo sin problema, pues afectan a diferentes capas de la app.

Una estimación en horas del coste de desarrollo de cada una de las tareas sería:

- Poder incluir nuevos datos sobre números y fechas. (~3 horas)
	- Conexión con el API (<1h) sin contar con el desarrollo en backend.
	- Elaboración de las pantallas para la entrada de datos (~1h) dependiendo de diseño.
	- Pruebas (<1h)
- Ver un calendario para poder seleccionar un día. (~2 horas)
	- El desarrollo de un componente custom para un calendario tiene cierta complejidad y dado que con es core de nuestra app no me plantearía realizar un desarrollo, existen multitud de componentes desarrollados por la comunidad  que podemos utilizar, haría un estudio del que mejor se adapte a nuestras necesidades y lo integraría en la app. Podemos buscar en [Cocoacontrols](https://www.cocoacontrols.com/search?utf8=%E2%9C%93&q=calendar) o en [Cocoapods](http://cocoapods.org/?q=calendar). Entre research e integración el tiempo de implementación rondaría las 2 horas. 
- Compartir en twitter o Facebook. (< 1hora)
	- Tarea básica que desde el SDK del iOS 7 se realiza de forma nativa utilizando el Framework `<Social/Social.h>`. Además con iOS 8 podemos aprovechar los widgets de compartir de otras apps, no solo Facebook y Twitter.

Dado que son tareas muy simples que se podrían llevar a cabo en menos de una jornada de trabajo, priorizaría la implementación dependiendo de sus dependencias, por ejemplo: disponer del diseño de las pantallas para introducir los datos, o que el backend tenga los métodos desarrollados para poder almacenar datos.

Sin duda la primera tarea que desarrollaría sería la integración social, ya que va ayudar a incrementar las posibilidades de viralización de nuestra app y por tanto a conseguir más descargas.

####¿Qué necesitarías cambiar de lo que has hecho? 

No habría que hacer cambios, simplemente añadir cosas.

- Para poder incluir nuevos datos sobre números y fechas, habría que incluir las correspondientes llamadas al server en `NumbersAPIClient`, implementar las llamadas en las clases  `NumberFact`, `DateFact` y exponer en la interfaz de `Fact` un método para que se llame a las subclases.

- Ver un calendario para poder seleccionar un día. Habría que cambiar el actual `DateMonthPickerView` por el componente que seleccionemos e implantar sus callbacks o las llamadas como delegado, según la lib. La clase `FactInputTextField` expone la fecha seleccionada a `HomeViewController` a través de otro delegado por lo que al estar en diferentes capas no habría que realizar cambios en el controlador.

- Compartir en twitter o Facebook. Habría que añadir las llamadas y botones correspondientes en `FactDetailViewController`.

####¿Qué APIs/librerías te plantearías usar? 

Para el caso del calendario habría que realizar un estudio sobre las librerías de terceros disponibles en [Cocoacontrols](https://www.cocoacontrols.com/search?utf8=%E2%9C%93&q=calendar) o en [Cocoapods](http://cocoapods.org/?q=calendar).

Para las funciones de compartir usaría los APIs nativos del SDK de iOS.

## Autor

Javier Berlana

- http://github.com/jberlana
- http://twitter.com/jberlana
- jberlana@gmail.com

### Licencia

Facts is available under the MIT license. 
