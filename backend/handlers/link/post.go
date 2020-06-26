package handlers

import (
	"net/http"
	data "traceability/data"
)

// swagger:route POST
// Create a new link
//
// responses:
//	200: linkResponse
//  422: errorValidation
//  501: errorResponse

// AddLink handles POST requests to add new link
func (l *Links) AddLink(rw http.ResponseWriter, r *http.Request) {
	link := r.Context().Value(KeyLink{}).(*data.Link)
	l.l.Printf("[DEBUG] Inserting link: %#v\n", link)
	addedLink := data.AddLink(*link)
	l.l.Println(addedLink)
	data.ToJSON(addedLink, rw)
}
