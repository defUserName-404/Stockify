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

	//for _, item := range itemService.GetAllItems() {
	//	fmt.Print(item.String() + "\n")
	//}
	//fmt.Println()
	//fmt.Println()
	//
	//item := itemService.GetItemById(1)
	//fmt.Print(item.String())
	//
	getFilteredItems()

	//addUser()
	//getAllUsers()
	//getFilteredUsers()
}

func addUser() {
	userSapId := "123"
	userService.AddUser(usermodel.User{UserName: "Alice Smith", SapId: &userSapId})
}

func addItem() {
	assignedToID := uint64(1)
	itemService.AddItem(
		itemmodel.Item{
			AssetNo:      "6234",
			ModelNo:      "455589",
			DeviceType:   itemmodel.CPU,
			SerialNo:     "345544235",
			WarrantyDate: time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC),
			AssetStatus:  itemmodel.INACTIVE,
			AssignedToID: &assignedToID,
		},
	)
}

func getFilteredItems() {
	//deviceType := itemmodel.PRINTER
	//warrantyDate := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	items, err := itemService.GetFilteredItems(
		itemmodel.ItemFilterParams{
			Search: "", Page: 1,
			PageSize:  10,
			SortBy:    "model_no",
			SortOrder: "DESC",
		},
	)
	if err != nil {
		return
	}
	for _, item := range items {
		fmt.Print(item.String() + "\n")
	}
}

func deleteItem() {
	itemService.DeleteItemById(1)
}

func updateItem() {
	isPasswordProtected := false
	itemService.UpdateItem(
		itemmodel.Item{
			ID:                  4,
			IsPasswordProtected: &isPasswordProtected,
			AssetStatus:         itemmodel.ACTIVE,
		},
	)
}

func getAllUsers() {
	for _, user := range userService.GetAllUsers() {
		fmt.Print(user.String() + "\n")
	}
}

func getFilteredUsers() {
	users, err := userService.GetFilteredUsers(
		usermodel.UserQueryParams{
			Search: "", Page: 1, PageSize: 10, SortBy: "user_name", SortOrder: "ASC",
		},
	)
	if err != nil {
		return
	}
	for _, user := range users {
		fmt.Print(user.String() + "\n")
	}
}
