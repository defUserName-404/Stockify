package repository

import (
	"stockify_backend_golang/src/feature/item/model"
)

type ItemRepository interface {
	GetAllItems() []model.Item
	GetItemById(id uint64) model.Item
	AddItem(item model.Item)
	UpdateItem(item model.Item)
	DeleteItemById(id uint64)
	GetFilteredItems(params ItemQueryParams) ([]model.Item, error)
}
