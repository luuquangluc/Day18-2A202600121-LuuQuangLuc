# setup_win.ps1
# Windows PowerShell setup script for Day 18 Lakehouse Lab
# Mimics 'make setup' and 'make smoke'

$VENV = ".venv"

Write-Host "--- Starting Lakehouse Lab Setup (Windows) ---" -ForegroundColor Cyan

# 1. Create virtual environment if it doesn't exist
if (-not (Test-Path $VENV)) {
    Write-Host "[1/4] Creating virtual environment..." -ForegroundColor Yellow
    python -m venv $VENV
} else {
    Write-Host "[1/4] Virtual environment already exists." -ForegroundColor Gray
}

# 2. Install dependencies
Write-Host "[2/4] Installing dependencies from requirements.txt..." -ForegroundColor Yellow
& "$VENV\Scripts\python.exe" -m pip install -q -r requirements.txt

# 3. Convert Python scripts to notebooks
Write-Host "[3/4] Converting scripts to notebooks..." -ForegroundColor Yellow
$scripts = Get-ChildItem "notebooks\*.py"
foreach ($script in $scripts) {
    if ($script.Name -ne "_setup.py") {
        & "$VENV\Scripts\jupytext.exe" --to notebook --update $script.FullName
    }
}

# 4. Run smoke test
Write-Host "[4/4] Running smoke test..." -ForegroundColor Yellow
& "$VENV\Scripts\python.exe" scripts\verify_lite.py

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Setup complete!" -ForegroundColor Green
    Write-Host "To start the lab, run:"
    Write-Host ".\$VENV\Scripts\jupyter lab --notebook-dir=notebooks" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Setup failed during smoke test." -ForegroundColor Red
}
