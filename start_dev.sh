#!/bin/bash

# A script to start TaleSpin in Development Mode.

echo "TaleSpin: The Multiverse Story Engine"
echo "---------------------------------------"
echo "Starting system diagnostic checks..."

# Requirement Checker Functions
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ Error: $1 is not installed."
        if [ -n "$2" ]; then
            echo "   Recommendation: $2"
        fi
        exit 1
    else
        echo "✅ $1 is installed."
    fi
}

# 1. Check requirements
check_command go "brew install go"
check_command flutter "brew install --cask flutter"
check_command psql "brew install postgresql@14"
check_command redis-cli "brew install redis"

echo ""
echo "🚀 Everything looks good. Starting the Multiverse Engine..."
echo "=========================================================="
echo ""

# 2. Check Database Service Status (macOS Homebrew)
echo "Ensuring Databases are active via Homebrew services..."
brew services start postgresql 2>/dev/null
brew services start redis 2>/dev/null

# 3. Create the Database if it doesn't already exist
echo "Making sure the Postgres Database exists..."
createdb talespin 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   Database created!"
else
    echo "   Database already exists or the command failed."
fi

# 4. Start the Backend API in the background.
echo "Starting Backend API (Golang)..."
cd "backend" || exit
go mod tidy
go run ./cmd/server/main.go &
BACKEND_PID=$!
cd ..

# Wait a second for the API to boot before starting the UI
sleep 2

# 5. Start the Frontend Application.
echo "Starting Frontend UI (Flutter Web)..."
cd "frontend" || exit
flutter pub get
# The `-d chrome` flag ensures it opens efficiently in the browser for web view.
flutter run -d chrome

# 6. Trap Control-C to kill the backend too.
trap "echo 'Killing backend server...'; kill $BACKEND_PID; exit" INT TERM
