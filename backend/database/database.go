package database

import "go.mongodb.org/mongo-driver/mongo"

const (
	// UserCollectionName is the table name of the users
	UserCollectionName = "users"

	// ProjectCollectionName is the table name of the projects
	ProjectCollectionName = "projects"

	// ArchViewCollectionName is the table name of the views
	ArchViewCollectionName = "archviews"
)

var (
	// DBCon is database connection
	DBCon *mongo.Client
	// DB is the database
	DB *mongo.Database
)
