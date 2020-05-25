package data

import (
	"context"
	"fmt"
	"log"
	"time"
	auth "traceability/auth"
	db "traceability/database"

	guuid "github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Users is list of the User
type Users []*User

// User defines the structure for an API product
// swagger:model
type User struct {
	// the id for the user
	//
	// required: false
	ID string `json:"id"`

	// the name of the user
	//
	// required: true
	// max length: 30
	Name string `json:"name" validate:"required"`

	// the password of the user, it is stored as salted hash
	//
	// required: true
	Password string `json:"password"`

	// email
	//
	// required: true
	// pattern: @^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$
	Email string `json:"email" validate:"required"`

	// token
	//
	// required: false
	AccessToken string `json:"accessToken"`

	// role
	//
	// required: false
	Role string `json:"role"`

	// projects of the insect as list
	//
	// required: false
	ProjectIDs []string `json:"projectIDs,omitempty"`
}

// GetAllUsers returns all users
func GetAllUsers() Users {
	var result []*User

	collection := db.DB.Collection(db.UserCollectionName)
	cur, err := collection.Find(context.TODO(), bson.D{{}})

	if err != nil {
		log.Fatal(err)
	}

	// Finding multiple documents returns a cursor
	// Iterating through the cursor allows us to decode documents one at a time
	for cur.Next(context.TODO()) {
		var elem User
		err := cur.Decode(&elem)
		if err != nil {
			log.Fatal(err)
		}
		result = append(result, &elem)
	}

	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}

	cur.Close(context.TODO())

	return result
}

// AddUser adds a new user to the database
func AddUser(u User) {
	u.ID = guuid.New().String()
	u.Password = auth.HashAndSalt([]byte(u.Password))
	u.Role = "developer"

	collection := db.DB.Collection(db.UserCollectionName)
	insertResult, err := collection.InsertOne(context.TODO(), u)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)

	userList = append(userList, &u)
}

// FindUserByID returns user or error
func FindUserByID(id string) (User, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()

	collection := db.DB.Collection(db.UserCollectionName)

	// filter with internal id
	var resultUser User

	filter := bson.D{{"id", id}}
	err := collection.FindOne(ctx, filter).Decode(&resultUser)
	return resultUser, err
}

// FindUserAndUpdateAccessToken updates the user accesstoken
func FindUserAndUpdateAccessToken(user User) (bson.M, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()

	collection := db.DB.Collection(db.UserCollectionName)
	// filter with internal id
	filter := bson.M{"id": user.ID}

	// Create the update
	update := bson.M{
		"$set": bson.M{"accesstoken": user.AccessToken},
	}

	// Create an instance of an options and set the desired options
	upsert := true
	after := options.After
	opt := options.FindOneAndUpdateOptions{
		ReturnDocument: &after,
		Upsert:         &upsert,
	}

	// Find one result and update it
	result := collection.FindOneAndUpdate(ctx, filter, update, &opt)
	if result.Err() != nil {
		return nil, result.Err()
	}
	// Decode the result
	doc := bson.M{}
	decodeErr := result.Decode(&doc)
	return doc, decodeErr
}

var userList Users
