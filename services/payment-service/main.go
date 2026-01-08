package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type PaymentReq struct {
	OrderID string  `json:"orderId"`
	Amount  float64 `json:"amount"`
}

type PaymentRes struct {
	Status  string `json:"status"`
	Message string `json:"message"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "UP", "service": "payment-service"})
}

func payHandler(w http.ResponseWriter, r *http.Request) {
	var req PaymentReq
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	res := PaymentRes{
		Status:  "SUCCESS",
		Message: "Payment processed for order " + req.OrderID,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(res)
}

func main() {
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/pay", payHandler)

	log.Println("Payment Service listening on port 8080")
	// nosemgrep: go.lang.security.audit.net.use-tls.use-tls
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
