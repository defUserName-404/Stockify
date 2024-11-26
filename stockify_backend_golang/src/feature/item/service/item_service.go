package service

import (
	"stockify_backend_golang/src/feature/item/model"
)

type ItemService interface {
	AddItem(item model.Item)
	GetAllItems() []model.Item
	GetItemById(id string) model.Item
	UpdateItem(item model.Item)
	DeleteItem(item model.Item)
}
