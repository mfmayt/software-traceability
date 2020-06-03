package handlers

import (
	"fmt"
	"log"
	data "traceability/data"
)

// KeyArchViewComponent is a key used for the arch view component object in the context
type KeyArchViewComponent struct{}

// ArchViewComponents handler
type ArchViewComponents struct {
	l *log.Logger
	v *data.Validation
}

// NewArchViewComponents returns a new components handler with the given logger
func NewArchViewComponents(l *log.Logger, v *data.Validation) *ArchViewComponents {
	return &ArchViewComponents{l, v}
}

// ErrInvalidArchViewComponentPath is an error message when the user path is not valid
var ErrInvalidArchViewComponentPath = fmt.Errorf("Invalid Path, path should be /projects/[id]/views/[id]")

// GenericError is a generic error message returned by a server
type GenericError struct {
	Message string `json:"message"`
}

// ValidationError is a collection of validation error messages
type ValidationError struct {
	Messages []string `json:"messages"`
}
