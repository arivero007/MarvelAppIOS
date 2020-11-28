# MarvelAppIOS

Aplicación para probar la API de Marvel, solicitando un listado de personajes y visualizando su información.

Consta de 2 pantallas: la primera, en la que se visualiza el listado de personajes obtenido y la segunda, en la que se detalla la información del personaje seleccionado.

En la primera se puede filtrar por nombre y actualizar la lista.

* Librerias (PODS):

  - pod 'Alamofire', '~> 5.2'
  - pod 'JGProgressHUD'
  - pod 'RxSwift', '6.0.0-rc.2'
  - pod 'RxCocoa', '6.0.0-rc.2'

Observaciones:

Para probar diferentes servicios web se ha realizado la llamada para obtener el detalle del personaje en la segunda pantalla, pero ésta habría sido innecesaria ya que en el primer WS obtenía toda la información y podía reutilizarla.
