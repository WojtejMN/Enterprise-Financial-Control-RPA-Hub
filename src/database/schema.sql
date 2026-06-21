-- ====================================================================
-- Moduł: Warstwa Danych (Database Schema)
-- Opis: Struktura tabel do obsługi kolejki faktur oraz kursów rynkowych
-- ====================================================================

-- 1. Tworzenie tabeli kursów walut (Słownik walutowy)
CREATE TABLE MarketExchangeRates (
    RateID INT IDENTITY(1,1) PRIMARY KEY,
    CurrencyCode CHAR(3) NOT NULL,            -- Np. 'EUR', 'USD'
    ExchangeRate DECIMAL(18,4) NOT NULL,      -- Dokładność do 4 miejsc po przecinku (standard bankowy)
    FetchTimestamp DATETIME DEFAULT GETDATE() -- Kiedy pobrano dane z API
);

-- 2. Tworzenie tabeli głównej faktur kosztowych (Kolejka dla bota RPA)
CREATE TABLE InvoiceProcessingQueue (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    ExternalFileName VARCHAR(255) NOT NULL,   -- Nazwa pliku z bufora OneDrive
    ContractorNIP VARCHAR(15) NULL,           -- Wyciągnięty przez OCR/Regex
    InvoiceNumber VARCHAR(50) NULL,           -- Numer faktury
    AmountForeign DECIMAL(18,2) NULL,         -- Kwota w walucie oryginalnej
    Currency CHAR(3) DEFAULT 'PLN',           -- Kod waluty faktury
    Status VARCHAR(30) DEFAULT 'NEW',         -- Statusy: NEW, IN_PROGRESS, COMPLETED, EXCEPTION
    ErrorMessage VARCHAR(MAX) NULL,           -- Logowanie błędów biznesowych/technicznych
    CreatedAt DATETIME DEFAULT GETDATE(),     -- Czas trafienia do bufora
    ProcessedAt DATETIME NULL                 -- Czas zakończenia pracy przez bota desktopowego
);

-- 3. Tworzenie indeksów dla optymalizacji zapytań bota
CREATE INDEX IX_Invoice_Status ON InvoiceProcessingQueue(Status);
CREATE INDEX IX_Rates_Code ON MarketExchangeRates(CurrencyCode);
