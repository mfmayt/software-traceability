package data

// Auth is the auth model
type Auth struct {
	// the email of the user
	//
	// required: true
	// max length: 30
	// pattern: @^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$
	Email string `json:"email" validate:"required"`

	// the password of the user
	//
	// required: false
	// max length: 30
	// min legnght: 6
	Password string `json:"password" validate:"required"`
}

var authList = []*Auth{
	{
		Email:    "fatih@fatih.com",
		Password: "111111",
	},
	{
		Email:    "pinar@pinar.com",
		Password: "222222",
	},
}
