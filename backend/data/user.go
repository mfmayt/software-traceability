package data

import (
	auth "traceability/auth"

	guuid "github.com/google/uuid"
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
	// required: true
	Role int `json:"role"`

	// projects of the insect as list
	//
	// required: false
	ProjectIDs []string `json:"projectIDs"`
}

// GetAllUsers returns all users
func GetAllUsers() Users {
	return userList
}

// AddUser adds a new user to the database
func AddUser(u User) {
	u.ID = guuid.New().String()
	u.Password = auth.HashAndSalt([]byte(u.Password))
	u.Role = 1
	userList = append(userList, &u)
}

var userList = []*User{
	{
		ID:   "askfhasuhfaskhfjaoiwruy981234yrqufh",
		Name: "Fatih",
	},
	{
		ID:   "askjfghasukfjhgrqiua24h12u34uyrhbahsfbn",
		Name: "Pinar",
	},
}
