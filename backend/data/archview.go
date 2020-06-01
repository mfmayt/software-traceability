package data

import (
	"context"
	"fmt"
	"log"
	"time"
	db "traceability/database"

	guuid "github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// ArchViewComponent is the component of a view
// swagger:model
type ArchViewComponent struct {
	// the id for the member
	//
	// required: false
	ID string `json:"id"`

	// UserKind is used for architecture user stories to make things simpler
	//
	// required: false
	UserKind string `json:"userKind"`

	// Kind, "userStory", "functional", "development"
	//
	// required: false
	Kind string `json:"kind" validate:"oneof=userStory functional development"`

	LinksList []string `json:"links,omitempty"`
	// required: true
	Desctription string `json:"description" validate:"required"`
	// component belongs to view with id
	// required: true
	ViewID string `json:"viewID" validate:"required"`
	//FunctionList is used for development view to show functions of a component
	FunctionList []string `json:"functions"`

	//VarList is used for development view to show variables of a component
	VarList []string `json:"variables"`

	// Comments will be in here
}

// ArchView general purpose architecture view
// swagger:model
type ArchView struct {
	// the id for the project
	//
	// required: false
	ID string `json:"id"`

	// the name of the project
	//
	// required: true
	// max length: 30
	Name string `json:"name" validate:"required"`

	// belonging project's id
	//
	// required: true
	ProjectID string `json:"projectID"`

	// Kind, "userStory", "functional", "development"
	//
	// required: false
	Kind string `json:"kind" validate:"oneof=userStory functional development"`

	// description
	//
	// required: false
	Desctription string `json:"description"`

	// Components of the view
	//
	// required: false
	Components []ArchViewComponent `json:"components,omitempty"`
}

// AddView adds a new project to the database
func AddView(v ArchView) {
	v.ID = guuid.New().String()

	collection := db.DB.Collection(db.ArchViewCollectionName)
	insertResult, err := collection.InsertOne(context.TODO(), v)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
}

// FindArchViewByID returns an ArchView or error
func FindArchViewByID(id string) (ArchView, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()

	collection := db.DB.Collection(db.ArchViewCollectionName)

	var resultArchView ArchView

	filter := bson.D{primitive.E{Key: "id", Value: id}}
	err := collection.FindOne(ctx, filter).Decode(&resultArchView)
	return resultArchView, err
}

// AddArchViewComponent adds component to the ArchView
func AddArchViewComponent(c ArchViewComponent) {
	c.ID = guuid.New().String()
	archViewID := c.ViewID
	collection := db.DB.Collection(db.ArchViewCollectionName)
	query := bson.M{"id": archViewID}

	bsonComponent, err := bson.Marshal(c)
	update := bson.M{"$push": bson.M{"components": bsonComponent}}

	updateResult, err := collection.UpdateOne(context.TODO(), query, update)

	if err != nil {
		panic(err)
	}

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", updateResult.UpsertedID)
}
