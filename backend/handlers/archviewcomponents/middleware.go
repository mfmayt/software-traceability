package handlers

import (
	"context"
	"fmt"
	"net/http"
	data "traceability/data"
)

// MiddlewareValidateArchViewComponent validates the component in the request and calls next if ok
func (ac *ArchViewComponents) MiddlewareValidateArchViewComponent(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		archViewComponent := &data.ArchViewComponent{}

		err := data.FromJSON(archViewComponent, r.Body)
		if err != nil {
			ac.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the component
		errs := ac.v.Validate(archViewComponent)
		if len(errs) != 0 {

			ac.l.Println("[ERROR] validating components", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the archview component to the context
		ctx := context.WithValue(r.Context(), KeyArchViewComponent{}, archViewComponent)
		r = r.WithContext(ctx)
		fmt.Println(ctx)
		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}
