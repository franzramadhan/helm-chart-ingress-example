package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"database/sql"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

type Data struct {
	ID       int    `json:"id"`
	UID      string `json:"uid"`
	CoinName string `json:"coin_name"`
	Acronym  string `json:"acronym"`
	Logo     string `json:"logo"`
}

func getEnvWithDefault(key, defaultValue string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return defaultValue
}

func seedRandomData(w http.ResponseWriter, r *http.Request) {
	// database config
	dbHostname := getEnvWithDefault("DB_HOSTNAME", "localhost")
	dbPort := getEnvWithDefault("DB_PORT", "3306")
	dbName := getEnvWithDefault("DB_NAME", "test")
	dbTableName := getEnvWithDefault("DB_TABLE_NAME", "test")
	dbUser := getEnvWithDefault("DB_USER", "test")
	dbPassword := getEnvWithDefault("DB_PASSWORD", "test")

	client := http.Client{}

	// fetch random data
	req, err := http.NewRequest(http.MethodGet, "https://random-data-api.com/api/crypto_coin/random_crypto_coin", nil)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}

	res, err := client.Do(req)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}

	defer res.Body.Close()

	result := &Data{}

	fail := json.NewDecoder(res.Body).Decode(&result)
	if fail != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}

	// connect to DB and insert the data
	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPassword, dbHostname, dbPort, dbName))
	if err != nil {
		log.Fatalln(err)
	}
	defer db.Close()

	query, err := db.Query(fmt.Sprintf("INSERT INTO %s (id, uid, coin_name, acronym, logo ) VALUES ( %d, '%s', '%s', '%s', '%s' )", dbTableName, result.ID, result.UID, result.CoinName, result.Acronym, result.Logo))
	if err != nil {
		log.Println(err)
	}

	defer query.Close()

	// return results
	w.Header().Set("Content-Type", "application/json")

	resp, err := json.Marshal(&result)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}

func healthcheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	resp, err := json.Marshal(map[string]string{"status": "healthy"})
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Fatalln(err)
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", seedRandomData)
	router.HandleFunc("/healthz", healthcheck)
	log.Println("Listening on *:8080")
	logging := handlers.LoggingHandler(os.Stdout, router)
	log.Fatal(http.ListenAndServe(":8080", logging))
}
