package handlers

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/models"
)

type BranchNodeRequest struct {
	Content string `json:"content"`
}

// BranchNode creates a new timeline divergence or linear continuation
// Expected URL Example: POST /api/nodes/NODE_UUID_HERE/branch
func BranchNode(c *fiber.Ctx) error {
	parentID := c.Params("id")
	if parentID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Parent Node ID is required to branch"})
	}

	req := new(BranchNodeRequest)
	if err := c.BodyParser(req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request payload"})
	}

	// Validate content limits
	if len(req.Content) < 10 || len(req.Content) > 280 {
		return c.Status(400).JSON(fiber.Map{"error": "Constraints violation: Content must be between 10 and 280 characters"})
	}

	// 1. Fetch the Parent Node to inherit its StoryID and LTREE Path
	var parentNode models.Node
	if err := database.DB.Where("id = ?", parentID).First(&parentNode).Error; err != nil {
		log.Println("Parent node not found:", parentID)
		return c.Status(404).JSON(fiber.Map{"error": "Original timeline point not found"})
	}

	// For MVP Phase 1: Fetch Dummy User
	var dummyUser models.User
	database.DB.First(&dummyUser)

	tx := database.DB.Begin()

	// 2. Create the New Node (The Divergence)
	newNode := models.Node{
		StoryID:  parentNode.StoryID,
		ParentID: &parentNode.ID,
		Content:  req.Content,
		AuthorID: dummyUser.ID,
	}

	// We must save the record first so GORM generates the uuid PK for us.
	if err := tx.Create(&newNode).Error; err != nil {
		tx.Rollback()
		return c.Status(500).JSON(fiber.Map{"error": "Failed to branch the timeline"})
	}

	// 3. The Multiverse Engine Magic: PostgreSQL LTREE Path Concatonation
	// The new path = `ParentPath` . `NewNodeID_without_hyphens`
	query := `
		UPDATE nodes 
		SET path = (SELECT path FROM nodes WHERE id = ?) || replace(?::text, '-', '_')::ltree 
		WHERE id = ?
	`
	if err := tx.Exec(query, parentNode.ID, newNode.ID, newNode.ID).Error; err != nil {
		tx.Rollback()
		return c.Status(500).JSON(fiber.Map{"error": "Chronal graph alignment failed"})
	}

	tx.Commit()

	// 4. Return the new branch context
	var finalNode models.Node
	database.DB.Preload("Author").First(&finalNode, newNode.ID)

	return c.Status(201).JSON(fiber.Map{
		"success": true,
		"message": "A new timeline has been forged.",
		"node":    finalNode,
	})
}

// VoteNode increments a high-speed Redis vote counter
// URL: POST /api/nodes/:id/vote
func VoteNode(c *fiber.Ctx) error {
	nodeID := c.Params("id")
	if nodeID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Node ID is required to vote"})
	}

	// In a complete Auth Phase, we would store UserID to prevent double-voting.
	// For Phase 1 (Frictionless MVP): We allow anonymous burst voting!

	redisKey := "node:vote:" + nodeID

	// Increment the counter in Redis (Memory-Speed atomic operation)
	newCount, err := database.RedisClient.Incr(database.Ctx, redisKey).Result()
	if err != nil {
		log.Println("Redis Incr error:", err)
		return c.Status(500).JSON(fiber.Map{"error": "Failed to lock in your vote due to temporal interference"})
	}

	return c.Status(200).JSON(fiber.Map{
		"success":        true,
		"message":        "Vote cast in Quantum Buffer",
		"buffered_votes": newCount,
	})
}
