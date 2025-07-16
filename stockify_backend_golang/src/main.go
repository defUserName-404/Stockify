package main

/*
#include <stdlib.h>
*/
import "C"
import (
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

// ========== User functions ==========

//export AddUser
func AddUser(userName, designation, sapId, ipPhone, roomNo, floor *C.char) {
	user := usermodel.User{
		UserName:    C.GoString(userName),
		Designation: cStringOrNil(designation),
		SapId:       cStringOrNil(sapId),
		IpPhone:     cStringOrNil(ipPhone),
		RoomNo:      cStringOrNil(roomNo),
		Floor:       cStringOrNil(floor),
	}
	userService.AddUser(user)
}

//export GetAllUsers
func GetAllUsers() *C.char {
	users := userService.GetAllUsers()
	jsonData, err := json.Marshal(users)
	if err != nil {
		return jsonError("Failed to marshal users")
	}
	return C.CString(string(jsonData))
}

//export GetUserById
func GetUserById(id C.ulonglong) *C.char {
	user := userService.GetUserById(uint64(id))
	if user.ID == 0 {
		return jsonError("User not found")
	}
	jsonData, err := json.Marshal(user)
	if err != nil {
		return jsonError("Failed to marshal user")
	}
	return C.CString(string(jsonData))
}

//export UpdateUser
func UpdateUser(id C.ulonglong, userName, designation, sapId, ipPhone, roomNo, floor *C.char) {
	user := usermodel.User{
		ID:          uint64(id),
		UserName:    C.GoString(userName),
		Designation: cStringOrNil(designation),
		SapId:       cStringOrNil(sapId),
		IpPhone:     cStringOrNil(ipPhone),
		RoomNo:      cStringOrNil(roomNo),
		Floor:       cStringOrNil(floor),
	}
	userService.UpdateUser(user)
}

//export DeleteUserById
func DeleteUserById(id C.ulonglong) {
	userService.DeleteUserById(uint64(id))
}

//export GetFilteredUsers
func GetFilteredUsers(search, sortBy, sortOrder *C.char) *C.char {
	params := usermodel.UserQueryParams{
		Search:    C.GoString(search),
		SortBy:    C.GoString(sortBy),
		SortOrder: C.GoString(sortOrder),
	}
	users, err := userService.GetFilteredUsers(params)
	if err != nil {
		log.Fatal(err)
	}
	jsonData, err := json.Marshal(users)
	if err != nil {
		return jsonError("Failed to marshal users")
	}
	return C.CString(string(jsonData))
}

// ========== Helper Functions ==========

// Converts C string to Go *string, returns nil if empty
func cStringOrNil(cStr *C.char) *string {
	s := C.GoString(cStr)
	if s == "" {
		return nil
	}
	return &s
}

// Quick helper to return JSON error
func jsonError(message string) *C.char {
	errorResponse := map[string]string{"error": message}
	jsonData, _ := json.Marshal(errorResponse)
	return C.CString(string(jsonData))
}

// ========== Item Functions ==========

//export AddItemFull
func AddItemFull(
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
		return jsonError("Failed to marshal items")
	}
	return C.CString(string(jsonData))
}

//export GetItemById
func GetItemById(id C.ulonglong) *C.char {
	item := itemService.GetItemById(uint64(id))
	if item.ID == 0 {
		return jsonError("Item not found")
	}
	jsonData, err := json.Marshal(item)
	if err != nil {
		return jsonError("Failed to marshal item")
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

//export GetFilteredItems
func GetFilteredItems(
	deviceType *C.char,
	assetStatus *C.char,
	warrantyDate C.longlong,
	search *C.char,
	sortBy *C.char,
	sortOrder *C.char,
) *C.char {
	searchStr := C.GoString(search)
	sortByStr := C.GoString(sortBy)
	sortOrderStr := C.GoString(sortOrder)
	params := model.ItemFilterParams{
		Search:    searchStr,
		SortBy:    sortByStr,
		SortOrder: sortOrderStr,
	}
	if dt := C.GoString(deviceType); dt != "" {
		tmp := model.DeviceType(dt)
		params.DeviceType = &tmp
	}
	if as := C.GoString(assetStatus); as != "" {
		tmp := model.AssetStatus(as)
		params.AssetStatus = &tmp
	}
	if int64(warrantyDate) != 0 {
		t := time.Unix(int64(warrantyDate), 0)
		params.WarrantyDate = &t
	}
	items, err := itemService.GetFilteredItems(params)
	if err != nil {
		return jsonError("Failed to filter items")
	}
	jsonData, err := json.Marshal(items)
	if err != nil {
		return jsonError("Failed to marshal items")
	}
	return C.CString(string(jsonData))
}

//export FreeCString
func FreeCString(str *C.char) {
	C.free(unsafe.Pointer(str))
}