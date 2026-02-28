package workers

import (
	"context"
	"log"
	"strconv"
	"strings"
	"time"

	"github.com/talespin/backend/internal/database"
)

// StartVoteFlusher initiates a background process to asynchronously flush votes from Redis to PostgreSQL
// This guarantees high throughput where 100,000 votes in a minute hit memory, but only hit disk in batches.
func StartVoteFlusher() {
	go func() {
		// Set to 5 seconds for Developer MVP speed. Should be 3-5 mins in Production.
		ticker := time.NewTicker(5 * time.Second)
		for range ticker.C {
			flushVotesToPostgres()
		}
	}()
}

func flushVotesToPostgres() {
	if database.RedisClient == nil || database.DB == nil {
		return
	}

	ctx := context.Background()

	var cursor uint64
	var keys []string

	// 1. Scan Redis for keys matching our vote pattern
	for {
		var batch []string
		var err error
		// Using SCAN instead of KEYS to not block Redis
		batch, cursor, err = database.RedisClient.Scan(ctx, cursor, "node:vote:*", 100).Result()
		if err != nil {
			log.Println("Redis Vote Buffer Scan error:", err)
			return
		}
		keys = append(keys, batch...)
		if cursor == 0 {
			break
		}
	}

	if len(keys) == 0 {
		return // Nothing waiting
	}

	for _, key := range keys {
		// key format is string: "node:vote:UUID"
		parts := strings.Split(key, ":")
		if len(parts) != 3 {
			continue
		}
		nodeID := parts[2]

		// 2. We use GETDEL to atomically fetch the value and delete the key at the same time
		voteStr, err := database.RedisClient.GetDel(ctx, key).Result()
		if err != nil || voteStr == "" {
			continue // Might have already been processed
		}

		votesCount, _ := strconv.Atoi(voteStr)
		if votesCount > 0 {
			// 3. Batch apply to PostgreSQL
			result := database.DB.Exec("UPDATE nodes SET vote_count = vote_count + ? WHERE id = ?", votesCount, nodeID)
			if result.Error == nil {
				log.Printf("[Flusher] Synced +%d votes to Node [%s] seamlessly to Postgres.\n", votesCount, nodeID)
			}
		}
	}
}
