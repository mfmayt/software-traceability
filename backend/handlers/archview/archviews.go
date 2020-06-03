package handlers

import (
	"fmt"
	"log"
	"traceability/data"
)

// KeyArchView is a key used for the arch view object in the context
type KeyArchView struct{}

// ArchViews handler
type ArchViews struct {
	l *log.Logger
	v *data.Validation
}

// NewArchViews returns a new users handler with the given logger
func NewArchViews(l *log.Logger, v *data.Validation) *ArchViews {
	return &ArchViews{l, v}
}

// ErrInvalidArchViewPath is an error message when the user path is not valid
var ErrInvalidArchViewPath = fmt.Errorf("Invalid Path, path should be /projects/[id]/views/[id]")

// GenericError is a generic error message returned by a server
type GenericError struct {
	Message string `json:"message"`
}

// ValidationError is a collection of validation error messages
type ValidationError struct {
	Messages []string `json:"messages"`
}
