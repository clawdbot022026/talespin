package handlers

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/talespin/backend/internal/auth"
	"github.com/talespin/backend/internal/database"
	"github.com/talespin/backend/internal/models"
	"golang.org/x/crypto/bcrypt"
)

type RegisterRequest struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// Register creates a new persistent user
func Register(c *fiber.Ctx) error {
	req := new(RegisterRequest)
	if err := c.BodyParser(req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid registration request"})
	}

	if len(req.Password) < 8 {
		return c.Status(400).JSON(fiber.Map{"error": "Password must be at least 8 characters long"})
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to encrypt credentials"})
	}

	// Pseudo-random PixelAvatar for style!
	avatarUrl := fmt.Sprintf("https://api.dicebear.com/7.x/pixel-art/png?seed=%s", req.Username)

	user := models.User{
		Username:     req.Username,
		Email:        req.Email,
		PasswordHash: string(hash),
		AvatarURL:    avatarUrl,
	}

	if err := database.DB.Create(&user).Error; err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Username or Email already registered in the Multiverse"})
	}

	token, err := auth.GenerateToken(user.ID.String(), user.Username)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to generate session token"})
	}

	return c.Status(201).JSON(fiber.Map{
		"success": true,
		"message": "Welcome to TaleSpin",
		"token":   token,
		"user":    user,
	})
}

// Login authenticates an existing user
func Login(c *fiber.Ctx) error {
	req := new(LoginRequest)
	if err := c.BodyParser(req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid login payload"})
	}

	var user models.User
	if err := database.DB.Where("username = ?", req.Username).First(&user).Error; err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Voyager not found"})
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		return c.Status(401).JSON(fiber.Map{"error": "Incorrect password"})
	}

	token, err := auth.GenerateToken(user.ID.String(), user.Username)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to issue quantum token"})
	}

	return c.Status(200).JSON(fiber.Map{
		"success": true,
		"token":   token,
		"user":    user,
	})
}

// GetProfile returns the currently authenticated user
func GetProfile(c *fiber.Ctx) error {
	userID, err := auth.ExtractUserID(c)
	if err != nil {
		return c.Status(401).JSON(fiber.Map{"error": "Unauthorized"})
	}

	var user models.User
	if err := database.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "User not found"})
	}

	return c.Status(200).JSON(fiber.Map{
		"success": true,
		"user":    user,
	})
}
