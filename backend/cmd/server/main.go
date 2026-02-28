package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/handlers"
)

func main() {
	// Initialize databases
	database.ConnectDB()
	database.ConnectRedis()

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
	api.Post("/stories", handlers.CreateStory)

	// TODO: Auth Routes
	// TODO: Node Routes

	log.Fatal(app.Listen(":8080"))
}
