# ☁️ Hybrid Cloud-Desktop Orchestration

## End-to-End Pipeline Architecture
Ten moduł dokumentuje architekturę hybrydową stworzoną w modelu Zero-Touch Automation. System samodzielnie zarządza przepływem danych od momentu wejścia informacji z zewnątrz do momentu aktualizacji bazy lokalnej.

### ⚙️ Warstwa Chmurowa (Power Automate Cloud)
1. **Wyzwalacz (Trigger):** Nasłuchiwanie skrzynki odbiorczej (Office 365 Outlook) na wiadomości e-mail ze wskazanym słowem kluczowym.
2. **Ingestia Danych:** Bezpieczne wyodrębnienie załączników PDF (faktur) i zrzut do zsynchronizowanego folderu buforowego (`01_Input_Buffer`).
3. **Orkiestracja (Machine Gateway):** Nawiązanie autoryzowanego połączenia z maszyną stacjonarną (On-Premise).
4. **Egzekucja:** Zewnętrzne uruchomienie skryptu stacjonarnego (Power Automate Desktop) w trybie wsadowym (Batch Processing) poza główną pętlą zrzutu plików.
