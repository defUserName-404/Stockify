package repository

import (
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
	"stockify_backend_golang/src/feature/item/model"
)

var db *gorm.DB

func init() {
	var err error
	db, err = gorm.Open(sqlite.Open("item.db"), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	err = db.AutoMigrate(&model.Item{})
	if err != nil {
		log.Fatal("Failed to auto migrate database:", err)
	}
}

type ItemRepository interface {
	GetAllItems() []model.Item
	GetItemById(id string) model.Item
	AddItem(item model.Item)
	UpdateItem(item model.Item)
	DeleteItem(item model.Item)
}
