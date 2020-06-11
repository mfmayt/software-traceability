package handlers

import (
	"fmt"
	"log"
	"traceability/data"
)

// KeyLink is a key used for the Link object in the context
type KeyLink struct{}

// Links handler
type Links struct {
	l *log.Logger
	v *data.Validation
}

// NewLinks returns a new users handler with the given logger
func NewLinks(l *log.Logger, v *data.Validation) *Links {
	return &Links{l, v}
}

// ErrInvalidProductPath is an error message when the user path is not valid
var ErrInvalidProductPath = fmt.Errorf("Invalid Path, path should be /links/[id]")

// GenericError is a generic error message returned by a server
type GenericError struct {
	Message string `json:"message"`
}

// ValidationError is a collection of validation error messages
type ValidationError struct {
	Messages []string `json:"messages"`
}
