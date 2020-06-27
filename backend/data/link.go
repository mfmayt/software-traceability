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
	// required: true
	ProjectID string `json:"projectID" validate:"required"`

	// is within view
	//
	// required: false
	InView bool `json:"inView"`
}

// FindAllProjectLinks returns all projects
func FindAllProjectLinks(projectID string) (Links, error) {
	var result Links

	collection := db.DB.Collection(db.LinkCollectionName)
	cur, err := collection.Find(context.TODO(), bson.D{{}})

	defer cur.Close(context.TODO())

	if err != nil {
		return result, err
	}

	for cur.Next(context.TODO()) {
		var elem Link
		err := cur.Decode(&elem)
		if err != nil {
			return result, err
		}
		result = append(result, &elem)
	}

	if err := cur.Err(); err != nil {
		return result, err
	}

	return result, nil
}

// FindAllLinks returns all projects
func FindAllLinks() Links {
	var result Links

	collection := db.DB.Collection(db.LinkCollectionName)
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
	collection := db.DB.Collection(db.LinkCollectionName)

	l.ID = guuid.New().String()
	l.InView = inView(l.To, l.From)
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

	collection := db.DB.Collection(db.LinkCollectionName)

	var resultLink Link

	filter := bson.D{primitive.E{Key: "id", Value: id}}
	err := collection.FindOne(ctx, filter).Decode(&resultLink)
	return resultLink, err
}

func FindLinkedComponents(id string) ([]ArchViewComponent, error) {
	linkCollection := db.DB.Collection(db.LinkCollectionName)
	componentCollection := db.DB.Collection(db.ArchViewComponentCollectionName)

	var result []string
	var ret []ArchViewComponent

	filter := bson.M{
		"$or": []interface{}{
			bson.M{"from": id},
			bson.M{"to": id},
		},
	}

	cur, err := linkCollection.Find(context.TODO(), filter)

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
		if elem.From == id {
			result = append(result, elem.To)
		} else {
			result = append(result, elem.From)
		}
	}
	filter = bson.M{"id": bson.M{"$in": result}}
	cur, err = componentCollection.Find(context.TODO(), filter)

	for cur.Next(context.TODO()) {
		var elem ArchViewComponent
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		ret = append(ret, elem)
	}

	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}
	return ret, err
}

func inView(toID string, fromID string) bool {
	c1, err := FindArchViewComponentByID(toID)
	c2, err := FindArchViewComponentByID(fromID)

	if err != nil {
		log.Fatal(err)
	}

	return c1.ViewID == c2.ViewID
}
