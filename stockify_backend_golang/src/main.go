package main

import (
	"log"
	itemmodel "stockify_backend_golang/src/feature/item/model"
	itemrepository "stockify_backend_golang/src/feature/item/repository"
	itemservice "stockify_backend_golang/src/feature/item/service"
	usermodel "stockify_backend_golang/src/feature/user/model"
	userrepository "stockify_backend_golang/src/feature/user/repository"
	userservice "stockify_backend_golang/src/feature/user/service"
)

var itemRepository = itemrepository.ItemRepositoryImplementation()
var itemService = itemservice.ItemServiceImplementation(itemRepository)
var userRepository = userrepository.UserRepositoryImplementation()
var userService = userservice.UserServiceImplementation(userRepository)

func main() {
}

func addUser(user usermodel.User) {
	userService.AddUser(user)
}

func getAllUsers() []usermodel.User {
	return userService.GetAllUsers()
}

func getUserById(id uint64) usermodel.User {
	return userService.GetUserById(id)
}

func updateUser(updatedUser usermodel.User) {
	userService.UpdateUser(updatedUser)
}

func deleteUserById(id uint64) {
	userService.DeleteUserById(id)
}

func getFilteredUsers(params usermodel.UserQueryParams) []usermodel.User {
	users, err := userService.GetFilteredUsers(params)
	if err != nil {
		log.Fatal(err)
	}
	return users
}

func addItem(item itemmodel.Item) {
	itemService.AddItem(item)
}

func getAllItems() []itemmodel.Item {
	return itemService.GetAllItems()
}

func getItemById(id uint64) itemmodel.Item {
	return itemService.GetItemById(id)
}

func updateItem(updatedItem itemmodel.Item) {
	itemService.UpdateItem(updatedItem)
}
func deleteItem() {
	itemService.DeleteItemById(1)
}

func getFilteredItems(params itemmodel.ItemFilterParams) []itemmodel.Item {
	items, err := itemService.GetFilteredItems(params)
	if err != nil {
		log.Fatal(err)
	}
	return items
}
