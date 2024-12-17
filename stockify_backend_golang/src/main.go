package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"C"
	"encoding/json"
	"log"
	"stockify_backend_golang/src/feature/item/model"
	itemrepository "stockify_backend_golang/src/feature/item/repository"
	itemservice "stockify_backend_golang/src/feature/item/service"
	usermodel "stockify_backend_golang/src/feature/user/model"
	userrepository "stockify_backend_golang/src/feature/user/repository"
	userservice "stockify_backend_golang/src/feature/user/service"
	"time"
	"unsafe"
)

var itemRepository = itemrepository.ItemRepositoryImplementation()
var itemService = itemservice.ItemServiceImplementation(itemRepository)
var userRepository = userrepository.UserRepositoryImplementation()
var userService = userservice.UserServiceImplementation(userRepository)

func main() {
}

func AddUser(user usermodel.User) {
	userService.AddUser(user)
}

func GetAllUsers() []usermodel.User {
	return userService.GetAllUsers()
}

func GetUserById(id uint64) usermodel.User {
	return userService.GetUserById(id)
}

func UpdateUser(updatedUser usermodel.User) {
	userService.UpdateUser(updatedUser)
}

func DeleteUserById(id uint64) {
	userService.DeleteUserById(id)
}

func GetFilteredUsers(params usermodel.UserQueryParams) []usermodel.User {
	users, err := userService.GetFilteredUsers(params)
	if err != nil {
		log.Fatal(err)
	}
	return users
}

// Helper function: returns nil if the C string is empty, otherwise a pointer to the Go string.
func cStringOrNil(cStr *C.char) *string {
	s := C.GoString(cStr)
	if s == "" {
		return nil
	}
	return &s
}

//export AddItemFull
func AddItemFull(
	assetNo *C.char,
	modelNo *C.char,
	deviceType *C.char,
	serialNo *C.char,
	receivedDate C.longlong, // Unix timestamp (seconds)
	warrantyDate C.longlong, // Unix timestamp (seconds)
	assetStatus *C.char,
	hostName *C.char,
	ipPort *C.char,
	macAddress *C.char,
	osVersion *C.char,
	facePlateName *C.char,
	switchPort *C.char,
	switchIpAddress *C.char,
	isPasswordProtected C.int, // 0 or 1
	assignedToID C.ulonglong, // 0 if not assigned
) {
	// Convert received date (if provided)
	var receivedTime *time.Time
	if int64(receivedDate) > 0 {
		t := time.Unix(int64(receivedDate), 0)
		receivedTime = &t
	}

	// Convert warrantyDate (assume it must be provided)
	warrantyTime := time.Unix(int64(warrantyDate), 0)

	// Convert the boolean. Non-zero means true.
	b := isPasswordProtected != 0
	passwordProtected := &b

	// Convert assignedToID: if zero, treat as nil.
	var assignedTo *uint64
	if assignedToID != 0 {
		idVal := uint64(assignedToID)
		assignedTo = &idVal
	}

	item := model.Item{
		AssetNo:             C.GoString(assetNo),
		ModelNo:             C.GoString(modelNo),
		DeviceType:          model.DeviceType(C.GoString(deviceType)),
		SerialNo:            C.GoString(serialNo),
		ReceivedDate:        receivedTime,
		WarrantyDate:        warrantyTime,
		AssetStatus:         model.AssetStatus(C.GoString(assetStatus)),
		HostName:            cStringOrNil(hostName),
		IpPort:              cStringOrNil(ipPort),
		MacAddress:          cStringOrNil(macAddress),
		OsVersion:           cStringOrNil(osVersion),
		FacePlateName:       cStringOrNil(facePlateName),
		SwitchPort:          cStringOrNil(switchPort),
		SwitchIpAddress:     cStringOrNil(switchIpAddress),
		IsPasswordProtected: passwordProtected,
		AssignedToID:        assignedTo,
	}

	itemService.AddItem(item)
}

//export GetAllItems
func GetAllItems() *C.char {
	items := itemService.GetAllItems()
	jsonData, err := json.Marshal(items)
	if err != nil {
		return C.CString("[]")
	}
	return C.CString(string(jsonData))
}

//export GetItemById
func GetItemById(id C.ulonglong) *C.char {
	item := itemService.GetItemById(uint64(id))
	jsonData, err := json.Marshal(item)
	if err != nil {
		return C.CString("{}")
	}
	return C.CString(string(jsonData))
}

//export UpdateItemFull
func UpdateItemFull(
	id C.ulonglong,
	assetNo *C.char,
	modelNo *C.char,
	deviceType *C.char,
	serialNo *C.char,
	receivedDate C.longlong,
	warrantyDate C.longlong,
	assetStatus *C.char,
	hostName *C.char,
	ipPort *C.char,
	macAddress *C.char,
	osVersion *C.char,
	facePlateName *C.char,
	switchPort *C.char,
	switchIpAddress *C.char,
	isPasswordProtected C.int,
	assignedToID C.ulonglong,
) {
	var receivedTime *time.Time
	if int64(receivedDate) > 0 {
		t := time.Unix(int64(receivedDate), 0)
		receivedTime = &t
	}

	warrantyTime := time.Unix(int64(warrantyDate), 0)

	b := isPasswordProtected != 0
	passwordProtected := &b

	var assignedTo *uint64
	if assignedToID != 0 {
		idVal := uint64(assignedToID)
		assignedTo = &idVal
	}

	item := model.Item{
		ID:                  uint64(id),
		AssetNo:             C.GoString(assetNo),
		ModelNo:             C.GoString(modelNo),
		DeviceType:          model.DeviceType(C.GoString(deviceType)),
		SerialNo:            C.GoString(serialNo),
		ReceivedDate:        receivedTime,
		WarrantyDate:        warrantyTime,
		AssetStatus:         model.AssetStatus(C.GoString(assetStatus)),
		HostName:            cStringOrNil(hostName),
		IpPort:              cStringOrNil(ipPort),
		MacAddress:          cStringOrNil(macAddress),
		OsVersion:           cStringOrNil(osVersion),
		FacePlateName:       cStringOrNil(facePlateName),
		SwitchPort:          cStringOrNil(switchPort),
		SwitchIpAddress:     cStringOrNil(switchIpAddress),
		IsPasswordProtected: passwordProtected,
		AssignedToID:        assignedTo,
	}
	itemService.UpdateItem(item)
}

//export DeleteItemById
func DeleteItemById(id C.ulonglong) {
	itemService.DeleteItemById(uint64(id))
}

//export FreeCString
func FreeCString(str *C.char) {
	C.free(unsafe.Pointer(str))
}
