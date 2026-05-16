# Intune AI-rapport

Automatiserar säkerhetsrapporter från Microsoft Intune 
med PowerShell, Graph API och lokal AI (Mistral via Ollama).

## Vad gör scriptet?
- Hämtar enhetsdata från Intune via Graph API
- Identifierar enheter utan compliance, gamla OS-versioner etc.
- Skickar datan till lokal AI som genererar en svensk sammanfattning med riskanalys

## Tekniker
- PowerShell
- Microsoft Graph API
- Ollama (Mistral)
- Microsoft Intune

## Krav
- PowerShell 7+
- Ollama installerat lokalt
- App-registrering i Entra ID med rätt Graph-behörigheter
