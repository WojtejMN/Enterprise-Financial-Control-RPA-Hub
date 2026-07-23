# Enterprise Financial Control & RPA Hub 🚀

[![Power Automate](https://img.shields.io/badge/Power%20Automate-0078D4?style=for-the-badge&logo=microsoftpowerautomate&logoColor=white)](https://powerautomate.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![RPA](https://img.shields.io/badge/RPA-Desktop%20Flows-blue?style=for-the-badge)]()

⚙️ Kluczowe Funkcjonalności:

Cloud Flow (Ingestion Pipeline): Automatyczny wykrywacz nowych dokumentów finansowych oraz integracja z zewnętrznym REST API danych rynkowych.
Desktop Flow (RPA Invoice Parser): Wykorzystanie reguł RegEx do bezbłędnego wyciągania numerów faktur, kwot, NIP oraz dat.
Centralna Baza SQL: Spójna struktura relacyjna (schema.sql) z obsłużoną walidacją danych i kontrolą spójności.
Power BI Financial Dashboard: Interaktywny raport prezentujący wskaźniki płynności, strukturę kosztów oraz przewalutowania.
Kompleksowy system automatyzacji procesów finansowo-księgowych (*End-to-End*) łączący chmurowe i stacjonarne przepływy **Power Automate**, relacyjną bazę danych **SQL Server** oraz analityczny raport **Power BI**.

---

## 📌 Problem Biznesowy & Rozwiązanie

Ręczny proces przetwarzania faktur oraz pobierania kursów walut generuje opóźnienia i ryzyko błędów ludzkich. **Enterprise Financial Control RPA Hub** automatyzuje całą ścieżkę: od odbioru dokumentu, przez ekstrakcję danych za pomocą wzorców RegEx i robotyzacji procesów (RPA), zasilenie centralnej bazy danych SQL, aż po automatyczną prezentację kluczowych wskaźników finansowych (KPI) w Power BI.

---

## 🏗️ Architektura Systemu

```mermaid
graph TD
    A[Odbiór Faktury / E-mail] -->|Power Automate Cloud| B[Power Automate Desktop - RPA]
    B -->|Ekstrakcja RegEx & Walidacja| C[(SQL Server Database)]
    D[External Market Data API] -->|Cloud Flow - REST API| C
    C -->|Import & DAX Models| E[Power BI Dashboard]
