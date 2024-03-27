package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

type response struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Build   string `json:"build"`
	Ip      string `json:"ip"`
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Default port if not specified
	}

	version := os.Getenv("APP_VERSION")
	build := os.Getenv("APP_BUILD")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Someone visited the main route!!!")

		resp := response{
			Name:    "echo-go",
			Version: version,
			Build:   build,
			Ip:      r.RemoteAddr,
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	})

	fmt.Printf("Listening on port %s. Version: '%s', Build: '%s'\n", port, version, build)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		panic(err)
	}
}
