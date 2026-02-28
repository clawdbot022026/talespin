package auth

import (
	"errors"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	jwtware "github.com/gofiber/jwt/v3"
	"github.com/golang-jwt/jwt/v4"
)

// In production, load this from .env
var jwtSecret = []byte(getSecret())

func getSecret() string {
	val := os.Getenv("JWT_SECRET")
	if val == "" {
		return "talespin_super_secret_dev_key_multiverse"
	}
	return val
}

func GenerateToken(userID string, username string) (string, error) {
	// Create token
	claims := jwt.MapClaims{
		"sub":      userID,
		"username": username,
		"exp":      time.Now().Add(time.Hour * 72).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Generate encoded token and send it as response.
	return token.SignedString(jwtSecret)
}

// Protected route middleware definition
func Protected() fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey:   jwtSecret,
		ErrorHandler: jwtError,
	})
}

func jwtError(c *fiber.Ctx, err error) error {
	if err.Error() == "Missing or malformed JWT" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Missing or malformed JWT Auth token",
		})
	}
	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"error": "Invalid or expired JWT Token",
	})
}

// ExtractUserID pulls the user ID out of the JWT that Fiber sets in context
func ExtractUserID(c *fiber.Ctx) (string, error) {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)

	sub, ok := claims["sub"].(string)
	if !ok {
		return "", errors.New("missing sub claim")
	}
	return sub, nil
}
