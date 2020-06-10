package data

import (
	"context"
	"fmt"
	"log"
	"time"
	db "traceability/database"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Links is list of the Links
type Links []*Link

// Link defines the link between components
// swagger:model
type Link struct {
	// the id for the link
	//
	// required: true
	ID string `json:"id"`

	// from component with ID
	//
	// required: true
	From string `json:"from" validate:"required"`

	// to component with ID
	//
	// required: true
	To string `json:"to" validate:"required"`

	// kind of the relation
	//
	// required: true
	Kind string `json:"kind" validate:"required"`

	// id of the project
	//
	// require: true
	ProjectID string `json:"projectID" validate:"required"`
}

// GetAllProjectLinks returns all projects
func GetAllProjectLinks(projectID string) Links {
	var result Links

	collection := db.DB.Collection(db.ProjectCollectionName)
	cur, err := collection.Find(context.TODO(), bson.D{{}})

	defer cur.Close(context.TODO())

	if err != nil {
		log.Fatal(err)
	}

	for cur.Next(context.TODO()) {
		var elem Link
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		result = append(result, &elem)
	}

	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}

	return result
}

// AddLink adds a new link to the database
func AddLink(l Link) Link {
	collection := db.DB.Collection(db.ProjectCollectionName)
	insertResult, err := collection.InsertOne(context.TODO(), l)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
	return l
}

// FindLinkByID returns user or error
func FindLinkByID(id string) (Link, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()

	collection := db.DB.Collection(db.ProjectCollectionName)

	var resultLink Link

	filter := bson.D{primitive.E{Key: "id", Value: id}}
	err := collection.FindOne(ctx, filter).Decode(&resultLink)
	return resultLink, err
}
