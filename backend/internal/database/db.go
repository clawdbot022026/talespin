package database

import (
	"log"

	"github.com/talespin/backend/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDB() {
	dsn := "host=localhost user=postgres password=postgres dbname=talespin port=5432 sslmode=disable TimeZone=UTC"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Println("WARNING: Failed to connect to database. Is PostgreSQL running?")
		return
	}

	DB = db
	log.Println("Connected to PostgreSQL")

	// Enable LTREE extension if it doesn't exist
	db.Exec("CREATE EXTENSION IF NOT EXISTS ltree;")

	err = db.AutoMigrate(&models.User{}, &models.Story{}, &models.Node{})
	if err != nil {
		log.Println("Migration failed:", err)
	} else {
		log.Println("Database Migration completed")
	}

	// Seed Dummy User
	var userCount int64
	db.Model(&models.User{}).Count(&userCount)
	if userCount == 0 {
		dummyUser := models.User{
			Username:  "UnknownDrifter",
			Email:     "dummy@talespin.com",
			AvatarURL: "https://api.dicebear.com/7.x/pixel-art/png?seed=Drifter",
		}
		db.Create(&dummyUser)
		log.Println("Seeded Dummy User:", dummyUser.ID)
	}
}
