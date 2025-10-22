package db

import (
	"log"
	"os"
	"path/filepath"
	"runtime"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func init() {
	appName := "Stockify"
	dbFilename := "inventory.db"
	// Step 1: Determine platform-specific app data directory
	appDataDir, err := getAppDataPath(appName)
	if err != nil {
		log.Fatal("Could not determine app data directory:", err)
	}
	// Step 2: Ensure directory exists
	if err := os.MkdirAll(appDataDir, 0755); err != nil {
		log.Fatal("Failed to create app data directory:", err)
	}
	// Step 3: Full DB path
	dbPath := filepath.Join(appDataDir, dbFilename)
	log.Println("Using SQLite DB at:", dbPath)
	// Step 4: Connect
	DB, err = gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
	DB = DB.Debug() // Enable debug mode
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
}

func getAppDataPath(appName string) (string, error) {
	switch runtime.GOOS {
	case "windows":
		appData := os.Getenv("AppData")
		if appData == "" {
			return "", os.ErrNotExist
		}
		return filepath.Join(appData, appName), nil
	case "darwin":
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, "Library", "Application Support", appName), nil
	case "linux":
		dataHome := os.Getenv("XDG_DATA_HOME")
		if dataHome == "" {
			home, err := os.UserHomeDir()
			if err != nil {
				return "", err
			}
			dataHome = filepath.Join(home, ".local", "share")
		}
		return filepath.Join(dataHome, appName), nil
	default:
		return "", os.ErrInvalid
	}
}
