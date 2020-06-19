package handlers

import (
	"context"
	"net/http"
	"traceability/data"
)

// MiddlewareValidateLink validates the link in the request and calls next if ok
func (l *Links) MiddlewareValidateLink(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {

		link := &data.Link{}

		err := data.FromJSON(link, r.Body)
		if err != nil {
			l.l.Println("[ERROR] deserializing link", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		errs := l.v.Validate(link)
		if len(errs) != 0 {

			l.l.Println("[ERROR] validating link", errs)

			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		ctx := context.WithValue(r.Context(), KeyLink{}, link)
		r = r.WithContext(ctx)

		next.ServeHTTP(rw, r)
	})
}
