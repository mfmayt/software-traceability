package handlers

import (
	"context"
	"net/http"
	"traceability/data"
)

// MiddlewareValidateArchView validates the project in the request and calls next if ok
func (aw *ArchViews) MiddlewareValidateArchView(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		archView := &data.ArchView{}

		err := data.FromJSON(archView, r.Body)
		if err != nil {
			aw.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the project
		errs := aw.v.Validate(archView)
		if len(errs) != 0 {

			aw.l.Println("[ERROR] validating user", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the archview to the context
		ctx := context.WithValue(r.Context(), KeyArchView{}, archView)
		r = r.WithContext(ctx)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}
