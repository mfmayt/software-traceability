package handlers

import (
	"context"
	"net/http"
	"traceability/data"
)

// MiddlewareValidateProject validates the project in the request and calls next if ok
func (p *Projects) MiddlewareValidateProject(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {

		project := &data.Project{}

		err := data.FromJSON(project, r.Body)
		if err != nil {
			p.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the project
		errs := p.v.Validate(project)
		if len(errs) != 0 {

			p.l.Println("[ERROR] validating user", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the project to the context
		ctx := context.WithValue(r.Context(), KeyProject{}, project)
		r = r.WithContext(ctx)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}
