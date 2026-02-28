package models

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID           uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey" json:"id"`
	Username     string    `gorm:"uniqueIndex;not null" json:"username"`
	Email        string    `gorm:"uniqueIndex;not null" json:"email"`
	PasswordHash string    `gorm:"not null" json:"-"` // Hidden from JSON responses
	AvatarURL    string    `json:"avatar_url"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Story struct {
	ID        uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey" json:"id"`
	Title     string    `gorm:"not null" json:"title"`
	Tags      string    `json:"tags"` // Comma-separated or JSON
	AuthorID  uuid.UUID `gorm:"type:uuid;not null" json:"author_id"`
	Author    User      `gorm:"foreignKey:AuthorID" json:"author"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Node struct {
	ID        uuid.UUID  `gorm:"type:uuid;default:gen_random_uuid();primaryKey" json:"id"`
	StoryID   uuid.UUID  `gorm:"type:uuid;not null;index" json:"story_id"`
	Story     Story      `gorm:"foreignKey:StoryID" json:"story"`
	ParentID  *uuid.UUID `gorm:"type:uuid" json:"parent_id"` // Nullable for genesis node
	Content   string     `gorm:"size:280;not null" json:"content"`
	AuthorID  uuid.UUID  `gorm:"type:uuid;not null" json:"author_id"`
	Author    User       `gorm:"foreignKey:AuthorID" json:"author"`
	Path      string     `gorm:"type:ltree;index" json:"path"` // the LTREE path
	VoteCount int        `gorm:"default:0;index" json:"vote_count"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
}
