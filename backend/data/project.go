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

	// description
	//
	// required: false
	Description string `json:"description,omitempty" bson:"description,omitempty"`

	// id of the owner
	//
	// required: true
	Owner string `json:"owner"`

	// UserStoriesID
	//
	// required: false
	UserStoriesID string `json:"userStory"`

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

// GetAllUserProjects returns all projects
func GetAllUserProjects(userID string) Projects {

	var result Projects
	allProjects := GetAllProjects()

	for i, p := range allProjects {
		fmt.Println(i, p)
		for _, m := range p.Members {
			if m.ID == userID {
				result = append(result, p)
			}
		}
	}

	return result
}

// GetAllProjects returns all projects
func GetAllProjects() Projects {
	var result Projects

	collection := db.DB.Collection(db.ProjectCollectionName)
	cur, err := collection.Find(context.TODO(), bson.D{{}})

	defer cur.Close(context.TODO())

	if err != nil {
		log.Fatal(err)
	}

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

	return result
}

// AddProject adds a new project to the database
func AddProject(p Project, owner string) Project {
	var members []ProjectMember
	members = append(members, ProjectMember{ID: owner, Role: "owner"})
	p.Members = members
	p.ID = guuid.New().String()
	p.Owner = owner

	userStory := &ArchView{Name: "User Stories", Kind: "userStory", ProjectID: p.ID}
	functional := &ArchView{Name: "Functional", Kind: "functional", ProjectID: p.ID}
	development := &ArchView{Name: "Development", Kind: "development", ProjectID: p.ID}

	addedArchview, err := AddArchView(*userStory)
	p.UserStoriesID = addedArchview.ID
	addedArchview, err = AddArchView(*functional)
	p.FuntionalViewID = addedArchview.ID
	addedArchview, err = AddArchView(*development)
	p.DevelopmentViewID = addedArchview.ID

	rootFunctionalComponent := &ArchViewComponent{
		Kind:         "functional",
		Desctription: p.Name,
		ViewID:       p.FuntionalViewID,
		ProjectID:    p.ID,
		Level:        0,
	}

	AddArchViewComponent(*rootFunctionalComponent)

	collection := db.DB.Collection(db.ProjectCollectionName)
	insertResult, err := collection.InsertOne(context.TODO(), p)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Inserted a single document: ", insertResult.InsertedID)
	return p
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

// UpdateProject replaces archview with new
func UpdateProject(p Project) error {
	projectCollection := db.DB.Collection(db.ProjectCollectionName)
	query := bson.M{"id": p.ID}

	replaceResult, err := projectCollection.ReplaceOne(context.TODO(), query, p)
	fmt.Println("Replaced a single document:", replaceResult)
	return err
}
