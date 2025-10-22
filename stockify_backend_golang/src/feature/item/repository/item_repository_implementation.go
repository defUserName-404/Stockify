package repository

import (
	"log"
	"stockify_backend_golang/src/common/db"
	"stockify_backend_golang/src/feature/item/model"
	"time"
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
	db.DB.Preload("AssignedTo").Find(&items)
	return items
}

func (r *itemRepository) GetItemById(id uint64) model.Item {
	var item model.Item
	db.DB.Preload("AssignedTo").First(&item, id)
	return item
}

func (r *itemRepository) UpdateItem(item model.Item) {
	db.DB.Save(&item)
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
	query := db.DB.Model(&model.Item{}).Preload("AssignedTo")

	// Search filter
	if params.Search != "" {
		search := "%" + params.Search + "%"
		query = query.Where("LOWER(asset_no) LIKE LOWER(?) OR LOWER(model_no) LIKE LOWER(?) OR LOWER(serial_no) LIKE LOWER(?)",
			search, search, search)
	}

	// Device type filter
	if params.DeviceType != nil {
		query = query.Where("device_type = ?", *params.DeviceType)
	}

	// Asset status filter
	if params.AssetStatus != nil {
		query = query.Where("asset_status = ?", *params.AssetStatus)
	}

	// Assigned to filter
	if params.AssignedToID != nil && *params.AssignedToID != 0 {
		query = query.Where("assigned_to_id = ?", *params.AssignedToID)
	}

	// Warranty date filter
	if params.WarrantyDate != nil && *params.WarrantyDate != 0 && params.WarrantyDateFilterType != nil {
		filterDate := time.Unix(*params.WarrantyDate, 0)

		switch *params.WarrantyDateFilterType {
		case model.Day:
			// Same day
			startOfDay := time.Date(filterDate.Year(), filterDate.Month(), filterDate.Day(), 0, 0, 0, 0, filterDate.Location())
			endOfDay := startOfDay.Add(24 * time.Hour)
			query = query.Where("warranty_date >= ? AND warranty_date < ?", startOfDay.Unix(), endOfDay.Unix())
		case model.Month:
			// Same month
			startOfMonth := time.Date(filterDate.Year(), filterDate.Month(), 1, 0, 0, 0, 0, filterDate.Location())
			endOfMonth := startOfMonth.AddDate(0, 1, 0)
			query = query.Where("warranty_date >= ? AND warranty_date < ?", startOfMonth.Unix(), endOfMonth.Unix())
		case model.Year:
			// Same year
			startOfYear := time.Date(filterDate.Year(), 1, 1, 0, 0, 0, 0, filterDate.Location())
			endOfYear := startOfYear.AddDate(1, 0, 0)
			query = query.Where("warranty_date >= ? AND warranty_date < ?", startOfYear.Unix(), endOfYear.Unix())
		}
	}

	// IsExpiring filter
	if params.IsExpiring {
		thirtyDaysFromNow := time.Now().AddDate(0, 0, 30)
		query = query.Where("warranty_date <= ?", thirtyDaysFromNow.Unix())
	}

	// Sorting
	if params.SortBy != "" {
		order := "ASC"
		if params.SortOrder != "" {
			order = params.SortOrder
		}
		query = query.Order(params.SortBy + " " + order)
	}

	// Execute
	var items []model.Item
	if err := query.Find(&items).Error; err != nil {
		return nil, err
	}

	return items, nil
}
