CREATE DATABASE TiendaModa;
GO
USE TiendaModa;
GO

-- 2. CREACIÓN DE TABLAS (DDL)

-- Tabla para registrar a los clientes
CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) NOT NULL,
    FechaRegistro DATE NOT NULL
);
GO

-- Tabla para las categorías de ropa (ej. Abrigos, Camisas)
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL
);
GO

-- Tabla para los productos o prendas de ropa
CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    NombreProducto VARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    IdCategoria INT FOREIGN KEY REFERENCES Categorias(IdCategoria)
);
GO

-- Tabla para registrar las compras de los clientes
CREATE TABLE Pedidos (
    IdPedido INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT FOREIGN KEY REFERENCES Clientes(IdCliente),
    IdProducto INT FOREIGN KEY REFERENCES Productos(IdProducto),
    Cantidad INT NOT NULL,
    FechaPedido DATE NOT NULL
);
GO


-- 3. INSERCIÓN DE DATOS (DML)

-- Insertar Clientes
INSERT INTO Clientes (Nombre, Correo, FechaRegistro) VALUES 
('Carlos Mendoza', 'carlos@email.com', '2026-01-15'),
('Elena Rostova', 'elena@email.com', '2026-02-20'),
('Mateo Silva', 'mateo@email.com', '2026-03-05');

-- Insertar Categorías
INSERT INTO Categorias (NombreCategoria) VALUES 
('Abrigos y Chaquetas'),
('Camisas y Tops'),
('Pantalones');

-- Insertar Productos
INSERT INTO Productos (NombreProducto, Precio, Stock, IdCategoria) VALUES 
('Chaqueta de Cuero Underground', 180.00, 15, 1),
('Camisa Elegante Satinada', 85.00, 25, 2),
('Pantalón Cargo Negro', 120.00, 10, 3);

-- Insertar Pedidos Iniciales
INSERT INTO Pedidos (IdCliente, IdProducto, Cantidad, FechaPedido) VALUES 
(1, 1, 1, '2026-06-01'), -- Carlos compró 1 chaqueta
(2, 2, 2, '2026-06-10'), -- Elena compró 2 camisas
(3, 3, 1, '2026-06-15'); -- Mateo compró 1 pantalón
GO


-- 4. PROCEDIMIENTOS ALMACENADOS

-- Procedimiento 1: Reporte de compras de un cliente en un rango de fechas
CREATE PROCEDURE sp_ReportePedidosCliente
    @IdCliente INT,
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT P.IdPedido, C.Nombre, Pr.NombreProducto, P.Cantidad, P.FechaPedido
    FROM Pedidos P
    INNER JOIN Clientes C ON P.IdCliente = C.IdCliente
    INNER JOIN Productos Pr ON P.IdProducto = Pr.IdProducto
    WHERE P.IdCliente = @IdCliente 
      AND P.FechaPedido BETWEEN @FechaInicio AND @FechaFin;
END;
GO

-- Procedimiento 2: Registrar un pedido nuevo y restar el Stock automáticamente
CREATE PROCEDURE sp_RegistrarPedido
    @IdCliente INT,
    @IdProducto INT,
    @Cantidad INT,
    @FechaPedido DATE
AS
BEGIN
    -- Insertamos el nuevo pedido
    INSERT INTO Pedidos (IdCliente, IdProducto, Cantidad, FechaPedido)
    VALUES (@IdCliente, @IdProducto, @Cantidad, @FechaPedido);

    -- Restamos la cantidad vendida del inventario de productos
    UPDATE Productos
    SET Stock = Stock - @Cantidad
    WHERE IdProducto = @IdProducto;
END;
GO


-- 5. CONSULTAS CON CRUCES DE INFORMACIÓN (JOINs)

-- Consulta A: Mostrar el nombre del cliente, el producto que compró y el total de su compra
SELECT 
    C.Nombre AS [Cliente], 
    Pr.NombreProducto AS [Producto], 
    P.Cantidad AS [Cantidad Comprada],
    (P.Cantidad * Pr.Precio) AS [Total Pagado]
FROM Pedidos P
INNER JOIN Clientes C ON P.IdCliente = C.IdCliente
INNER JOIN Productos Pr ON P.IdProducto = Pr.IdProducto;

-- Consulta B: Mostrar todos los productos con el nombre de su categoría
SELECT 
    P.NombreProducto AS [Producto], 
    C.NombreCategoria AS [Categoría], 
    P.Precio AS [Precio]
FROM Productos P
INNER JOIN Categorias C ON P.IdCategoria = C.IdCategoria;
GO