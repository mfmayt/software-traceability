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

// Projects is list of the User
type Projects []*Project

// ProjectMember defines the members of a project
// swagger:model
type ProjectMember struct {
	// the id for the member
	//
	// required: false
	ID string `json:"id"`

	// role
	//
	// required: false
	Role string `json:"role"`
}

// Project defines the structure for an API project
// swagger:model
type Project struct {
	// the id for the project
	//
	// required: false
	ID string `json:"id"`

	// the name of the project
	//
	// required: true
	// max length: 30
	Name string `json:"name" validate:"required"`

	// id of the owner
	//
	// required: true
	Owner string `json:"owner"`

	// UserStoriesID
	//
	// required: true
	UserStoriesID string `json:"userStory" validate:"required"`

	// token
	//
	// required: false
	FuntionalViewID string `json:"functionalView"`

	// DevelopmentViewID
	//
	// required: false
	DevelopmentViewID string `json:"developmentView"`

	// Members of the project with roles
	//
	// required: false
	Members []ProjectMember `json:"members,omitempty"`
}

// GetAllProjects returns all projects
func GetAllProjects() Projects {
	var result Projects

	collection := db.DB.Collection(db.ProjectCollectionName)
	cur, err := collection.Find(context.TODO(), bson.D{{}})

	if err != nil {
		log.Fatal(err)
	}

	// Finding multiple documents returns a cursor
	// Iterating through the cursor allows us to decode documents one at a time
	for cur.Next(context.TODO()) {
		var elem Project
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

// AddProject adds a new project to the database
func AddProject(p Project, owner string) {
	var members []ProjectMember
	members = append(members, ProjectMember{ID: owner, Role: "owner"})
	p.Members = members
	p.ID = guuid.New().String()
	p.Owner = owner

	collection := db.DB.Collection(db.ProjectCollectionName)
	insertResult, err := collection.InsertOne(context.TODO(), p)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
}

// FindProjectByID returns user or error
func FindProjectByID(id string) (Project, error) {
	exp := 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), exp)
	defer cancel()

	collection := db.DB.Collection(db.ProjectCollectionName)

	// filter with internal id
	var resultProject Project

	filter := bson.D{primitive.E{Key: "id", Value: id}}
	err := collection.FindOne(ctx, filter).Decode(&resultProject)
	return resultProject, err
}

// FindMemberRoleInProject finds the role of the user in the projext
func FindMemberRoleInProject(projectID string, userID string) string {
	project, err := FindProjectByID(projectID)
	if err != nil {
		log.Fatal(err)
	}

	members := project.Members

	for _, v := range members {
		if v.ID == userID {
			return v.Role
		}
	}

	return "anonymos"
}

// UserHasPermission returns boolean value for about permission
func UserHasPermission(projectID string, userID string, permission string) bool {
	memberRole := FindMemberRoleInProject(projectID, userID)

	return permission == memberRole
}
