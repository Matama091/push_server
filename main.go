package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/sideshow/apns2"
	"github.com/sideshow/apns2/certificate"
)

type Payload struct {
	APS    APS    `json:"aps"`
	PathID string `json:"path_id"`
}

type APS struct {
	Alert            string `json:"alert"`
	ContentAvailable int    `json:"content-available"`
}

func main() {

	cert, err := certificate.FromP12File("./notification_cert.p12", "")
	if err != nil {
		log.Fatal("Cert Error:", err)
	}
	path_id := "12345678"

	payload := Payload{
		APS: APS{
			Alert:            "hello member",
			ContentAvailable: 1,
		},
		PathID: path_id,
	}

	data, err := json.Marshal(payload)
	if err != nil {
		log.Fatal("Json Error:", err)
	}

	notification := &apns2.Notification{
		DeviceToken: {device-token},
		Topic:       {app-domain},
		Payload:     []byte(data),
	}

	// select Develop or Production
	client := apns2.NewClient(cert).Development()

	fmt.Println("Host:", client.Host)
	fmt.Println("Token:", client.Token)
	fmt.Println("HTTP:", client.HTTPClient)
	fmt.Println("DeviceToken:", notification.DeviceToken)

	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n%v\n", res.StatusCode, res.ApnsID, res.Reason, err)
}
