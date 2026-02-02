param(
    [string]$city,
    [string]$apiKey
)

# Utiliser l'API Open-Meteo (gratuite, sans clé)
$url = "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=fr&format=json"

try {
    # Étape 1 : Récupérer les coordonnées
    $geoResponse = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $geoJson = $geoResponse.Content | ConvertFrom-Json
    
    if ($geoJson.results.Count -eq 0) {
        Write-Host "Ville non trouvee!"
        exit 1
    }
    
    $latitude = $geoJson.results[0].latitude
    $longitude = $geoJson.results[0].longitude
    $cityName = $geoJson.results[0].name
    $countryCode = $geoJson.results[0].country_code
    
    # Étape 2 : Récupérer la météo
    $weatherUrl = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,pressure_msl&timezone=auto"
    
    $weatherResponse = Invoke-WebRequest -Uri $weatherUrl -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $weatherJson = $weatherResponse.Content | ConvertFrom-Json
    
    $temp = $weatherJson.current.temperature_2m
    $humidity = $weatherJson.current.relative_humidity_2m
    $pressure = $weatherJson.current.pressure_msl
    $windSpeed = $weatherJson.current.wind_speed_10m
    $weatherCode = $weatherJson.current.weather_code
    
    # Conversion code météo
    $descriptions = @{
        0 = "Ciel degage"
        1 = "Peu nuageux"
        2 = "Partiellement nuageux"
        3 = "Nuageux"
        45 = "Brumeux"
        48 = "Givre"
        51 = "Legere pluie"
        53 = "Pluie moderee"
        55 = "Pluie forte"
        61 = "Pluie legere"
        63 = "Pluie"
        65 = "Pluie forte"
        71 = "Legere neige"
        73 = "Neige"
        75 = "Neige forte"
        77 = "Gresil"
        80 = "Averses legeres"
        81 = "Averses"
        82 = "Averses fortes"
        85 = "Legeres averses de neige"
        86 = "Averses de neige"
        95 = "Orage"
        96 = "Orage avec greile legere"
        99 = "Orage avec greile"
    }
    
    $description = $descriptions[$weatherCode]
    if (-not $description) { $description = "Conditions inconnues" }
    
    Write-Host ""
    Write-Host "==== METEO POUR $cityName ===="
    Write-Host "Temperature: ${temp}degC"
    Write-Host "Description: $description"
    Write-Host "Humidite: ${humidity}%"
    Write-Host "Pression: ${pressure} hPa"
    Write-Host "Vent: ${windSpeed} km/h"
    Write-Host ""
    exit 0
}
catch {
    Write-Host "Erreur: $($_.Exception.Message)"
    Write-Host "Verifiez votre connexion Internet"
    exit 1
}
