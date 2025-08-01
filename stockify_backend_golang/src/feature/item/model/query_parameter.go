package model

import "time"

type ItemFilterParams struct {
	Search                 string
	DeviceType             *DeviceType
	AssetStatus            *AssetStatus
	WarrantyDate           *time.Time
	WarrantyDateFilterType string // "day", "month", "year"
	AssignedToID           *uint64
	SortBy                 string
	SortOrder              string
}
