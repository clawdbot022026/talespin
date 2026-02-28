package handlers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/models"
)

// GetTrendingStories returns a list of popular stories
func GetTrendingStories(c *fiber.Ctx) error {
	var stories []models.Story

	if database.DB != nil {
		// Mock logic: Just fetch the latest 10 stories
		database.DB.Order("created_at desc").Limit(10).Find(&stories)
	}

	return c.Status(200).JSON(fiber.Map{
		"success": true,
		"data":    stories,
	})
}
