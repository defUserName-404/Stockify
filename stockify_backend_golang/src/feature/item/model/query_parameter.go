package model

import "time"

type ItemFilterParams struct {
	Search       string
	DeviceType   *DeviceType
	AssetStatus  *AssetStatus
	WarrantyDate *time.Time
	SortBy       string
	SortOrder    string
	Page         int
	PageSize     int
}
