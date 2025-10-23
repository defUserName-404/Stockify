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
			query = query.Where("DATE(warranty_date) = DATE(?)", filterDate)
		case model.Month:
			// Same month and year
			query = query.Where("EXTRACT(YEAR FROM warranty_date) = ? AND EXTRACT(MONTH FROM warranty_date) = ?",
				filterDate.Year(), int(filterDate.Month()))
		case model.Year:
			// Same year
			query = query.Where("EXTRACT(YEAR FROM warranty_date) = ?", filterDate.Year())
		}
	}

	// IsExpiring filter (within 30 days but NOT yet expired)
	if params.IsExpiring {
		now := time.Now()
		// Normalize to start of today (ignore time)
		today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
		thirtyDaysFromNow := today.AddDate(0, 0, 30)
		// Compare only dates: warranty_date > today AND warranty_date <= today+30
		query = query.Where("DATE(warranty_date) > DATE(?) AND DATE(warranty_date) <= DATE(?)", today, thirtyDaysFromNow)
	}

	// IsExpired filter
	if params.IsExpired {
		now := time.Now()
		today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
		query = query.Where("DATE(warranty_date) < DATE(?)", today)
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
