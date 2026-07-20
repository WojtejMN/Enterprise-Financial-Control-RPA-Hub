# Kompleksowy Ekosystem Automatyzacji i Inżynierii Danych (End-to-End Cloud & Desktop RPA Pipeline)

🛠️ **Wykorzystany Stack Technologiczny (Tech Stack):**
*   **Orkiestracja i Logika Chmurowa:** Power Automate Cloud Flows (Automated & Scheduled Pipelines).
*   **Automatyzacja Powierzchniowa (RPA) i Przetwarzanie Wsadowe:** Power Automate Desktop (PAD) - operacje na plikach płaskich, ekstrakcja Regex, orkiestracja lokalna.
*   **Integracje Zewnętrzne:** REST API (HTTP GET requests), zaawansowany parsing struktur JSON.
*   **Przechowywanie i Zarządzanie Plikami:** OneDrive for Business / SharePoint Online (Strukturyzowane repozytoria i bufory danych).
*   **Warstwa Danych i Analityka (Planowane):** T-SQL (Bazy relacyjne, procedury składowane), Microsoft Dataverse, Power BI Desktop (Wizualizacja danych finansowych i operacyjnych).

---

## 📦 Struktura Modułowa Projektu (Module Breakdown)

### 📧 Moduł 1: Multi-channel Ingestion Pipeline (Status: Ukończony i Zweryfikowany)
**Cel:** Stworzenie bezpiecznego, odpornego na błędy punktu wejścia dla dokumentacji kosztowej firmy.
*   **Mechanizm działania:** Przepływ działa w trybie ciągłym (24/7). Nasłuchuje wiadomości e-mail spełniających kryteria maski tematów (Faktura, FV).
*   **Walidacja Techniczna (Input Validation):** System realizuje pętlę po tablicy załączników i sprawdza rozszerzenia plików przy użyciu instrukcji warunkowych logicznego alternatywy (OR). Dopuszczane są wyłącznie pliki `.pdf`, `.png` oraz `.jpg`.
*   **Cybersecurity & Defensively Programming:** Pliki wykonywalne (`.exe`, `.bat`) oraz archiwa bezstrukturalne są natychmiast odrzucane, izolowane w katalogu `04_Exceptions`, a do nadawcy generowany jest oficjalny zwrotny alert systemowy informujący o niespełnieniu kryteriów biznesowych.
*   **Standaryzacja Danych:** Poprawne dokumenty otrzymują unikalny identyfikator czasowy generowany wyrażeniem `utcNow('yyyyMMdd_HHmmss')`, co eliminuje ryzyko nadpisania plików o identycznych nazwach pierwotnych w strefie buforowej `01_Input_Buffer`.

### 💱 Moduł 2: Market Data API Integration (Status: Ukończony)
**Cel:** Automatyczne pozyskiwanie danych makroekonomicznych niezbędnych do wyceny i konwersji kosztów wielowalutowych.
*   **Mechanizm działania:** Przepływ zaplanowany (Scheduled Flow) uruchamiany codziennie w godzinach porannych.
*   **Konsumpcja REST API:** Realizacja bezautoryzacyjnego zapytania HTTP GET do endpointów Narodowego Banku Polskiego.
*   **Manipulacja strukturą JSON:** Przetwarzanie surowego ciągu tekstowego (Body) na strukturyzowany obiekt silnie typowany przy pomocy akcji Parse JSON i dedykowanego schematu tablicowego. Zaawansowana filtracja pętli w celu wyodrębnienia kursów walut strategicznych (EUR, USD) i przypisania ich do zmiennych zmiennoprzecinkowych (Float).

### 🤖 Moduł 3: Hybrid Orchestration & Flat-File Data Pipeline (Status: Ukończony)
**Cel:** W pełni zautomatyzowana, bezobsługowa ekstrakcja danych z dokumentów, kalkulacja finansowa i zrzut do warstwy buforowej.
*   **Mechanizm działania:** Przepływ chmurowy (Power Automate Cloud) zdalnie wyzwala bota desktopowego (Machine Gateway) po pomyślnej walidacji paczki danych z Modułu 1. 
*   **Data Ingestion & Extraction:** Bot stacjonarny omija awaryjne interfejsy graficzne (UI), bezpośrednio parsując pliki PDF. Wykorzystuje zaawansowane wyrażenia regularne (Regex) do bezbłędnej ekstrakcji i standaryzacji kluczowych metadanych (NIP, kwoty brutto/netto).
*   **Batch Processing & Reporting:** Oczyszczone informacje są wprowadzane w trybie wsadowym do pliku płaskiego (CSV Staging Area). W locie agregowana jest całkowita suma zobowiązań oraz wolumen dokumentów, po czym system automatycznie generuje i wysyła raport zarządczy poprzez integrację z aplikacją Outlook, zamykając proces End-to-End (E2E).

### 📊 Moduł 4: Enterprise Data Warehouse & Analytics (Status: Planowany)
**Cel:** Konsolidacja danych i prezentacja wskaźników efektywności (KPI) dla kadry zarządzającej.
*   **Mechanizm działania:** Integracja bazy SQL z Power BI. Tworzenie raportów dynamicznych prezentujących koszty operacyjne w czasie, ekspozycję na ryzyko walutowe oraz wskaźnik ROI wdrożonej automatyzacji (czas zaoszczędzony przez boty).

---

## 🧠 Wyzwania Techniczne i Troubleshooting (Hard Skills)
Podczas prac nad systemem rozwiązano szereg problemów inżynierskich, co pozwoliło na zdobycie zaawansowanej wiedzy praktycznej z zakresu Power Platform:

*   **Błąd Obiektowy Excel API (Status 404 - Not Found):**
    *   *Problem:* Podczas integracji struktur tabelarycznych Power Automate zgłaszał brak obiektów wewnątrz dynamicznie otwieranego pliku.
    *   *Rozwiązanie:* Zdiagnozowano błąd mapowania danych – surowy arkusz roboczy (Sheet) nie jest traktowany przez API Microsoft Graph jako obiekt bazodanowy. Wprowadzono twarde strukturyzowanie danych do tabel (Ctrl + T) oraz nadano unikalne identyfikatory obiektów (Table Name), co umożliwiło botowi dynamiczny odczyt wierszy po identyfikatorze pliku (File Identifier).

*   **Konflikty Blokowania Plików w Chmurze (File Locking & Concurrency):**
    *   *Problem:* OneDrive blokował procesy zapisu w momencie, gdy plik wejściowy był otwarty przez użytkownika (human-bot collision).
    *   *Rozwiązanie:* Zaimplementowano regułę automatycznego wymuszania formatu `.xlsx` (zamiast archiwalnego `.xls`), co zoptymalizowało zarządzanie metadanymi współużytkowania, a w architekturze procesu wprowadzono zasadę izolacji plików w buforze `02_In_Progress`.

*   **Blokada Systemowa Pliku Płaskiego (System.IO.IOException):**
    *   *Problem:* Bot desktopowy zwracał błąd odmowy dostępu podczas próby zapisu (append) nowych rekordów do pliku `Baza_Faktur.csv`, wynikający z nałożenia twardej blokady przez system operacyjny Windows.
    *   *Rozwiązanie:* Wdrożono architekturę całkowicie bezobsługową (Zero-Touch). Wyeliminowano ręczne inspekcje plików w trakcie trwania pętli wsadowej na rzecz automatycznego raportowania mailowego (moduł alertów w Outlooku), co gwarantuje pełną dostępność strumienia danych (FileStream) dla procesu I/O.

---

## 📈 Wartość Biznesowa Wdrożenia (Business Value & ROI)

*   **Optymalizacja czasu pracy (Efficiency):** Redukcja średniego czasu rejestracji i weryfikacji dokumentu kosztowego z 15 minut (manualna praca pracownika) do < 12 sekund (procesowanie bezobsługowe w architekturze Flat-File).
*   **Eliminacja Human Error:** Stuprocentowa poprawność transferu danych numerycznych (kwoty netto, brutto, numery kont, NIP) dzięki automatycznemu odczytowi i zastosowaniu zaawansowanych wyrażeń regularnych (Regex), co całkowicie wyeliminowało ryzyko wprowadzania niedozwolonych znaków alfanumerycznych do bazy.
*   **Ciągłość Procesowa:** Odporność punktu wejściowego na błędy ludzkie – system samodzielnie filtruje, informuje i koryguje niepoprawne zgłoszenia bez angażowania deweloperów czy księgowych.
