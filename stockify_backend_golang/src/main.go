package main

import (
	"fmt"
	model2 "stockify_backend_golang/src/feature/item/model"
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

	item := itemService.GetItemById("1")
	fmt.Print(item.String())
}

func addItem() {
	itemService.AddItem(model2.Item{
		AssetNo:             "456",
		ModelNo:             "123",
		DeviceType:          model2.PRINTER,
		SerialNo:            "123",
		ReceivedDate:        time.Now(),
		WarrantyDate:        time.Date(2023, 1, 1, 0, 0, 0, 0, time.UTC),
		AssetStatus:         model2.INACTIVE,
		HostName:            "123",
		IpPort:              "123",
		MacAddress:          "123",
		OsVersion:           "123",
		FacePlateName:       "123",
		SwitchPort:          "123",
		SwitchIpAddress:     "123",
		IsPasswordProtected: true,
		AssignedTo:          "123",
	})
}

func deleteItem() {
	itemService.DeleteItem(model2.Item{
		ID: "1",
	})
}

func updateItem() {
	itemService.UpdateItem(model2.Item{
		ID:                  "4",
		IsPasswordProtected: false,
		AssetStatus:         model2.ACTIVE,
	})
}
