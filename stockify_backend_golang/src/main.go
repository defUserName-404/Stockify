package main

import (
	"fmt"
	"stockify_backend_golang/src/feature/item/model"
	"stockify_backend_golang/src/feature/item/repository"
	"stockify_backend_golang/src/feature/item/service"
	"time"
)

var itemRepository = repository.ItemRepositoryImplementation()
var itemService = service.ItemServiceImplementation(itemRepository)

func main() {
	//addItem()
	//updateItem()
	//deleteItem()

	for _, item := range itemService.GetAllItems() {
		fmt.Print(item.String() + "\n")
	}

	fmt.Println()
	fmt.Println()

	item := itemService.GetItemById(1)
	fmt.Print(item.String())
}

func addItem() {
	receivedTime := time.Now()
	hostName := "123"
	ipPort := "123"
	mac := "123"
	assignedToID := uint64(123)
	itemService.AddItem(model.Item{
		AssetNo:             "456",
		ModelNo:             "123",
		DeviceType:          model.PRINTER,
		SerialNo:            "123",
		ReceivedDate:        &receivedTime,
		WarrantyDate:        time.Date(2023, 1, 1, 0, 0, 0, 0, time.UTC),
		AssetStatus:         model.INACTIVE,
		HostName:            &hostName,
		IpPort:              &ipPort,
		MacAddress:          &mac,
		OsVersion:           nil,
		FacePlateName:       nil,
		SwitchPort:          nil,
		SwitchIpAddress:     nil,
		IsPasswordProtected: nil,
		AssignedToID:        &assignedToID,
	})
}

func deleteItem() {
	itemService.DeleteItemById(1)
}

func updateItem() {
	isPasswordProtected := false
	itemService.UpdateItem(model.Item{
		ID:                  4,
		IsPasswordProtected: &isPasswordProtected,
		AssetStatus:         model.ACTIVE,
	})
}
