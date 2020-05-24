package database

import "go.mongodb.org/mongo-driver/mongo"

const (
	// UserCollectionName is the table name of the users
	UserCollectionName = "users"
)

var (
	// DBCon is database connection
	DBCon *mongo.Client
	// DB is the database
	DB *mongo.Database
)
