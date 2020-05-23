package database

import "go.mongodb.org/mongo-driver/mongo"

var (
	// DBCon is database connection
	DBCon *mongo.Client
	// DB is the database
	DB *mongo.Database
)
