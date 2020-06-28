package data

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"time"

	db "traceability/database"

	guuid "github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// ViewKind view of the kind
type ViewKind string

const (
	// UserStory is a type
	UserStory ViewKind = "userStory"
	// Functional is a type
	Functional ViewKind = "functional"
	// Development is a type
	Development ViewKind = "development"
	// None if something stupid happened
	None ViewKind = "none"
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
	Kind ViewKind `json:"kind" validate:"oneof=userStory functional development"`

	LinksList []string `json:"links,omitempty"`
	// Description
	// required: true
	Desctription string `json:"description" validate:"required"`

	// component belongs to view with id
	// required: true
	ViewID string `json:"viewID" validate:"required"`

	// component belongs to view with id
	// required: true
	ProjectID string `json:"projectID"`

	// TODO: add view id

	//FunctionList is used for development view to show functions of a component
	FunctionList []string `json:"functions,omitempty" bson:"functionlist,omitempty"`

	//VarList is used for development view to show variables of a component
	VarList []string `json:"variables,omitempty" bson:"omitempty"`

	// Drawing level of the component
	Level int `json:"level" bson:"level,omitmepty"`
}

// UnmarshalJSON parses from json
func (ac *ArchViewComponent) UnmarshalJSON(data []byte) error {
	// Define a secondary tycursive cape so that we don't end up with a rell to json.Unmarshal
	type Aux ArchViewComponent
	var a *Aux = (*Aux)(ac)
	err := json.Unmarshal(data, &a)
	if err != nil {
		return err
	}

	// Validate the valid enum values
	switch ac.Kind {
	case UserStory, Functional, Development, None:
		return nil
	default:
		ac.Kind = ""
		return errors.New("invalid value for Key")
	}
}

// ArchView general purpose architecture view
// swagger:model
type ArchView struct {
	// the id for the project
	//
	// required: false
	ID string `json:"id,omitempty"`

	// the name of the project
	//
	// required: true
	// max length: 30
	Name string `json:"name" validate:"required"`

	// belonging project's id
	//
	// required: true
	ProjectID string `json:"projectID" bson:"projectid,omitempty"`

	// Kind, "userStory", "functional", "development"
	//
	// required: false
	Kind string `json:"kind" validate:"oneof=userStory functional development"`

	// description
	//
	// required: false
	Desctription string `json:"description"`

	// Component IDs of the view
	//
	// required: false
	Components []string `json:"components,omitempty" bson:"components,omitmempty"`

	// UserKinds is a list of user story actors that are added
	//
	// required: false
	UserKinds []string `json:"userKinds,omitempty" bson:"userkinds,omitempty"`
}

// AddArchView adds a new project to the database
func AddArchView(v ArchView) (*ArchView, error) {
	v.ID = guuid.New().String()

	collection := db.DB.Collection(db.ArchViewCollectionName)

	insertResult, err := collection.InsertOne(context.TODO(), v)

	if err != nil {
		return &v, err
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
	return &v, nil
}

// FindArchViewsOfProject returns list of archviews to the belonging project
func FindArchViewsOfProject(projectID string) ([]*ArchView, error) {
	collection := db.DB.Collection(db.ArchViewCollectionName)
	filter := bson.D{primitive.E{Key: "projectid", Value: projectID}}
	cur, err := collection.Find(context.TODO(), filter)

	defer cur.Close(context.TODO())

	if err != nil {
		log.Fatal(err)
	}

	var result []*ArchView

	for cur.Next(context.TODO()) {
		var elem ArchView
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		result = append(result, &elem)
	}

	if err := cur.Err(); err != nil {
		return result, err
	}

	return result, nil
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
	archViewCollection := db.DB.Collection(db.ArchViewCollectionName)
	componentCollection := db.DB.Collection(db.ArchViewComponentCollectionName)

	query := bson.M{"id": archViewID}
	update := bson.M{"$push": bson.M{"components": c.ID}}

	updateResult, err := archViewCollection.UpdateOne(context.TODO(), query, update)
	insertResult, err := componentCollection.InsertOne(context.TODO(), c)

	if err != nil {
		panic(err)
	}

	fmt.Println("Upserted a single document:", updateResult, "\n Inserted a single document: ", insertResult)
}

// UpdateArchView replaces archview with new one
func UpdateArchView(a ArchView) error {
	archViewCollection := db.DB.Collection(db.ArchViewCollectionName)
	query := bson.M{"id": a.ID}

	replaceResult, err := archViewCollection.ReplaceOne(context.TODO(), query, a)
	fmt.Println("Replaced a single document:", replaceResult)
	return err
}

// UpdateArchViewComponent replaces component with new one
func UpdateArchViewComponent(ac ArchViewComponent) error {
	archViewComponentCollection := db.DB.Collection(db.ArchViewComponentCollectionName)
	query := bson.M{"id": ac.ID}

	replaceResult, err := archViewComponentCollection.ReplaceOne(context.TODO(), query, ac)
	fmt.Println("Replaced a single document:", replaceResult)
	return err
}

// FindArchViewComponentByID returns an ArchView or error
func FindArchViewComponentByID(id string) (ArchViewComponent, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()
	collection := db.DB.Collection(db.ArchViewComponentCollectionName)

	var resultComponent ArchViewComponent

	filter := bson.D{primitive.E{Key: "id", Value: id}}
	fmt.Println(id)
	err := collection.FindOne(ctx, filter).Decode(&resultComponent)
	return resultComponent, err
}

// FindArchViewComponentsByViewID returns an ArchView or error
func FindArchViewComponentsByViewID(id string) ([]ArchViewComponent, error) {
	collection := db.DB.Collection(db.ArchViewComponentCollectionName)
	filter := bson.D{primitive.E{Key: "viewid", Value: id}}
	cur, err := collection.Find(context.TODO(), filter)

	defer cur.Close(context.TODO())

	if err != nil {
		log.Fatal(err)
	}

	var result []ArchViewComponent

	for cur.Next(context.TODO()) {
		var elem ArchViewComponent
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		result = append(result, elem)
	}

	if err := cur.Err(); err != nil {
		return result, err
	}

	return result, nil
}

// FindArchViewComponentsByProjectID returns an ArchView or error
func FindArchViewComponentsByProjectID(id string) ([]ArchViewComponent, error) {
	collection := db.DB.Collection(db.ArchViewComponentCollectionName)
	filter := bson.D{primitive.E{Key: "projectid", Value: id}}
	cur, err := collection.Find(context.TODO(), filter)

	defer cur.Close(context.TODO())

	if err != nil {
		log.Fatal(err)
	}

	var result []ArchViewComponent

	for cur.Next(context.TODO()) {
		var elem ArchViewComponent
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		result = append(result, elem)
	}

	if err := cur.Err(); err != nil {
		return result, err
	}

	return result, nil
}
