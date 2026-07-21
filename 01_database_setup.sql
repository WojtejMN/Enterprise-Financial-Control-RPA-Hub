CREATE DATABASE EnterpriseRPA;
GO
USE EnterpriseRPA;
GO
CREATE TABLE ZobowiazaniaKosztowe (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NIP VARCHAR(20),
    KwotaNetto DECIMAL(18,2),
    DataWprowadzenia DATETIME DEFAULT CURRENT_TIMESTAMP
);