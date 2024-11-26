package repository

import (
	"stockify_backend_golang/src/feature/item/model"
)

type itemRepository struct{}

func ItemRepositoryImplementation() ItemRepository {
	return &itemRepository{}
}

func (r *itemRepository) AddItem(item model.Item) {
	db.Create(&item)
}

func (r *itemRepository) GetAllItems() []model.Item {
	var items []model.Item
	db.Find(&items)
	return items
}

func (r *itemRepository) GetItemById(id string) model.Item {
	var item model.Item
	db.First(&item, id)
	return item
}

func (r *itemRepository) UpdateItem(item model.Item) {
	db.Select("IsPasswordProtected").Updates(&item)
}

func (r *itemRepository) DeleteItem(item model.Item) {
	db.Delete(&item)
}
