package repository

import (
	"stockify_backend_golang/src/common/db"
	"stockify_backend_golang/src/feature/item/model"
)

var DB = db.DB

func init() {
	err := db.DB.AutoMigrate(&model.Item{})
	if err != nil {
		panic("Failed to migrate Item table: " + err.Error())
	}
}

type itemRepository struct{}

func ItemRepositoryImplementation() ItemRepository {
	return &itemRepository{}
}

func (r *itemRepository) AddItem(item model.Item) {
	DB.Create(&item)
}

func (r *itemRepository) GetAllItems() []model.Item {
	var items []model.Item
	DB.Find(&items)
	return items
}

func (r *itemRepository) GetItemById(id uint64) model.Item {
	var item model.Item
	DB.First(&item, id)
	return item
}

func (r *itemRepository) UpdateItem(item model.Item) {
	DB.Select("IsPasswordProtected").Updates(&item)
}

func (r *itemRepository) DeleteItemById(id uint64) {
	var item model.Item
	result := db.DB.First(&item, id)
	if result.Error != nil {
		panic("Item not found")
	}
	db.DB.Delete(&item)
}
