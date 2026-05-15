# ================================
# INTUNE AI RAPPORT
# PowerShell + Graph API + Mistral
# ================================

# SIMULERAD INTUNE-DATA (testmiljö)
$DeviceList = @(
    @{ deviceName="LAPTOP-001"; operatingSystem="Windows"; osVersion="10.0.19045"; complianceState="compliant"; lastSyncDateTime="2024-01-10" },
    @{ deviceName="LAPTOP-002"; operatingSystem="Windows"; osVersion="10.0.18363"; complianceState="noncompliant"; lastSyncDateTime="2024-01-05" },
    @{ deviceName="IPHONE-003"; operatingSystem="iOS"; osVersion="16.1"; complianceState="compliant"; lastSyncDateTime="2024-01-11" },
    @{ deviceName="LAPTOP-004"; operatingSystem="Windows"; osVersion="10.0.19045"; complianceState="noncompliant"; lastSyncDateTime="2023-12-20" },
    @{ deviceName="ANDROID-005"; operatingSystem="Android"; osVersion="13.0"; complianceState="compliant"; lastSyncDateTime="2024-01-09" }
)

Write-Host "Antal enheter: $($DeviceList.Count)" -ForegroundColor Cyan
$NonCompliant = $DeviceList | Where-Object { $_.complianceState -eq "noncompliant" }
Write-Host "Icke-kompatibla enheter: $($NonCompliant.Count)" -ForegroundColor Red
foreach ($device in $NonCompliant) {
    Write-Host " - $($device.deviceName) | OS: $($device.osVersion) | Senast sync: $($device.lastSyncDateTime)" -ForegroundColor Yellow
}

# ================================
# SKICKA DATA TILL MISTRAL VIA OLLAMA
# ================================
$Sammanfattning = @"
Här är data från en Intune-miljö:
- Totalt antal enheter: $($DeviceList.Count)
- Icke-kompatibla enheter: $($NonCompliant.Count)
- Icke-kompatibla enheter detaljer:
$($NonCompliant | ForEach-Object { "  * $($_.deviceName) | OS: $($_.osVersion) | Senast sync: $($_.lastSyncDateTime)" } | Out-String)
Skriv en professionell IT-säkerhetsrapport på svenska med riskanalys och rekommenderade åtgärder.
"@

$OllamaBody = @{
    model  = "mistral"
    prompt = $Sammanfattning
    stream = $false
} | ConvertTo-Json

Write-Host "Skickar data till Mistral..." -ForegroundColor Yellow
$OllamaResponse = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method POST -Body $OllamaBody -ContentType "application/json"

Write-Host ""
Write-Host "=== AI-GENERERAD RAPPORT ===" -ForegroundColor Green
Write-Host $OllamaResponse.response

# ================================
# SPARA RAPPORT SOM FIL
# ================================
$OllamaResponse.response | Out-File -FilePath "C:\Users\Danie\Intune-AI-Rapport.txt" -Encoding UTF8
Write-Host ""
Write-Host "Rapport sparad till Intune-AI-Rapport.txt" -ForegroundColor Green
