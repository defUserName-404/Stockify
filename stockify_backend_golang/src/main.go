package main

import (
	"fmt"
	itemmodel "stockify_backend_golang/src/feature/item/model"
	itemrepository "stockify_backend_golang/src/feature/item/repository"
	itemservice "stockify_backend_golang/src/feature/item/service"
	usermodel "stockify_backend_golang/src/feature/user/model"
	userrepository "stockify_backend_golang/src/feature/user/repository"
	userservice "stockify_backend_golang/src/feature/user/service"
	"time"
)

var itemRepository = itemrepository.ItemRepositoryImplementation()
var itemService = itemservice.ItemServiceImplementation(itemRepository)
var userRepository = userrepository.UserRepositoryImplementation()
var userService = userservice.UserServiceImplementation(userRepository)

func main() {
	//addItem()
	//updateItem()
	//deleteItem()

	for _, item := range itemService.GetAllItems() {
		fmt.Print(item.String() + "\n")
	}

	fmt.Println()
	fmt.Println()
	//
	//item := itemService.GetItemById(1)
	//fmt.Print(item.String())
	//
	//deviceType := model.PRINTER
	//items, err := itemRepository.GetFilteredItems(itemrepository.ItemQueryParams{Search: "", Page: 1,
	//	PageSize:    10,
	//	SortBy:      "received_date",
	//	SortOrder:   "desc",
	//	DeviceType:  nil,
	//	AssetStatus: nil})
	//if err != nil {
	//	return
	//}
	//for _, item := range items {
	//	fmt.Print(item.String() + "\n")
	//}

	//addUser()
	//for _, user := range userService.GetAllUsers() {
	//	fmt.Print(user.String() + "\n")
	//}
}

func addUser() {
	userService.AddUser(usermodel.User{UserName: "John Smith"})
}

func addItem() {
	//receivedTime := time.Now()
	hostName := "123"
	ipPort := "123"
	mac := "123"
	assignedToID := uint64(1)
	itemService.AddItem(itemmodel.Item{
		AssetNo:             "123",
		ModelNo:             "456",
		DeviceType:          itemmodel.CPU,
		SerialNo:            "345",
		ReceivedDate:        nil,
		WarrantyDate:        time.Date(2023, 1, 1, 0, 0, 0, 0, time.UTC),
		AssetStatus:         itemmodel.INACTIVE,
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
	itemService.UpdateItem(itemmodel.Item{
		ID:                  4,
		IsPasswordProtected: &isPasswordProtected,
		AssetStatus:         itemmodel.ACTIVE,
	})
}
