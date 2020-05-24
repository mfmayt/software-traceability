package handlers

import (
	"context"
	"io"
	"net/http"
	authentication "traceability/auth"
	data "traceability/data"
	db "traceability/database"

	"go.mongodb.org/mongo-driver/bson"
	"golang.org/x/crypto/bcrypt"
)

// swagger:route POST /login users LoginUser
// Login the user
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// LoginUser handles POST requests to login the user
func (p *Users) LoginUser(rw http.ResponseWriter, r *http.Request) {
	auth := r.Context().Value(KeyAuth{}).(*data.Auth)
	p.l.Printf("[DEBUG] Login user: %#v\n", auth.Email)

	filter := bson.D{{"email", auth.Email}}
	collection := db.DB.Collection(db.UserCollectionName)

	var resultUser data.User
	queryResult := collection.FindOne(context.TODO(), filter)

	err := queryResult.Decode(&resultUser)
	if err != nil {
		rw.WriteHeader(http.StatusUnauthorized)
		io.WriteString(rw, `{{"error":"invalid email"}}`)
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(resultUser.Password),[]byte(auth.Password))

	if err != nil{
		rw.WriteHeader(http.StatusUnauthorized)
		io.WriteString(rw, `{{"error":"invalid_credentials"}}`)
		return
	}

	accessToken, err := authentication.CreateToken(auth.Email)
	
	if err != nil{
		rw.WriteHeader(http.StatusInternalServerError)
		io.WriteString(rw, `{{"error":"server is not working"}}`)
		return
	}

	resultUser.AccessToken = accessToken
	data.FindUserAndUpdateAccessToken(resultUser)
	io.WriteString(rw, `{}`)
	return
}
