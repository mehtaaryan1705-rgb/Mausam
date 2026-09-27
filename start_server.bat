@echo off
echo ========================================================
echo   Starting Mausam Weather Web & Mobile App Server
echo   Ministry of Earth Sciences (IMD) - SIH 2026
echo ========================================================
echo.
echo Serving production build on port 8080...
echo Accessible locally at: http://localhost:8080
echo Accessible on Wi-Fi at: http://0.0.0.0:8080
echo.
echo Launching browser...
start http://localhost:8080
echo.
echo (Press Ctrl + C in this window to stop the server)
python -m http.server 8080 --bind 0.0.0.0 --directory build/web
pause
