package main

import (
	"fmt"
	"log"

	"github.com/sideshow/apns2"
	"github.com/sideshow/apns2/certificate"
)

func main() {

	cert, err := certificate.FromP12File("./notification_cert.p12", "")
	if err != nil {
		log.Fatal("Cert Error:", err)
	}

	notification := &apns2.Notification{
		DeviceToken: "308acbe1ef90d4872861598aab223057d1099e4112f1508380655b9d0dd19cd5",
		Topic:       "org.pluslab.notification",
		Payload:     []byte(`{"aps":{"alert":"Sex!!!"}}`),
	}

	client := apns2.NewClient(cert).Production()
	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n", res.StatusCode, res.ApnsID, res.Reason)
}
