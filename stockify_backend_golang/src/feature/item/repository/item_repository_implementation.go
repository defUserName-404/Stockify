package repository

import (
	"log"
	"stockify_backend_golang/src/common/db"
	"stockify_backend_golang/src/feature/item/model"
)

func init() {
	err := db.DB.AutoMigrate(&model.Item{})
	if err != nil {
		log.Fatal("Failed to migrate Item table: " + err.Error())
	}
}

type itemRepository struct{}

func ItemRepositoryImplementation() ItemRepository {
	return &itemRepository{}
}

func (r *itemRepository) AddItem(item model.Item) {
	db.DB.Create(&item)
}

func (r *itemRepository) GetAllItems() []model.Item {
	var items []model.Item
	db.DB.Find(&items)
	return items
}

func (r *itemRepository) GetItemById(id uint64) model.Item {
	var item model.Item
	db.DB.First(&item, id)
	return item
}

func (r *itemRepository) UpdateItem(item model.Item) {
	db.DB.Select("IsPasswordProtected").Updates(&item)
}

func (r *itemRepository) DeleteItemById(id uint64) {
	var item model.Item
	result := db.DB.First(&item, id)
	if result.Error != nil {
		log.Fatal("Item not found")
		return
	}
	db.DB.Delete(&item)
}

func (r *itemRepository) GetFilteredItems(params model.ItemFilterParams) ([]model.Item, error) {
	database := db.DB.Model(&model.Item{})
	// Filtering
	if params.DeviceType != nil {
		database = database.Where("device_type = ?", *params.DeviceType)
	}
	if params.AssetStatus != nil {
		database = database.Where("asset_status = ?", *params.AssetStatus)
	}
	if params.WarrantyDate != nil {
		database = database.Where("warranty_date = ?", *params.WarrantyDate)
	}
	// Searching
	if params.Search != "" {
		searchTerm := "%" + params.Search + "%"
		database = database.Where(
			"asset_no LIKE ?",
			searchTerm,
		).Or(
			"model_no LIKE ?",
			searchTerm,
		).Or(
			"serial_no LIKE ?",
			searchTerm,
		).Or("host_name LIKE ?", searchTerm).Or("ip_port LIKE ?", searchTerm).Or("mac_address LIKE ?", searchTerm)
	}
	// Sorting
	sortColumn := map[string]string{
		"asset_no":      "asset_no",
		"model_no":      "model_no",
		"serial_no":     "serial_no",
		"received_date": "received_date",
		"warranty_date": "warranty_date",
	}[params.SortBy]
	if sortColumn != "" {
		order := "ASC"
		if params.SortOrder == "DESC" {
			order = "DESC"
		}
		database = database.Order(sortColumn + " " + order)
	}
	// Pagination
	offset := (params.Page - 1) * params.PageSize
	database = database.Offset(offset).Limit(params.PageSize)
	// Execute
	var items []model.Item
	if err := database.Find(&items).Error; err != nil {
		return nil, err
	}
	return items, nil
}
