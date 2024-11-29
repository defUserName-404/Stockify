package service

import "stockify_backend_golang/src/feature/item/model"

type ItemService interface {
	AddItem(item model.Item)
	GetAllItems() []model.Item
	GetItemById(id uint64) model.Item
	UpdateItem(item model.Item)
	DeleteItemById(id uint64)
}
