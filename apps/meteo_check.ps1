param(
    [string]$city,
    [string]$apiKey
)

# Utiliser l'API Open-Meteo (gratuite, sans clé)
$url = "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=fr&format=json"

try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $json = $response.Content | ConvertFrom-Json
    
    if ($json.results.Count -gt 0) {
        Write-Host "Ville trouvee: $($json.results[0].name)"
        exit 0
    }
    else {
        Write-Host "Ville non trouvee!"
        exit 1
    }
}
catch {
    Write-Host "Erreur de connexion: $($_.Exception.Message)"
    exit 1
}
