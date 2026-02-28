package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/talespin/backend/internal/auth"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/handlers"
	"github.com/talespin/backend/internal/workers"
)

func main() {
	// Initialize databases
	database.ConnectDB()
	database.ConnectRedis()

	// Start Background Workers
	workers.StartVoteFlusher()

	app := fiber.New()
	app.Use(logger.New())
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	api := app.Group("/api")

	api.Get("/health", func(c *fiber.Ctx) error {
		return c.Status(200).JSON(fiber.Map{"status": "ok", "message": "TaleSpin Multiverse API is running"})
	})

	api.Get("/stories/trending", handlers.GetTrendingStories)
	// Auth Routes (Public)
	authGroup := api.Group("/auth")
	authGroup.Post("/register", handlers.Register)
	authGroup.Post("/login", handlers.Login)

	// Protected Routes (Require JWT)
	protected := api.Group("/")
	protected.Use(auth.Protected())

	protected.Get("/me", handlers.GetProfile)
	protected.Post("/stories", handlers.CreateStory)
	protected.Post("/nodes/:id/branch", handlers.BranchNode)
	protected.Post("/nodes/:id/vote", handlers.VoteNode)

	log.Fatal(app.Listen(":8080"))
}
