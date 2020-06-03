package handlers

import (
	"fmt"
	"log"
	"traceability/data"
)

// KeyProject is a key used for the Project object in the context
type KeyProject struct{}

// Projects handler
type Projects struct {
	l *log.Logger
	v *data.Validation
}

// NewProjects returns a new users handler with the given logger
func NewProjects(l *log.Logger, v *data.Validation) *Projects {
	return &Projects{l, v}
}

// ErrInvalidProductPath is an error message when the user path is not valid
var ErrInvalidProductPath = fmt.Errorf("Invalid Path, path should be /projects/[id]")

// GenericError is a generic error message returned by a server
type GenericError struct {
	Message string `json:"message"`
}

// ValidationError is a collection of validation error messages
type ValidationError struct {
	Messages []string `json:"messages"`
}
