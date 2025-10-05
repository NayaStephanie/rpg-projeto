# Script para servir o app localmente
# Windows PowerShell

# Build para produção
flutter build web --release

# Serve na rede local
cd build\web
python -m http.server 8080

Write-Host "App disponível em:"
Write-Host "Local: http://localhost:8080"
Write-Host "Rede: http://192.168.0.11:8080"