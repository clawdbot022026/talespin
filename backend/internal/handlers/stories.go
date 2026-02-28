package handlers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/models"
)

// GetTrendingStories returns a list of popular stories
func GetTrendingStories(c *fiber.Ctx) error {
	var stories []models.Story

	database.DB.Order("created_at desc").Limit(10).Preload("Author").Find(&stories)

	// Create simplified response payload to match frontend expects
	var result []map[string]interface{}
	for _, s := range stories {
		// Calculate total nodes just dynamically for now for MVP
		var nodeCount int64
		database.DB.Model(&models.Node{}).Where("story_id = ?", s.ID).Count(&nodeCount)

		result = append(result, map[string]interface{}{
			"id":                 s.ID,
			"title":              s.Title,
			"authorName":         s.Author.Username,
			"authorAvatarUrl":    s.Author.AvatarURL,
			"tags":               s.Tags,
			"totalNodes":         nodeCount,
			"weeklyVoteVelocity": 10.0, // Mock for now
		})
	}

	return c.Status(200).JSON(fiber.Map{
		"success": true,
		"data":    result,
	})
}

// CreateStoryRequest maps the incoming POST request
type CreateStoryRequest struct {
	Title   string `json:"title"`
	Tags    string `json:"tags"`
	Content string `json:"content"` // Text for the first node
}

// CreateStory initializes a "Genesis Node"
func CreateStory(c *fiber.Ctx) error {
	req := new(CreateStoryRequest)
	if err := c.BodyParser(req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request payload"})
	}

	// Validate limits
	if len(req.Title) < 3 || len(req.Content) < 50 || len(req.Content) > 280 {
		return c.Status(400).JSON(fiber.Map{"error": "Constraints violation: Title >= 3, Content between 50-280 characters"})
	}

	// For MVP Phase 1 (Before Authentication), query the dummy user
	var dummyUser models.User
	database.DB.First(&dummyUser)

	// Transaction to create both Story and initial Node
	tx := database.DB.Begin()

	// 1. Create Story Meta
	story := models.Story{
		Title:    req.Title,
		Tags:     req.Tags,
		AuthorID: dummyUser.ID,
	}
	if err := tx.Create(&story).Error; err != nil {
		tx.Rollback()
		return c.Status(500).JSON(fiber.Map{"error": "Failed to generate story framework"})
	}

	// 2. Create Genesis Node (ParentID is null, path format is just its own ID without dashes, e.g., using uuid stripped of hyphens)
	node := models.Node{
		StoryID:  story.ID,
		Content:  req.Content,
		AuthorID: dummyUser.ID,
	}

	// Save note first to retrieve its auto-generated UUID
	if err := tx.Create(&node).Error; err != nil {
		tx.Rollback()
		return c.Status(500).JSON(fiber.Map{"error": "Failed to create genesis node"})
	}

	// LTREE requires formatting UUID without dashes.
	// We'll do this in a raw SQL update on the very first node.
	tx.Exec("UPDATE nodes SET path = replace(?::text, '-', '_')::ltree WHERE id = ?", node.ID, node.ID)

	tx.Commit()

	// Refetch to get the full node with properly formatted LTREE path
	var genesisNode models.Node
	database.DB.Preload("Author").Preload("Story").First(&genesisNode, node.ID)

	return c.Status(201).JSON(fiber.Map{
		"success": true,
		"message": "The universe has expanded.",
		"story":   story,
		"node":    genesisNode,
	})
}
