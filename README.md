1\. Descripción Técnica: 



Este proyecto contiene el diseño relacional para el almacenamiento de datos de nuestra marca de moda. Permite gestionar de manera organizada la información de los usuarios registrados, el inventario de prendas disponibles y el historial de compras realizadas.



Motor de Base de Datos Utilizado: Microsoft SQL Server 2022

Cantidad de Tablas: 4 tablas principales interconectadas mediante llaves foráneas.





2\. Diccionario de Datos Básico



Tabla: Clientes

Guarda la información de las personas que se registran en la página web.

\* `IdCliente` (INT, Clave Primaria, Autoincremental): Identificador único del cliente.

\* `Nombre` (VARCHAR): Nombre completo del usuario.

\* `Correo` (VARCHAR): Correo electrónico para el inicio de sesión.

\* `FechaRegistro` (DATE): Fecha en la que el usuario creó su cuenta.



Tabla: Categorias

Clasifica los productos de la tienda para facilitar la navegación.

\* `IdCategoria` (INT, Clave Primaria, Autoincremental): Identificador de la categoría.

\* `NombreCategoria` (VARCHAR): Nombre de la sección (ej. Abrigos, Pantalones).



Tabla: Productos

Almacena el catálogo de prendas exclusivas disponibles.

\* `IdProducto` (INT, Clave Primaria, Autoincremental): Identificador de la prenda.

\* `NombreProducto` (VARCHAR): Nombre comercial del diseño.

\* `Precio` (DECIMAL): Costo de la prenda en el mercado.

\* `Stock` (INT): Cantidad de unidades disponibles en el almacén.

\* `IdCategoria` (INT, Clave Foránea): Conexión con la tabla Categorías.



Tabla: Pedidos

Registra cada transacción o compra realizada desde la interfaz web.

\* `IdPedido` (INT, Clave Primaria, Autoincremental): Número de orden de compra.

\* `IdCliente` (INT, Clave Foránea): Quién realizó la compra.

\* `IdProducto` (INT, Clave Foránea): Qué producto compró.

\* `Cantidad` (INT): Cuántas unidades adquirió.

\* `FechaPedido` (DATE): Día en que se procesó el pago.





3\. Convivencia Conceptual (Nivel 1)

Actualmente, el proyecto se encuentra en el \*\*Nivel 1\*\*, lo que significa que la página web (HTML/CSS) y la Base de Datos (SQL Server) \*\*no están conectadas físicamente por código\*\*, pero conviven bajo la misma lógica de negocio:



1\.  El Catálogo Visual vs La Tabla Productos:\*\* Cuando un usuario entra a la sección "Colecciones" de la web y ve las imágenes de las chaquetas o camisas con sus precios, conceptualmente esa información proviene directamente de la tabla `Productos`.

2\.  El Formulario de Registro vs La Tabla Clientes:\*\* Cuando un cliente llena el formulario de contacto o crea una cuenta en la interfaz web, esos datos están diseñados para viajar al servidor e insertarse en la tabla `Clientes`.

3\.  El Carrito de Compras vs La Tabla Pedidos:\*\* Al presionar el botón "Comprar", el estado del carrito de la interfaz se convierte en una nueva fila dentro de la tabla `Pedidos`, descontando las unidades del `Stock` de la tienda.

