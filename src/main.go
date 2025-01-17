package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync/atomic"
)

type apiConfig struct {
	fileserverHits atomic.Int32
}

func (cfg *apiConfig) middleWareMetricsInc(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		cfg.fileserverHits.Add(1)
		prefix := "/app/"
		if strings.HasSuffix("/app", r.URL.Path) {
			prefix = "/app"
		}
		http.StripPrefix(prefix, next).ServeHTTP(w, r)
	})
}

func main() {
	mux := &http.ServeMux{}
	apiCfg := apiConfig{}
	handler := http.FileServer(http.Dir("."))

	mux.HandleFunc("GET /api/healthz", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "OK")
	})
	mux.HandleFunc("GET /admin/metrics", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "text/html")
		bytes, err := os.ReadFile("metrics.html")
		if err != nil {
			http.Error(w, "Server Error", 500)
		}
		fmt.Fprintf(w, string(bytes), apiCfg.fileserverHits.Load())
	})
	mux.Handle("/app/", apiCfg.middleWareMetricsInc(handler))
	mux.Handle("/app", apiCfg.middleWareMetricsInc(handler))
	mux.HandleFunc("POST /admin/reset", func(w http.ResponseWriter, r *http.Request) {
		apiCfg.fileserverHits.Store(0)
	})

	server := http.Server{
		Addr:    ":80",
		Handler: mux,
	}
	err := server.ListenAndServe()
	if err != nil {
		fmt.Println("Error:", err)
	}
}
