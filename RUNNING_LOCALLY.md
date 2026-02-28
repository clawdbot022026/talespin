# Running TaleSpin Locally

This document contains everything you need to start the TaleSpin application (Backend API & Frontend UI) on your local machine. 

As we add new tools, databases, or services in later phases, this document will be updated.

---

## 🛠 Prerequisites

Before starting, ensure you have the following installed on your machine:

1. **Go (Golang) v1.21+**: Powers the high-concurrency API.
2. **Flutter (v3.19+)**: Renders the multi-platform UI.
3. **PostgreSQL**: The primary relational database (used to store the story trees).
4. **Redis**: The in-memory cache used for buffering votes and active story hot-paths.

---

## 🚀 The Automatic Way (Recommended)

To make things effortless, we have created a bash script that checks if you have all the requirements, warns you if something is missing, and then automatically starts both the Go API and the Flutter Web app.

**1. Run the startup script from the root of the project:**
```bash
./start_dev.sh
```

---

## 🧑‍💻 The Manual Way

If you prefer to run things in separate terminal windows (better for seeing logs during development), follow these steps:

### 1. Start the Databases
Ensure that your local PostgreSQL server and Redis server are running in the background. If you're using Homebrew on macOS, you can start them like this:
```bash
brew services start postgresql
brew services start redis
```

### 2. Start the Backend API (Go)
Open a terminal window and start the Go server:
```bash
cd backend
go run cmd/server/main.go
```
*The API will start running on `http://localhost:8080`.*

### 3. Start the Frontend (Flutter)
Open a **second** terminal window and run the Flutter application:
```bash
cd frontend
flutter run -d chrome
```
*This will open the TaleSpin app in your Google Chrome browser.*

---

## 🐛 Troubleshooting

*   **Flutter complains about missing pubspec.yaml**: Make sure you have navigated *into* the `frontend` folder (`cd frontend`) before running `flutter run`.
*   **Database connection fails**: Ensure PostgreSQL is running on port `5432` with a `postgres` user. You may need to create the database manually the first time by running `createdb talespin` in your terminal.
